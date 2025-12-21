using Microsoft.AspNetCore.Mvc;
using Bookstore.Api.Services;
using Bookstore.Api.DTOs;

namespace Bookstore.Api.Controllers;

/// <summary>
/// Controller for authentication operations
/// </summary>
[ApiController]
[Route("api/v1/[controller]")]
[Produces("application/json")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly ILogger<AuthController> _logger;

    /// <summary>
    /// Constructor for AuthController
    /// </summary>
    /// <param name="authService">Authentication service instance</param>
    /// <param name="logger">Logger instance</param>
    public AuthController(IAuthService authService, ILogger<AuthController> logger)
    {
        _authService = authService;
        _logger = logger;
    }

    /// <summary>
    /// Authenticate a user
    /// </summary>
    /// <param name="loginDto">Login credentials</param>
    /// <returns>Authentication response with token</returns>
    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> Login(LoginDto loginDto)
    {
        _logger.LogInformation("User login attempt for username: {Username}", loginDto.Username);
        
        var result = await _authService.AuthenticateAsync(loginDto);
        if (result == null)
        {
            return Unauthorized(new ProblemDetails
            {
                Title = "Unauthorized",
                Detail = "Invalid username or password",
                Status = StatusCodes.Status401Unauthorized
            });
        }
        
        return Ok(result);
    }

    /// <summary>
    /// Register a new user
    /// </summary>
    /// <param name="registerDto">Registration data</param>
    /// <returns>Authentication response with token</returns>
    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Register(RegisterDto registerDto)
    {
        _logger.LogInformation("User registration attempt for username: {Username}", registerDto.Username);
        
        try
        {
            var result = await _authService.RegisterAsync(registerDto);
            return CreatedAtAction(nameof(Login), result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new ProblemDetails
            {
                Title = "Registration Failed",
                Detail = ex.Message,
                Status = StatusCodes.Status400BadRequest
            });
        }
    }
    
    /// <summary>
    /// Authenticate a user with Google
    /// </summary>
    /// <param name="googleLoginDto">Google login data</param>
    /// <returns>Authentication response with token</returns>
    [HttpPost("google-login")]
    [ProducesResponseType(typeof(AuthResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GoogleLogin(GoogleLoginDto googleLoginDto)
    {
        _logger.LogInformation("User Google login attempt");
        
        var result = await _authService.AuthenticateWithGoogleAsync(googleLoginDto);
        if (result == null)
        {
            return Unauthorized(new ProblemDetails
            {
                Title = "Unauthorized",
                Detail = "Invalid Google token",
                Status = StatusCodes.Status401Unauthorized
            });
        }
        
        return Ok(result);
    }
}