using Bookstore.Api.DTOs;

namespace Bookstore.Api.Services;

/// <summary>
/// Interface for authentication service operations
/// </summary>
public interface IAuthService
{
    /// <summary>
    /// Authenticate a user
    /// </summary>
    /// <param name="loginDto">Login credentials</param>
    /// <returns>Authentication response with token</returns>
    Task<AuthResponseDto?> AuthenticateAsync(LoginDto loginDto);
    
    /// <summary>
    /// Register a new user
    /// </summary>
    /// <param name="registerDto">Registration data</param>
    /// <returns>Authentication response with token</returns>
    Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto);
    
    /// <summary>
    /// Authenticate a user with Google
    /// </summary>
    /// <param name="googleLoginDto">Google login data</param>
    /// <returns>Authentication response with token</returns>
    Task<AuthResponseDto?> AuthenticateWithGoogleAsync(GoogleLoginDto googleLoginDto);
}