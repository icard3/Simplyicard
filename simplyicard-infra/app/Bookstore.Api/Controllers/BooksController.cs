using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Bookstore.Api.Services;
using Bookstore.Api.DTOs;

namespace Bookstore.Api.Controllers;

/// <summary>
/// Controller for book operations
/// </summary>
[ApiController]
[Route("api/v1/[controller]")]
[Produces("application/json")]
public class BooksController : BaseController
{
    private readonly IBookService _bookService;
    private readonly ILogger<BooksController> _logger;

    /// <summary>
    /// Constructor for BooksController
    /// </summary>
    /// <param name="bookService">Book service instance</param>
    /// <param name="logger">Logger instance</param>
    public BooksController(IBookService bookService, ILogger<BooksController> logger)
    {
        _bookService = bookService;
        _logger = logger;
    }

    /// <summary>
    /// Get all books with pagination and filtering
    /// </summary>
    /// <param name="filter">Pagination and filtering parameters</param>
    /// <returns>List of books</returns>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<BookDto>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetBooks([FromQuery] PaginationFilter filter)
    {
        _logger.LogInformation("Getting books with filter: {@Filter}", filter);
        
        var books = await _bookService.GetBooksAsync(filter);
        return PagedResult(books);
    }

    /// <summary>
    /// Get a book by ID
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>Book details</returns>
    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(BookDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetBook(int id)
    {
        _logger.LogInformation("Getting book with ID: {Id}", id);
        
        var book = await _bookService.GetBookByIdAsync(id);
        if (book == null)
        {
            return NotFound();
        }
        
        return Ok(book);
    }

    /// <summary>
    /// Create a new book
    /// </summary>
    /// <param name="createBookDto">Book creation data</param>
    /// <returns>Created book</returns>
    [HttpPost]
    [Authorize]
    [ProducesResponseType(typeof(BookDto), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateBook(CreateBookDto createBookDto)
    {
        _logger.LogInformation("Creating new book: {@Book}", createBookDto);
        
        try
        {
            var book = await _bookService.CreateBookAsync(createBookDto);
            return CreatedAtAction(nameof(GetBook), new { id = book.Id }, book);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating book: {Message}", ex.Message);
            return BadRequest(ex.Message);
        }
    }

    /// <summary>
    /// Update an existing book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <param name="updateBookDto">Book update data</param>
    /// <returns>Updated book</returns>
    [HttpPut("{id:int}")]
    [Authorize]
    [ProducesResponseType(typeof(BookDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateBook(int id, UpdateBookDto updateBookDto)
    {
        _logger.LogInformation("Updating book with ID {Id}: {@Book}", id, updateBookDto);
        
        try
        {
            var book = await _bookService.UpdateBookAsync(id, updateBookDto);
            return Ok(book);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating book: {Message}", ex.Message);
            return BadRequest(ex.Message);
        }
    }

    /// <summary>
    /// Delete a book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>No content</returns>
    [HttpDelete("{id:int}")]
    [Authorize]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteBook(int id)
    {
        _logger.LogInformation("Deleting book with ID: {Id}", id);
        
        var deleted = await _bookService.DeleteBookAsync(id);
        if (!deleted)
        {
            return NotFound();
        }
        
        return NoContent();
    }
}