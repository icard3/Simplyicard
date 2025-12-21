using Microsoft.EntityFrameworkCore;
using Bookstore.Api.Models;

namespace Bookstore.Api.Data;

/// <summary>
/// Database context for the bookstore application
/// </summary>
public class BookstoreContext : DbContext
{
    /// <summary>
    /// Constructor for the BookstoreContext
    /// </summary>
    /// <param name="options">Database context options</param>
    public BookstoreContext(DbContextOptions<BookstoreContext> options) : base(options)
    {
    }
    
    /// <summary>
    /// DbSet for books
    /// </summary>
    public DbSet<Book> Books { get; set; } = null!;
    
    /// <summary>
    /// DbSet for users
    /// </summary>
    public DbSet<User> Users { get; set; } = null!;
    
    /// <summary>
    /// Configure the model
    /// </summary>
    /// <param name="modelBuilder">Model builder</param>
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure Book entity
        modelBuilder.Entity<Book>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Title).IsRequired().HasMaxLength(200);
            entity.Property(e => e.Author).IsRequired().HasMaxLength(100);
            entity.Property(e => e.ISBN).IsRequired().HasMaxLength(20);
            entity.Property(e => e.Price).HasPrecision(18, 2);
            entity.Property(e => e.Genre).HasMaxLength(50);
            entity.Property(e => e.Description).HasMaxLength(1000);
        });
        
        // Configure User entity
        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Username).IsRequired().HasMaxLength(50);
            entity.Property(e => e.Email).IsRequired().HasMaxLength(100);
            entity.Property(e => e.PasswordHash).IsRequired();
            entity.Property(e => e.Role).IsRequired().HasMaxLength(20);
        });
        
        // Seed some initial data
        modelBuilder.Entity<Book>().HasData(
            new Book
            {
                Id = 1,
                Title = "The Great Gatsby",
                Author = "F. Scott Fitzgerald",
                ISBN = "978-0-7432-7356-5",
                Price = 10.99m,
                PublishedDate = new DateTime(1925, 4, 10),
                Genre = "Fiction",
                Description = "A classic American novel set in the summer of 1922",
                PageCount = 180
            },
            new Book
            {
                Id = 2,
                Title = "To Kill a Mockingbird",
                Author = "Harper Lee",
                ISBN = "978-0-06-112008-4",
                Price = 12.99m,
                PublishedDate = new DateTime(1960, 7, 11),
                Genre = "Fiction",
                Description = "A gripping tale of racial injustice and childhood innocence",
                PageCount = 376
            }
        );
        
        modelBuilder.Entity<User>().HasData(
            new User
            {
                Id = 1,
                Username = "admin",
                Email = "admin@example.com",
                PasswordHash = "$2a$11$8B4F3F9b5c6d7e8f9a0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s", // "password" hashed
                Role = "Admin",
                CreatedAt = DateTime.UtcNow
            },
            new User
            {
                Id = 2,
                Username = "user",
                Email = "user@example.com",
                PasswordHash = "$2a$11$8B4F3F9b5c6d7e8f9a0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s", // "password" hashed
                Role = "User",
                CreatedAt = DateTime.UtcNow
            }
        );
    }
}