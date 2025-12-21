using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Bookstore.Api.Data;
using Bookstore.Api.Models;
using Bookstore.Api.DTOs;
using Bookstore.Api.Extensions;

namespace Bookstore.Api.Services;

/// <summary>
/// Implementation of book service operations
/// </summary>
public class BookService : IBookService
{
    private readonly BookstoreContext _context;
    private readonly IMapper _mapper;
    
    /// <summary>
    /// Constructor for BookService
    /// </summary>
    /// <param name="context">Database context</param>
    /// <param name="mapper">AutoMapper instance</param>
    public BookService(BookstoreContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }
    
    /// <summary>
    /// Get all books with pagination and filtering
    /// </summary>
    /// <param name="filter">Pagination and filtering parameters</param>
    /// <returns>Paginated result of books</returns>
    public async Task<PagedResult<BookDto>> GetBooksAsync(PaginationFilter filter)
    {
        var query = _context.Books.AsQueryable();
        
        // Apply search filter if provided
        if (!string.IsNullOrWhiteSpace(filter.SearchTerm))
        {
            query = query.Where(b => 
                b.Title.Contains(filter.SearchTerm) || 
                b.Author.Contains(filter.SearchTerm) ||
                b.Genre.Contains(filter.SearchTerm));
        }
        
        // Apply sorting
        if (!string.IsNullOrWhiteSpace(filter.SortBy))
        {
            query = filter.SortBy.ToLower() switch
            {
                "title" => filter.SortOrder?.ToLower() == "desc" 
                    ? query.OrderByDescending(b => b.Title) 
                    : query.OrderBy(b => b.Title),
                "author" => filter.SortOrder?.ToLower() == "desc" 
                    ? query.OrderByDescending(b => b.Author) 
                    : query.OrderBy(b => b.Author),
                "price" => filter.SortOrder?.ToLower() == "desc" 
                    ? query.OrderByDescending(b => b.Price) 
                    : query.OrderBy(b => b.Price),
                "publisheddate" => filter.SortOrder?.ToLower() == "desc" 
                    ? query.OrderByDescending(b => b.PublishedDate) 
                    : query.OrderBy(b => b.PublishedDate),
                _ => query.OrderBy(b => b.Id)
            };
        }
        else
        {
            // Default sorting by ID
            query = query.OrderBy(b => b.Id);
        }
        
        // Apply pagination
        var pagedResult = await query.ToPagedResultAsync(filter);
        
        // Map to DTOs
        var bookDtos = _mapper.Map<IEnumerable<BookDto>>(pagedResult.Data);
        
        return new PagedResult<BookDto>
        {
            Data = bookDtos,
            PageNumber = pagedResult.PageNumber,
            PageSize = pagedResult.PageSize,
            TotalRecords = pagedResult.TotalRecords,
            TotalPages = pagedResult.TotalPages
        };
    }
    
    /// <summary>
    /// Get a book by ID
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>Book DTO</returns>
    public async Task<BookDto?> GetBookByIdAsync(int id)
    {
        var book = await _context.Books.FindAsync(id);
        return book == null ? null : _mapper.Map<BookDto>(book);
    }
    
    /// <summary>
    /// Create a new book
    /// </summary>
    /// <param name="createBookDto">Book creation data</param>
    /// <returns>Created book DTO</returns>
    public async Task<BookDto> CreateBookAsync(CreateBookDto createBookDto)
    {
        var book = _mapper.Map<Book>(createBookDto);
        book.PublishedDate = createBookDto.PublishedDate == DateTime.MinValue 
            ? DateTime.UtcNow 
            : createBookDto.PublishedDate;
            
        _context.Books.Add(book);
        await _context.SaveChangesAsync();
        
        return _mapper.Map<BookDto>(book);
    }
    
    /// <summary>
    /// Update an existing book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <param name="updateBookDto">Book update data</param>
    /// <returns>Updated book DTO</returns>
    public async Task<BookDto> UpdateBookAsync(int id, UpdateBookDto updateBookDto)
    {
        var existingBook = await _context.Books.FindAsync(id);
        
        if (existingBook == null)
        {
            throw new KeyNotFoundException($"Book with ID {id} not found.");
        }
        
        _mapper.Map(updateBookDto, existingBook);
        existingBook.PublishedDate = updateBookDto.PublishedDate == DateTime.MinValue 
            ? existingBook.PublishedDate 
            : updateBookDto.PublishedDate;
            
        await _context.SaveChangesAsync();
        
        return _mapper.Map<BookDto>(existingBook);
    }
    
    /// <summary>
    /// Delete a book
    /// </summary>
    /// <param name="id">Book ID</param>
    /// <returns>True if deleted, false if not found</returns>
    public async Task<bool> DeleteBookAsync(int id)
    {
        var book = await _context.Books.FindAsync(id);
        
        if (book == null)
        {
            return false;
        }
        
        _context.Books.Remove(book);
        await _context.SaveChangesAsync();
        
        return true;
    }
}