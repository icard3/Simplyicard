import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import bookService from '../services/bookService';
import { useCart } from '../contexts/CartContext';
import BookCover from '../components/BookCover';
import './BookListPage.css';

const BookListPage = () => {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  
  const { addToCart } = useCart();
  const navigate = useNavigate();

  useEffect(() => {
    const fetchBooks = async () => {
      try {
        setLoading(true);
        const data = await bookService.getAllBooks(1, 20, searchTerm);
        setBooks(data.books || data);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch books');
        setLoading(false);
      }
    };

    fetchBooks();
  }, [searchTerm]);

  const handleSearch = (e) => {
    setSearchTerm(e.target.value);
  };

  const handleAddToCart = (book) => {
    addToCart(book);
  };

  const handleViewDetails = (bookId) => {
    navigate(`/books/${bookId}`);
  };

  if (loading) {
    return <div className="loading">Loading books...</div>;
  }

  if (error) {
    return <div className="error">{error}</div>;
  }

  return (
    <div className="book-list-page">
      <div className="header">
        <h1>Our Books</h1>
        <div className="search-container">
          <input
            type="text"
            placeholder="Search books..."
            value={searchTerm}
            onChange={handleSearch}
            className="search-input"
          />
        </div>
      </div>
      
      <div className="book-grid">
        {books.length > 0 ? (
          books.map((book) => (
            <div key={book.id} className="book-card">
              <div onClick={() => handleViewDetails(book.id)} style={{ cursor: 'pointer' }}>
                <BookCover isbn={book.isbn} title={book.title} size="M" />
              </div>
              <h3>{book.title || 'Untitled Book'}</h3>
              <p className="author">{book.author || 'Unknown Author'}</p>
              <p className="price">${book.price || '0.00'}</p>
              <div className="book-actions">
                <button 
                  className="add-to-cart-btn"
                  onClick={() => handleAddToCart(book)}
                >
                  Add to Cart
                </button>
                <button 
                  className="view-details-btn"
                  onClick={() => handleViewDetails(book.id)}
                >
                  View Details
                </button>
              </div>
            </div>
          ))
        ) : (
          <p className="no-books">No books found.</p>
        )}
      </div>
    </div>
  );
};

export default BookListPage;