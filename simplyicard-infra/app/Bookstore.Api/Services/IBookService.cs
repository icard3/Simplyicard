using Bookstore.Api.Models;
using Bookstore.Api.DTOs;

namespace Bookstore.Api.Services;

/// <summary>
/// Interface for book service operations
/// </summary>
public interface IBookService
{
    /// <summary>
    /// Get all books with pagination and filtering
    /// </summary>
    /// <param name="filter">Pagination and filtering parameters</param>
    /// <returns>Paginated result of books</returns>
    Task<PagedResult<BookDto>> GetBooksAsync(PaginationFilter filter);
    
    /// <summary>
    /// Get a book by ID
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>Book DTO</returns>
    Task<BookDto?> GetBookByIdAsync(int id);
    
    /// <summary>
    /// Create a new book
    /// </summary>
    /// <param name="createBookDto">Book creation data</param>
    /// <returns>Created book DTO</returns>
    Task<BookDto> CreateBookAsync(CreateBookDto createBookDto);
    
    /// <summary>
    /// Update an existing book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <param name="updateBookDto">Book update data</param>
    /// <returns>Updated book DTO</returns>
    Task<BookDto> UpdateBookAsync(int id, UpdateBookDto updateBookDto);
    
    /// <summary>
    /// Delete a book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>True if deleted, false if not found</returns>
    Task<bool> DeleteBookAsync(int id);
}