using AutoMapper;
using Bookstore.Api.Models;
using Bookstore.Api.DTOs;

namespace Bookstore.Api.Profiles;

/// <summary>
/// AutoMapper profile for mapping between entities and DTOs
/// </summary>
public class BookstoreProfile : Profile
{
    /// <summary>
    /// Constructor to configure mappings
    /// </summary>
    public BookstoreProfile()
    {
        // Map Book to BookDto
        CreateMap<Book, BookDto>();
        
        // Map CreateBookDto to Book
        CreateMap<CreateBookDto, Book>();
        
        // Map UpdateBookDto to Book
        CreateMap<UpdateBookDto, Book>();
    }
}