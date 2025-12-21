namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for authentication response
/// </summary>
public class AuthResponseDto
{
    /// <summary>
    /// Authentication token
    /// </summary>
    public string Token { get; set; } = string.Empty;
    
    /// <summary>
    /// User's username
    /// </summary>
    public string Username { get; set; } = string.Empty;
    
    /// <summary>
    /// User's role
    /// </summary>
    public string Role { get; set; } = string.Empty;
    
    /// <summary>
    /// Token expiration date
    /// </summary>
    public DateTime ExpiresAt { get; set; }
}