import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/view_model.dart';
import '../widgets/movie_card.dart';
import '../widgets/review_card.dart';

// Widget principal que muestra la lista de películas y series
class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

// Estado del widget MovieListScreen
class _MovieListScreenState extends State<MovieListScreen> {
  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  // Método que se ejecuta cuando el widget se inicializa
  void initState() {
    super.initState();
    // Carga el contenido inicial de manera asíncrona
    Future.microtask(() => context.read<MovieViewModel>().loadContent());
  }

  @override
  // Método que se ejecuta cuando el widget se destruye
  void dispose() {
    // Libera los recursos del controlador de texto
    _searchController.dispose();
    super.dispose();
  }

  @override
  // Método que construye la interfaz de usuario
  Widget build(BuildContext context) {
    return GestureDetector(
      // Oculta el teclado cuando se toca fuera del campo de búsqueda
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          // Fondo con gradiente
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
                _buildSearchBar(),  // Barra de búsqueda
                _buildCategoryChips(),  // Chips de categorías
                const SizedBox(height: 8),  // Espaciado
                _buildContentList(),  // Lista de contenido
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget que construye la barra de búsqueda
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
      child: Container(
        // Decoración de la barra de búsqueda
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
        // Campo de texto para búsqueda
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',  // Texto de sugerencia
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),  // Icono de búsqueda
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            // Botón para limpiar la búsqueda
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey.shade400),
              onPressed: () {
                _searchController.clear();
                context.read<MovieViewModel>().searchContent('');
              },
            ),
          ),
          // Actualiza la búsqueda cuando el texto cambia
          onChanged: (value) {
            context.read<MovieViewModel>().searchContent(value);
          },
        ),
      ),
    );
  }

  // Widget que construye los chips de categorías (Películas, Series, Reviews)
  Widget _buildCategoryChips() {
    return Consumer<MovieViewModel>(
      builder: (context, movieViewModel, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,  // Permite scroll horizontal
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Chip para filtrar películas
              _buildCategoryChip('Películas', ContentType.movies, movieViewModel.selectedType),
              const SizedBox(width: 8),
              // Chip para filtrar series
              _buildCategoryChip('Series', ContentType.tvShows, movieViewModel.selectedType),
              const SizedBox(width: 8),
              // Chip para filtrar reviews
              _buildCategoryChip('Reviews', ContentType.reviews, movieViewModel.selectedType),
            ],
          ),
        );
      },
    );
  }

  // Widget que construye un chip de categoría individual
  Widget _buildCategoryChip(String label, ContentType type, ContentType selectedType) {
    final isSelected = type == selectedType;  // Determina si el chip está seleccionado
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade400,  // Color del texto según selección
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,  // Peso de la fuente según selección
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Actualiza el tipo de contenido seleccionado
          context.read<MovieViewModel>().setContentType(type);
        }
      },
      backgroundColor: Theme.of(context).colorScheme.surface,  // Color de fondo
      selectedColor: Theme.of(context).colorScheme.primary,  // Color cuando está seleccionado
      checkmarkColor: Colors.white,  // Color del checkmark
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,  // Color del borde según selección
        ),
      ),
    );
  }

  // Widget que construye la lista de contenido (películas, series o reviews)
  Widget _buildContentList() {
    return Expanded(
      child: Consumer<MovieViewModel>(
        builder: (context, movieViewModel, child) {
          // Muestra un indicador de carga mientras se obtienen los datos
          if (movieViewModel.isLoading &&
              ((movieViewModel.selectedType == ContentType.reviews && movieViewModel.reviews.isEmpty) ||
                  (movieViewModel.selectedType != ContentType.reviews && movieViewModel.movies.isEmpty))) {
            return const Center(
              child: SpinKitDoubleBounce(color: Colors.blue, size: 50.0),  // Animación de carga
            );
          }

          // Muestra un mensaje de error si algo salió mal
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
                  // Botón para reintentar la carga
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
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Muestra la lista de reviews o películas según el tipo seleccionado
          if (movieViewModel.selectedType == ContentType.reviews) {
            if (movieViewModel.reviews.isEmpty) {
              return _buildEmptyMessage('No reviews found');  // Mensaje si no hay reviews
            }
            return _buildReviewList(movieViewModel);  // Lista de reviews
          } else {
            if (movieViewModel.movies.isEmpty) {
              return _buildEmptyMessage('No content found');  // Mensaje si no hay contenido
            }
            return _buildMovieList(movieViewModel);  // Lista de películas/series
          }
        },
      ),
    );
  }

  // Widget que muestra un mensaje cuando no hay contenido
  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),  // Icono de búsqueda sin resultados
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // Widget que construye la lista de reviews
  Widget _buildReviewList(MovieViewModel movieViewModel) {
    return ListView.builder(
      itemCount: movieViewModel.reviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: movieViewModel.reviews[index]);  // Tarjeta de review individual
      },
    );
  }

  // Widget que construye la lista de películas/series
  Widget _buildMovieList(MovieViewModel movieViewModel) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            // Permite recargar el contenido con doble tap
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
