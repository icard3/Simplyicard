import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import bookService from '../services/bookService';
import { useCart } from '../contexts/CartContext';
import BookCover from '../components/BookCover';
import './BookDetailPage.css';

const BookDetailPage = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const { addToCart } = useCart();
  const [book, setBook] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchBook = async () => {
      try {
        setLoading(true);
        const data = await bookService.getBookById(id);
        setBook(data);
        setLoading(false);
      } catch (err) {
        setError('Failed to fetch book details');
        setLoading(false);
      }
    };

    if (id) {
      fetchBook();
    }
  }, [id]);

  const handleAddToCart = () => {
    if (book) {
      addToCart(book);
      // Optional: Show a confirmation message
    }
  };

  const handleBuyNow = () => {
    if (book) {
      addToCart(book);
      navigate('/cart');
    }
  };

  if (loading) {
    return <div className="loading">Loading book details...</div>;
  }

  if (error) {
    return <div className="error">{error}</div>;
  }

  if (!book) {
    return <div className="error">Book not found</div>;
  }

  return (
    <div className="book-detail-page">
      <div className="book-detail-container">
        <div className="book-image">
          <BookCover isbn={book.isbn} title={book.title} size="L" />
        </div>
        
        <div className="book-info">
          <h1>{book.title}</h1>
          <p className="author">by {book.author}</p>
          
          <div className="book-meta">
            <span className="price">${book.price}</span>
            <span className="isbn">ISBN: {book.isbn || 'N/A'}</span>
          </div>
          
          <p className="description">{book.description || 'No description available for this book.'}</p>
          
          <div className="actions">
            <button 
              className="add-to-cart-btn"
              onClick={handleAddToCart}
            >
              Add to Cart
            </button>
            <button 
              className="buy-now-btn"
              onClick={handleBuyNow}
            >
              Buy Now
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default BookDetailPage;