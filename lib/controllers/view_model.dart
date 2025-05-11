import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../services/movie_service.dart';

/// Enum defining the types of content that can be displayed
/// Used to switch between different content views
enum ContentType { movies, tvShows, reviews }

/// ViewModel class that manages the state and business logic for the movie app
/// Handles:
/// - Content loading and pagination
/// - Search functionality
/// - Content type switching
/// - Error handling
/// - State management using ChangeNotifier
class MovieViewModel extends ChangeNotifier {
  /// Service for making API calls to fetch movie data
  final MovieService _movieService = MovieService();

  /// Internal storage for all movies/shows
  List<Movie> _movies = [];
  
  /// Filtered list of movies/shows based on search
  List<Movie> _filteredMovies = [];
  
  /// Internal storage for all reviews
  List<Review> _reviews = [];
  
  /// Filtered list of reviews based on search
  List<Review> _filteredReviews = [];
  
  /// Loading state indicator
  bool _isLoading = false;
  
  /// Error message storage
  String _error = '';
  
  /// Currently selected content type
  ContentType _selectedType = ContentType.movies;
  
  /// Current page number for pagination
  int _currentPage = 1;
  
  /// Total number of available pages
  int _totalPages = 1;
  
  /// Flag indicating if more content is available to load
  bool _hasMoreContent = true;

  // Getters for public access to private fields
  List<Movie> get movies => _filteredMovies;
  List<Review> get reviews => _filteredReviews;
  bool get isLoading => _isLoading;
  String get error => _error;
  ContentType get selectedType => _selectedType;
  bool get hasMoreContent => _hasMoreContent;

  /// Sample review data for demonstration purposes
  /// In a real app, this would come from a backend service
  final List<Review> _allSampleReviews = [
    Review(author: 'Juan Pérez', content: '¡Excelente película! Me encantó la trama y los efectos especiales.', rating: 4.5, createdAt: '2024-03-15'),
    Review(author: 'María García', content: 'Buena actuación pero el guión podría ser mejor.', rating: 3.0, createdAt: '2024-03-14'),
    Review(author: 'Carlos López', content: 'Una obra maestra del cine moderno. Totalmente recomendada.', rating: 5.0, createdAt: '2024-03-13'),
    Review(author: 'Pau Alcaráz', content: 'Pedro Sánchez DIMISIÓN!.', rating: 3.5, createdAt: '2024-03-12'),
    Review(author: 'Pedro Sánchez', content: 'Vota por mi.', rating: 2.5, createdAt: '2024-03-11'),
    Review(author: 'Laura Gómez', content: 'Los efectos visuales son impresionantes, pero la historia es predecible.', rating: 3.8, createdAt: '2024-03-10'),
    Review(author: 'Miguel Rodríguez', content: 'Una experiencia cinematográfica única. No me arrepiento de haberla visto.', rating: 4.8, createdAt: '2024-03-09'),
    Review(author: 'Sofía Torres', content: 'La dirección de arte es espectacular, pero el ritmo es un poco lento.', rating: 3.2, createdAt: '2024-03-08'),
    Review(author: 'Diego Ramírez', content: 'Los actores están brillantes, especialmente el protagonista.', rating: 4.2, createdAt: '2024-03-07'),
    Review(author: 'Carmen Vega', content: 'La banda sonora es increíble, complementa perfectamente la historia.', rating: 4.0, createdAt: '2024-03-06'),
  ];

  /// Formats error messages for display
  /// Logs errors in debug mode
  String _getErrorMessage(Object e) {
    if (kDebugMode) {
      print('Error: $e');
    }
    return 'Error al cargar los datos. Verifica tu conexión o intenta nuevamente.';
  }

  /// Clears any existing error message
  void clearError() {
    _error = '';
    notifyListeners();
  }

  /// Loads initial content based on selected type
  /// Resets pagination and handles errors
  Future<void> loadContent() async {
    _isLoading = true;
    _error = '';
    _currentPage = 1;
    notifyListeners();

    try {
      switch (_selectedType) {
        case ContentType.movies:
          // Load popular movies
          final result = await _movieService.getPopularMovies(_currentPage);
          _movies = result['movies'];
          _filteredMovies = _movies;
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.tvShows:
          // Load popular TV shows
          final result = await _movieService.getPopularTVShows(_currentPage);
          _movies = result['movies'];
          _filteredMovies = _movies;
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.reviews:
          // Load initial batch of reviews
          _reviews = _allSampleReviews.take(5).toList();
          _filteredReviews = _reviews;
          _hasMoreContent = _reviews.length < _allSampleReviews.length;
          break;
      }
    } catch (e) {
      _error = _getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads additional content for infinite scrolling
  /// Handles pagination and error states
  Future<void> loadMoreContent() async {
    if (!_hasMoreContent || _isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      switch (_selectedType) {
        case ContentType.movies:
          // Load next page of movies
          final result = await _movieService.getPopularMovies(_currentPage + 1);
          _movies.addAll(result['movies']);
          _filteredMovies = _movies;
          _currentPage = result['currentPage'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.tvShows:
          // Load next page of TV shows
          final result = await _movieService.getPopularTVShows(_currentPage + 1);
          _movies.addAll(result['movies']);
          _filteredMovies = _movies;
          _currentPage = result['currentPage'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.reviews:
          // Load next batch of reviews
          final currentLength = _reviews.length;
          final nextReviews = _allSampleReviews.skip(currentLength).take(5).toList();
          _reviews.addAll(nextReviews);
          _filteredReviews = _reviews;
          _hasMoreContent = _reviews.length < _allSampleReviews.length;
          break;
      }
    } catch (e) {
      _error = _getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Changes the content type and reloads content
  /// Only triggers reload if type actually changes
  void setContentType(ContentType type) {
    if (_selectedType != type) {
      _selectedType = type;
      loadContent();
    }
  }

  /// Searches content based on query string
  /// Handles different content types and search states
  Future<void> searchContent(String query) async {
    if (query.isEmpty) {
      // Reset to full list if search is cleared
      if (_selectedType == ContentType.reviews) {
        _filteredReviews = _reviews;
      } else {
        _filteredMovies = _movies;
      }
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';
    _currentPage = 1;
    notifyListeners();

    try {
      switch (_selectedType) {
        case ContentType.movies:
          // Search movies through API
          final result = await _movieService.searchMovies(query, _currentPage);
          _filteredMovies = result['movies'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.tvShows:
          // Search TV shows through API
          final result = await _movieService.searchTVShows(query, _currentPage);
          _filteredMovies = result['movies'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.reviews:
          // Filter reviews locally
          _filteredReviews = _allSampleReviews.where((review) {
            return review.content.toLowerCase().contains(query.toLowerCase()) ||
                review.author.toLowerCase().contains(query.toLowerCase());
          }).toList();
          _hasMoreContent = false;
          break;
      }
    } catch (e) {
      _error = _getErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
