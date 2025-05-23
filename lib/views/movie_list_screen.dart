/// Pantalla principal que muestra una lista de películas, series de TV o reseñas
/// Características incluyen:
/// - Funcionalidad de búsqueda
/// - Filtrado por categoría (Películas, Series de TV, Reseñas)
/// - Desplazamiento infinito
/// - Actualización mediante arrastre
/// - Manejo de errores y estados de carga
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/view_model.dart';
import '../widgets/movie_card.dart';
import '../widgets/review_card.dart';

/// Widget principal que muestra la lista de películas y series de TV
/// Utiliza Provider para la gestión de estado y maneja las interacciones del usuario
class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

/// Clase de estado para MovieListScreen
/// Gestiona el controlador de búsqueda y el estado de la UI
class _MovieListScreenState extends State<MovieListScreen> {
  /// Controlador para el campo de texto de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  /// Inicializa la pantalla y carga el contenido inicial
  void initState() {
    super.initState();
    // Carga el contenido inicial de forma asíncrona
    Future.microtask(() => context.read<MovieViewModel>().loadContent());
  }

  @override
  /// Limpia los recursos cuando el widget se destruye
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  /// Construye el diseño principal de la pantalla
  /// Incluye barra de búsqueda, filtros de categoría y lista de contenido
  Widget build(BuildContext context) {
    return GestureDetector(
      // Oculta el teclado al tocar fuera del campo de búsqueda
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          // Gradiente de fondo para apariencia visual
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          // Contenido principal con padding
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildSearchBar(),  // Campo de entrada de búsqueda
                _buildCategoryChips(),  // Chips de filtro de categoría
                const SizedBox(height: 8),  // Espaciado
                _buildContentList(),  // Lista de contenido principal
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye el widget de barra de búsqueda con botón de limpiar
  /// Maneja la entrada de búsqueda y actualiza el modelo de vista
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
      child: Container(
        // Estilo del contenedor de la barra de búsqueda
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        // Campo de texto de búsqueda
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Buscar...',  // Texto de placeholder
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),  // Icono de búsqueda
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            // Botón de limpiar búsqueda
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey.shade400),
              onPressed: () {
                _searchController.clear();
                context.read<MovieViewModel>().searchContent('');
              },
            ),
          ),
          // Actualiza los resultados de búsqueda mientras el usuario escribe
          onChanged: (value) {
            context.read<MovieViewModel>().searchContent(value);
          },
        ),
      ),
    );
  }

  /// Construye los chips de filtro de categoría desplazables horizontalmente
  /// Permite cambiar entre Películas, Series de TV y Reseñas
  Widget _buildCategoryChips() {
    return Consumer<MovieViewModel>(
      builder: (context, movieViewModel, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,  // Habilita el desplazamiento horizontal
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Chip de categoría de películas
              _buildCategoryChip('Películas', ContentType.movies, movieViewModel.selectedType),
              const SizedBox(width: 8),
              // Chip de categoría de series
              _buildCategoryChip('Series', ContentType.tvShows, movieViewModel.selectedType),
              const SizedBox(width: 8),
              // Chip de categoría de reseñas
              _buildCategoryChip('Reseñas', ContentType.reviews, movieViewModel.selectedType),
            ],
          ),
        );
      },
    );
  }

  /// Construye un chip individual de filtro de categoría
  /// Maneja el estado de selección y la retroalimentación visual
  Widget _buildCategoryChip(String label, ContentType type, ContentType selectedType) {
    final isSelected = type == selectedType;  // Verifica si esta categoría está seleccionada
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade400,  // Color del texto según la selección
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,  // Peso de la fuente según la selección
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Actualizar el tipo de contenido seleccionado
          context.read<MovieViewModel>().setContentType(type);
        }
      },
      backgroundColor: Theme.of(context).colorScheme.surface,  // Color de fondo
      selectedColor: Theme.of(context).colorScheme.primary,  // Color del estado seleccionado
      checkmarkColor: Colors.white,  // Color de la marca de verificación
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,  // Color del borde según la selección
        ),
      ),
    );
  }

  /// Construye la lista principal de contenido (películas, series de TV o reseñas)
  /// Maneja estados de carga, errores y estados vacíos
  Widget _buildContentList() {
    return Expanded(
      child: Consumer<MovieViewModel>(
        builder: (context, movieViewModel, child) {
          // Mostrar indicador de carga mientras se obtienen los datos iniciales
          if (movieViewModel.isLoading &&
              ((movieViewModel.selectedType == ContentType.reviews && movieViewModel.reviews.isEmpty) ||
                  (movieViewModel.selectedType != ContentType.reviews && movieViewModel.movies.isEmpty))) {
            return const Center(
              child: SpinKitDoubleBounce(color: Colors.blue, size: 50.0),  // Animación de carga
            );
          }

          // Mostrar mensaje de error si algo salió mal
          if (movieViewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),  // Icono de error
                  const SizedBox(height: 16),
                  Text(
                    movieViewModel.error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Botón de reintentar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => movieViewModel.loadContent(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Mostrar lista apropiada según el tipo de contenido seleccionado
          if (movieViewModel.selectedType == ContentType.reviews) {
            if (movieViewModel.reviews.isEmpty) {
              return _buildEmptyMessage('No se encontraron reseñas');  // Mensaje de reseñas vacías
            }
            return _buildReviewList(movieViewModel);  // Lista de reseñas
          } else {
            if (movieViewModel.movies.isEmpty) {
              return _buildEmptyMessage('No se encontró contenido');  // Mensaje de contenido vacío
            }
            return _buildMovieList(movieViewModel);  // Lista de películas/series
          }
        },
      ),
    );
  }

  /// Construye un mensaje que se muestra cuando no hay contenido disponible
  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),  // No results icon
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  /// Construye la lista de reseñas
  Widget _buildReviewList(MovieViewModel movieViewModel) {
    return ListView.builder(
      itemCount: movieViewModel.reviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: movieViewModel.reviews[index]);  // Individual review card
      },
    );
  }

  /// Construye la lista de películas o series de TV
  /// Incluye desplazamiento infinito y funcionalidad de actualización mediante arrastre
  Widget _buildMovieList(MovieViewModel movieViewModel) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            // Recargar contenido al hacer doble tap
            onDoubleTap: () {
              context.read<MovieViewModel>().loadContent();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contenido recargado')),
              );
            },
            child: ListView.builder(
              itemCount: movieViewModel.movies.length,
              itemBuilder: (context, index) {
                final movie = movieViewModel.movies[index];
                return GestureDetector(
                  // Mostrar detalles de la película al mantener presionado
                  onLongPress: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Detalles de: ${movie.title}')),
                    );
                  },
                  child: MovieCard(movie: movie),
                );
              },
            ),
          ),
        ),
        // Botón de cargar más cuando hay más contenido disponible
        if (movieViewModel.hasMoreContent)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              onPressed: movieViewModel.isLoading ? null : () => movieViewModel.loadMoreContent(),
              child: movieViewModel.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Ver más',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
      ],
    );
  }
}
