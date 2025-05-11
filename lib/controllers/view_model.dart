import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../models/review.dart';
import '../services/movie_service.dart';

/// Enum que define los tipos de contenido que pueden mostrarse
/// Se utiliza para cambiar entre diferentes vistas de contenido
enum ContentType { movies, tvShows, reviews }

/// Clase ViewModel que gestiona el estado y la lógica de negocio para la aplicación de películas
/// Maneja:
/// - Carga de contenido y paginación
/// - Funcionalidad de búsqueda
/// - Cambio de tipo de contenido
/// - Manejo de errores
/// - Gestión de estado usando ChangeNotifier
class MovieViewModel extends ChangeNotifier {
  /// Servicio para realizar llamadas a la API y obtener datos de películas
  final MovieService _movieService = MovieService();

  /// Almacenamiento interno para todas las películas/series
  List<Movie> _movies = [];
  
  /// Lista filtrada de películas/series basada en la búsqueda
  List<Movie> _filteredMovies = [];
  
  /// Almacenamiento interno para todas las reseñas
  List<Review> _reviews = [];
  
  /// Lista filtrada de reseñas basada en la búsqueda
  List<Review> _filteredReviews = [];
  
  /// Indicador de estado de carga
  bool _isLoading = false;
  
  /// Almacenamiento de mensajes de error
  String _error = '';
  
  /// Tipo de contenido actualmente seleccionado
  ContentType _selectedType = ContentType.movies;
  
  /// Número de página actual para paginación
  int _currentPage = 1;
  
  /// Número total de páginas disponibles
  int _totalPages = 1;
  
  /// Indicador de si hay más contenido disponible para cargar
  bool _hasMoreContent = true;

  // Getters para acceso público a campos privados
  List<Movie> get movies => _filteredMovies;
  List<Review> get reviews => _filteredReviews;
  bool get isLoading => _isLoading;
  String get error => _error;
  ContentType get selectedType => _selectedType;
  bool get hasMoreContent => _hasMoreContent;

  /// Datos de ejemplo de reseñas para fines de demostración
  /// En una aplicación real, esto vendría de un servicio backend
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

  /// Formatea los mensajes de error para su visualización
  /// Registra errores en modo debug
  String _getErrorMessage(Object e) {
    if (kDebugMode) {
      print('Error: $e');
    }
    return 'Error al cargar los datos. Verifica tu conexión o intenta nuevamente.';
  }

  /// Limpia cualquier mensaje de error existente
  void clearError() {
    _error = '';
    notifyListeners();
  }

  /// Carga el contenido inicial según el tipo seleccionado
  /// Reinicia la paginación y maneja errores
  Future<void> loadContent() async {
    _isLoading = true;
    _error = '';
    _currentPage = 1;
    notifyListeners();

    try {
      switch (_selectedType) {
        case ContentType.movies:
          // Cargar películas populares
          final result = await _movieService.getPopularMovies(_currentPage);
          _movies = result['movies'];
          _filteredMovies = _movies;
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.tvShows:
          // Cargar series de TV populares
          final result = await _movieService.getPopularTVShows(_currentPage);
          _movies = result['movies'];
          _filteredMovies = _movies;
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.reviews:
          // Cargar lote inicial de reseñas
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

  /// Carga contenido adicional para el desplazamiento infinito
  /// Maneja la paginación y los estados de error
  Future<void> loadMoreContent() async {
    if (!_hasMoreContent || _isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      switch (_selectedType) {
        case ContentType.movies:
          // Cargar siguiente página de películas
          final result = await _movieService.getPopularMovies(_currentPage + 1);
          _movies.addAll(result['movies']);
          _filteredMovies = _movies;
          _currentPage = result['currentPage'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.tvShows:
          // Cargar siguiente página de series
          final result = await _movieService.getPopularTVShows(_currentPage + 1);
          _movies.addAll(result['movies']);
          _filteredMovies = _movies;
          _currentPage = result['currentPage'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.reviews:
          // Cargar siguiente lote de reseñas
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

  /// Cambia el tipo de contenido y recarga el contenido
  /// Solo activa la recarga si el tipo realmente cambia
  void setContentType(ContentType type) {
    if (_selectedType != type) {
      _selectedType = type;
      loadContent();
    }
  }

  /// Busca contenido basado en la cadena de consulta
  /// Maneja diferentes tipos de contenido y estados de búsqueda
  Future<void> searchContent(String query) async {
    if (query.isEmpty) {
      // Restablecer a la lista completa si se limpia la búsqueda
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
          // Buscar películas a través de la API
          final result = await _movieService.searchMovies(query, _currentPage);
          _filteredMovies = result['movies'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.tvShows:
          // Buscar series a través de la API
          final result = await _movieService.searchTVShows(query, _currentPage);
          _filteredMovies = result['movies'];
          _totalPages = result['totalPages'];
          _hasMoreContent = _currentPage < _totalPages;
          break;
        case ContentType.reviews:
          // Filtrar reseñas localmente
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
