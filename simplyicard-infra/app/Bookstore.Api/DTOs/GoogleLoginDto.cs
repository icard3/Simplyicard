namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for Google login request
/// </summary>
public class GoogleLoginDto
{
    /// <summary>
    /// Google access token
    /// </summary>
    public string IdToken { get; set; } = string.Empty;
}