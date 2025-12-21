using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using Microsoft.EntityFrameworkCore;
using BCrypt.Net;
using Bookstore.Api.Data;
using Bookstore.Api.Models;
using Bookstore.Api.DTOs;
using Google.Apis.Auth;

namespace Bookstore.Api.Services;

/// <summary>
/// Implementation of authentication service operations
/// </summary>
public class AuthService : IAuthService
{
    private readonly BookstoreContext _context;
    private readonly IConfiguration _configuration;
    
    /// <summary>
    /// Constructor for AuthService
    /// </summary>
    /// <param name="context">Database context</param>
    /// <param name="configuration">Application configuration</param>
    public AuthService(BookstoreContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }
    
    /// <summary>
    /// Authenticate a user
    /// </summary>
    /// <param name="loginDto">Login credentials</param>
    /// <returns>Authentication response with token</returns>
    public async Task<AuthResponseDto?> AuthenticateAsync(LoginDto loginDto)
    {
        // Find user by username
        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Username == loginDto.Username);
            
        // Check if user exists and password is correct
        if (user == null || !BCrypt.Net.BCrypt.Verify(loginDto.Password, user.PasswordHash))
        {
            return null;
        }
        
        // Generate JWT token
        var token = GenerateJwtToken(user);
        
        return new AuthResponseDto
        {
            Token = token,
            Username = user.Username,
            Role = user.Role,
            ExpiresAt = DateTime.UtcNow.AddHours(1) // Token expires in 1 hour
        };
    }
    
    /// <summary>
    /// Register a new user
    /// </summary>
    /// <param name="registerDto">Registration data</param>
    /// <returns>Authentication response with token</returns>
    public async Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto)
    {
        // Check if username already exists
        var existingUser = await _context.Users
            .AnyAsync(u => u.Username == registerDto.Username);
            
        if (existingUser)
        {
            throw new InvalidOperationException("Username already exists");
        }
        
        // Hash password
        var passwordHash = BCrypt.Net.BCrypt.HashPassword(registerDto.Password);
        
        // Create new user
        var user = new User
        {
            Username = registerDto.Username,
            Email = registerDto.Email,
            PasswordHash = passwordHash,
            Role = "User", // Default role for new users
            CreatedAt = DateTime.UtcNow
        };
        
        _context.Users.Add(user);
        await _context.SaveChangesAsync();
        
        // Generate JWT token
        var token = GenerateJwtToken(user);
        
        return new AuthResponseDto
        {
            Token = token,
            Username = user.Username,
            Role = user.Role,
            ExpiresAt = DateTime.UtcNow.AddHours(1) // Token expires in 1 hour
        };
    }
    
    /// <summary>
    /// Authenticate a user with Google
    /// </summary>
    /// <param name="googleLoginDto">Google login data</param>
    /// <returns>Authentication response with token</returns>
    public async Task<AuthResponseDto?> AuthenticateWithGoogleAsync(GoogleLoginDto googleLoginDto)
    {
        try
        {
            // Verify the Google access token
            var payload = await GoogleJsonWebSignature.ValidateAsync(googleLoginDto.IdToken);
            
            // Check if the token is valid and issued to our client
            if (payload.Audience != _configuration["Google:ClientId"])
            {
                return null;
            }
            
            // Check if user already exists
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == payload.Email);
            
            // If user doesn't exist, create a new one
            if (user == null)
            {
                user = new User
                {
                    Username = GenerateUsernameFromEmail(payload.Email),
                    Email = payload.Email,
                    PasswordHash = "", // No password for Google users
                    Role = "User", // Default role
                    CreatedAt = DateTime.UtcNow
                };
                
                _context.Users.Add(user);
                await _context.SaveChangesAsync();
            }
            
            // Generate JWT token
            var token = GenerateJwtToken(user);
            
            return new AuthResponseDto
            {
                Token = token,
                Username = user.Username,
                Role = user.Role,
                ExpiresAt = DateTime.UtcNow.AddHours(1) // Token expires in 1 hour
            };
        }
        catch (Exception)
        {
            // Invalid token or other error
            return null;
        }
    }
    
    /// <summary>
    /// Generate JWT token for a user
    /// </summary>
    /// <param name="user">User to generate token for</param>
    /// <returns>JWT token string</returns>
    private string GenerateJwtToken(User user)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"] ?? "default_secret_key_12345");
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Role, user.Role)
            }),
            Expires = DateTime.UtcNow.AddHours(1),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
    
    /// <summary>
    /// Generate a username from an email address
    /// </summary>
    /// <param name="email">Email address</param>
    /// <returns>Generated username</returns>
    private string GenerateUsernameFromEmail(string email)
    {
        var username = email.Split('@')[0];
        
        // Ensure username is unique
        var existingUser = _context.Users
            .Any(u => u.Username == username);
            
        if (existingUser)
        {
            // Append a number to make it unique
            var counter = 1;
            var uniqueUsername = username;
            while (_context.Users.Any(u => u.Username == uniqueUsername))
            {
                uniqueUsername = $"{username}{counter}";
                counter++;
            }
            username = uniqueUsername;
        }
        
        return username;
    }
}