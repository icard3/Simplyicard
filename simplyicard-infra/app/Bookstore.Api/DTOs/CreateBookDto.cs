using System.ComponentModel.DataAnnotations;

namespace Bookstore.Api.DTOs;

/// <summary>
/// Data Transfer Object for creating a new book
/// </summary>
public class CreateBookDto
{
    /// <summary>
    /// Title of the book (required)
    /// </summary>
    [Required]
    public string Title { get; set; } = string.Empty;
    
    /// <summary>
    /// Author of the book (required)
    /// </summary>
    [Required]
    public string Author { get; set; } = string.Empty;
    
    /// <summary>
    /// ISBN number of the book (required)
    /// </summary>
    [Required]
    public string ISBN { get; set; } = string.Empty;
    
    /// <summary>
    /// Price of the book (must be positive)
    /// </summary>
    [Range(0.01, double.MaxValue, ErrorMessage = "Price must be greater than 0")]
    public decimal Price { get; set; }
    
    /// <summary>
    /// Date when the book was published
    /// </summary>
    public DateTime PublishedDate { get; set; }
    
    /// <summary>
    /// Genre of the book
    /// </summary>
    public string Genre { get; set; } = string.Empty;
    
    /// <summary>
    /// Description of the book
    /// </summary>
    public string Description { get; set; } = string.Empty;
    
    /// <summary>
    /// Number of pages in the book (must be positive)
    /// </summary>
    [Range(1, int.MaxValue, ErrorMessage = "Page count must be greater than 0")]
    public int PageCount { get; set; }
}