import React from 'react';
import './BookCover.css';

const BookCover = ({ isbn, title, size = 'M' }) => {
  const coverUrl = isbn ? `https://covers.openlibrary.org/b/isbn/${isbn}-${size}.jpg` : null;

  return (
    <div className="book-cover-container">
      {coverUrl ? (
        <img 
          src={coverUrl} 
          alt={title || 'Book Cover'} 
          className="book-cover"
          onError={(e) => {
            e.target.onerror = null; // Prevent infinite loop if fallback also fails
            e.target.src = 'https://placehold.co/300x400?text=No+Cover'; // Placeholder image
          }}
        />
      ) : (
        <div className="book-cover-placeholder">
          <span>No Cover</span>
        </div>
      )}
    </div>
  );
};

export default BookCover;