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

  // Sample reviews data
  final List<Review> _allSampleReviews = [
    Review(
      author: 'Juan Pérez',
      content: '¡Excelente película! Me encantó la trama y los efectos especiales.',
      rating: 4.5,
      createdAt: '2024-03-15',
    ),
    Review(
      author: 'María García',
      content: 'Buena actuación pero el guión podría ser mejor.',
      rating: 3.0,
      createdAt: '2024-03-14',
    ),
    Review(
      author: 'Carlos López',
      content: 'Una obra maestra del cine moderno. Totalmente recomendada.',
      rating: 5.0,
      createdAt: '2024-03-13',
    ),
    Review(
      author: 'Pau Alcaráz',
      content: 'Pedro Sánchez DIMISIÓN!.',
      rating: 3.5,
      createdAt: '2024-03-12',
    ),
    Review(
      author: 'Pedro Sánchez',
      content: 'Vota por mi.',
      rating: 2.5,
      createdAt: '2024-03-11',
    ),
    Review(
      author: 'Laura Gómez',
      content: 'Los efectos visuales son impresionantes, pero la historia es predecible.',
      rating: 3.8,
      createdAt: '2024-03-10',
    ),
    Review(
      author: 'Miguel Rodríguez',
      content: 'Una experiencia cinematográfica única. No me arrepiento de haberla visto.',
      rating: 4.8,
      createdAt: '2024-03-09',
    ),
    Review(
      author: 'Sofía Torres',
      content: 'La dirección de arte es espectacular, pero el ritmo es un poco lento.',
      rating: 3.2,
      createdAt: '2024-03-08',
    ),
    Review(
      author: 'Diego Ramírez',
      content: 'Los actores están brillantes, especialmente el protagonista.',
      rating: 4.2,
      createdAt: '2024-03-07',
    ),
    Review(
      author: 'Carmen Vega',
      content: 'La banda sonora es increíble, complementa perfectamente la historia.',
      rating: 4.0,
      createdAt: '2024-03-06',
    ),
  ];

  // Methods
  Future<void> loadContent() async {
    _isLoading = true;
    _error = '';
    _currentPage = 1;
    notifyListeners();
