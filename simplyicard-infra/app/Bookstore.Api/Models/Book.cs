using System.ComponentModel.DataAnnotations;

namespace Bookstore.Api.Models;

/// <summary>
/// Represents a book in the bookstore
/// </summary>
public class Book
{
    /// <summary>
    /// Unique identifier for the book
    /// </summary>
    public int Id { get; set; }
    
    /// <summary>
    /// Title of the book
    /// </summary>
    public string Title { get; set; } = string.Empty;
    
    /// <summary>
    /// Author of the book
    /// </summary>
    public string Author { get; set; } = string.Empty;
    
    /// <summary>
    /// ISBN number of the book
    /// </summary>
    public string ISBN { get; set; } = string.Empty;
    
    /// <summary>
    /// Price of the book
    /// </summary>
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
    /// Number of pages in the book
    /// </summary>
    public int PageCount { get; set; }
}