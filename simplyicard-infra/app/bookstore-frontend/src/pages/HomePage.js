import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import bookService from '../services/bookService';
import BookCover from '../components/BookCover';
import './HomePage.css';

const HomePage = () => {
  const [featuredBooks, setFeaturedBooks] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchFeaturedBooks = async () => {
      try {
        setLoading(true);
        const data = await bookService.getAllBooks(1, 3); // Get first 3 books as featured
        setFeaturedBooks(data.books || data);
        setLoading(false);
      } catch (err) {
        console.error('Failed to fetch featured books:', err);
        setLoading(false);
      }
    };

    fetchFeaturedBooks();
  }, []);

  const handleBrowseBooks = () => {
    navigate('/books');
  };

  const handleBookClick = (bookId) => {
    navigate(`/books/${bookId}`);
  };

  return (
    <div className="homepage">
      <section className="hero">
        <div className="hero-content">
          <h1>Welcome to BookstoreNet - from AWS Lambda</h1>
          <p>Your one-stop destination for all your reading needs </p>
          <button className="cta-button" onClick={handleBrowseBooks}>Browse Books</button>
        </div>
      </section>

      <section className="featured-books">
        <h2>Featured Books</h2>
        {loading ? (
          <p className="loading">Loading featured books...</p>
        ) : (
          <div className="book-grid">
            {featuredBooks.length > 0 ? (
              featuredBooks.map((book) => (
                <div key={book.id} className="book-card" onClick={() => handleBookClick(book.id)} style={{ cursor: 'pointer' }}>
                  <BookCover isbn={book.isbn} title={book.title} size="M" />
                  <h3>{book.title || 'Untitled Book'}</h3>
                  <p>{book.author || 'Unknown Author'}</p>
                  <span className="price">${book.price || '0.00'}</span>
                </div>
              ))
            ) : (
              <p>No featured books available.</p>
            )}
          </div>
        )}
      </section>
    </div>
  );
};

export default HomePage;