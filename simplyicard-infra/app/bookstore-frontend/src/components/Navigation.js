// components/Navigation.js
import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useCart } from '../contexts/CartContext';

const Navigation = () => {
  const { user, isAuthenticated, logout } = useAuth();
  const { getCartCount } = useCart();
  const navigate = useNavigate();
  const cartCount = getCartCount();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <nav className="navbar navbar-expand-lg navbar-dark bg-dark">
      <div className="container">
        <Link className="navbar-brand" to="/">Bookstore</Link>
        
        <div className="navbar-nav me-auto">
          <Link className="nav-link" to="/">Home</Link>
          <Link className="nav-link" to="/books">Books</Link>
        </div>
        
        <div className="navbar-nav ms-auto">
          <Link className="nav-link" to="/cart">
            Cart {cartCount > 0 && <span className="badge bg-light text-dark ms-1">{cartCount}</span>}
          </Link>
          
          {isAuthenticated ? (
            <>
              <span className="navbar-text me-3">Hello, {user?.username}</span>
              {user?.role === 'Admin' && (
                <Link className="nav-link" to="/admin">Admin</Link>
              )}
              <button className="btn btn-outline-light" onClick={handleLogout}>Logout</button>
            </>
          ) : (
            <>
              <Link className="nav-link" to="/login">Login</Link>
              <Link className="nav-link" to="/register">Register</Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
};

export default Navigation;