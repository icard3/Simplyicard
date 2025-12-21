namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for paginated results
/// </summary>
/// <typeparam name="T">Type of data in the result</typeparam>
public class PagedResult<T>
{
    /// <summary>
    /// Collection of data items
    /// </summary>
    public IEnumerable<T> Data { get; set; } = new List<T>();
    
    /// <summary>
    /// Current page number
    /// </summary>
    public int PageNumber { get; set; }
    
    /// <summary>
    /// Page size
    /// </summary>
    public int PageSize { get; set; }
    
    /// <summary>
    /// Total number of records
    /// </summary>
    public int TotalRecords { get; set; }
    
    /// <summary>
    /// Total number of pages
    /// </summary>
    public int TotalPages { get; set; }
    
    /// <summary>
    /// Indicates if there's a previous page
    /// </summary>
    public bool HasPreviousPage => PageNumber > 1;
    
    /// <summary>
    /// Indicates if there's a next page
    /// </summary>
    public bool HasNextPage => PageNumber < TotalPages;
}