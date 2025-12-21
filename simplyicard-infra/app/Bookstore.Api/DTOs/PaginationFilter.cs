namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for pagination parameters
/// </summary>
public class PaginationFilter
{
    /// <summary>
    /// Page number (default: 1)
    /// </summary>
    public int PageNumber { get; set; } = 1;
    
    /// <summary>
    /// Page size (default: 10, max: 100)
    /// </summary>
    public int PageSize { get; set; } = 10;
    
    /// <summary>
    /// Search term for filtering
    /// </summary>
    public string? SearchTerm { get; set; }
    
    /// <summary>
    /// Field to sort by
    /// </summary>
    public string? SortBy { get; set; }
    
    /// <summary>
    /// Sort direction (asc/desc)
    /// </summary>
    public string? SortOrder { get; set; }
}