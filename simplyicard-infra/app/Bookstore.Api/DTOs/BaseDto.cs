namespace Bookstore.Api.DTOs;

/// <summary>
/// Base class for all DTOs
/// </summary>
public abstract class BaseDto
{
    /// <summary>
    /// Unique identifier
    /// </summary>
    public int Id { get; set; }
}