using System.ComponentModel.DataAnnotations;

namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for user login
/// </summary>
public class LoginDto
{
    /// <summary>
    /// Username (required)
    /// </summary>
    [Required]
    public string Username { get; set; } = string.Empty;
    
    /// <summary>
    /// Password (required)
    /// </summary>
    [Required]
    public string Password { get; set; } = string.Empty;
}