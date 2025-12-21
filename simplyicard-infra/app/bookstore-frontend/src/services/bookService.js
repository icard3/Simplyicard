// services/bookService.js
import api from './api';

const bookService = {
  // Get all books with pagination and filtering
  getAllBooks: async (page = 1, pageSize = 10, search = '') => {
    try {
      const params = { page, pageSize };
      if (search) {
        params.search = search;
      }
      
      const response = await api.get('/books', { params });
      return response.data;
    } catch (error) {
      throw error.response?.data || error;
    }
  },

  // Get book by ID
  getBookById: async (id) => {
    try {
      const response = await api.get(`/books/${id}`);
      return response.data;
    } catch (error) {
      throw error.response?.data || error;
    }
  },

  // Create a new book (requires authentication)
  createBook: async (bookData) => {
    try {
      const response = await api.post('/books', bookData);
      return response.data;
    } catch (error) {
      throw error.response?.data || error;
    }
  },

  // Update a book (requires authentication)
  updateBook: async (id, bookData) => {
    try {
      const response = await api.put(`/books/${id}`, bookData);
      return response.data;
    } catch (error) {
      throw error.response?.data || error;
    }
  },

  // Delete a book (requires authentication)
  deleteBook: async (id) => {
    try {
      const response = await api.delete(`/books/${id}`);
      return response.data;
    } catch (error) {
      throw error.response?.data || error;
    }
  }
};

export default bookService;