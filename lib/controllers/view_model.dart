import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../services/movie_service.dart';

enum ContentType { movies, tvShows, reviews }

class MovieViewModel extends ChangeNotifier {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  List<Review> _reviews = [];
  List<Review> _filteredReviews = [];
  bool _isLoading = false;
  String _error = '';
  ContentType _selectedType = ContentType.movies;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreContent = true;

  // Getters
  List<Movie> get movies => _filteredMovies;
  List<Review> get reviews => _filteredReviews;
  bool get isLoading => _isLoading;
  String get error => _error;
  ContentType get selectedType => _selectedType;
  bool get hasMoreContent => _hasMoreContent;
