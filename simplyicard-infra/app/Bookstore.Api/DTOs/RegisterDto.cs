using System.ComponentModel.DataAnnotations;

namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for user registration
/// </summary>
public class RegisterDto
{
    /// <summary>
    /// Username (required)
    /// </summary>
    [Required]
    public string Username { get; set; } = string.Empty;
    
    /// <summary>
    /// Email address (required)
    /// </summary>
    [Required]
    [EmailAddress]
    public string Email { get; set; } = string.Empty;
    
    /// <summary>
    /// Password (required)
    /// </summary>
    [Required]
    [MinLength(6, ErrorMessage = "Password must be at least 6 characters long")]
    public string Password { get; set; } = string.Empty;
}