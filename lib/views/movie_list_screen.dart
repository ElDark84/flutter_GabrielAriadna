/// Main screen that displays a list of movies, TV shows, or reviews
/// Features include:
/// - Search functionality
/// - Category filtering (Movies, TV Shows, Reviews)
/// - Infinite scrolling
/// - Pull to refresh
/// - Error handling and loading states
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/view_model.dart';
import '../widgets/movie_card.dart';
import '../widgets/review_card.dart';

/// Main widget that displays the list of movies and TV shows
/// Uses Provider for state management and handles user interactions
class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

/// State class for MovieListScreen
/// Manages the search controller and UI state
class _MovieListScreenState extends State<MovieListScreen> {
  /// Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  /// Initialize the screen and load initial content
  void initState() {
    super.initState();
    // Load initial content asynchronously
    Future.microtask(() => context.read<MovieViewModel>().loadContent());
  }

  @override
  /// Clean up resources when the widget is disposed
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  /// Build the main screen layout
  /// Includes search bar, category filters, and content list
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside search field
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          // Background gradient for visual appeal
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
          // Main content with padding
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildSearchBar(),  // Search input field
                _buildCategoryChips(),  // Category filter chips
                const SizedBox(height: 8),  // Spacing
                _buildContentList(),  // Main content list
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the search bar widget with clear button
  /// Handles search input and updates the view model
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
      child: Container(
        // Search bar container styling
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
        // Search text field
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',  // Placeholder text
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),  // Search icon
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            // Clear search button
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey.shade400),
              onPressed: () {
                _searchController.clear();
                context.read<MovieViewModel>().searchContent('');
              },
            ),
          ),
          // Update search results as user types
          onChanged: (value) {
            context.read<MovieViewModel>().searchContent(value);
          },
        ),
      ),
    );
  }

  /// Builds the horizontal scrollable category filter chips
  /// Allows switching between Movies, TV Shows, and Reviews
  Widget _buildCategoryChips() {
    return Consumer<MovieViewModel>(
      builder: (context, movieViewModel, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Movie category chip
              _buildCategoryChip('Películas', ContentType.movies, movieViewModel.selectedType),
              const SizedBox(width: 8),
              // TV Shows category chip
              _buildCategoryChip('Series', ContentType.tvShows, movieViewModel.selectedType),
              const SizedBox(width: 8),
              // Reviews category chip
              _buildCategoryChip('Reviews', ContentType.reviews, movieViewModel.selectedType),
            ],
          ),
        );
      },
    );
  }

  /// Builds an individual category filter chip
  /// Handles selection state and visual feedback
  Widget _buildCategoryChip(String label, ContentType type, ContentType selectedType) {
    final isSelected = type == selectedType;  // Check if this category is selected
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade400,  // Text color based on selection
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,  // Font weight based on selection
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Update selected content type
          context.read<MovieViewModel>().setContentType(type);
        }
      },
      backgroundColor: Theme.of(context).colorScheme.surface,  // Background color
      selectedColor: Theme.of(context).colorScheme.primary,  // Selected state color
      checkmarkColor: Colors.white,  // Checkmark color
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,  // Border color based on selection
        ),
      ),
    );
  }

  /// Builds the main content list (movies, TV shows, or reviews)
  /// Handles loading states, errors, and empty states
  Widget _buildContentList() {
    return Expanded(
      child: Consumer<MovieViewModel>(
        builder: (context, movieViewModel, child) {
          // Show loading indicator while fetching initial data
          if (movieViewModel.isLoading &&
              ((movieViewModel.selectedType == ContentType.reviews && movieViewModel.reviews.isEmpty) ||
                  (movieViewModel.selectedType != ContentType.reviews && movieViewModel.movies.isEmpty))) {
            return const Center(
              child: SpinKitDoubleBounce(color: Colors.blue, size: 50.0),  // Loading animation
            );
          }

          // Show error message if something went wrong
          if (movieViewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),  // Error icon
                  const SizedBox(height: 16),
                  Text(
                    movieViewModel.error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Retry button
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

          // Show appropriate list based on selected content type
          if (movieViewModel.selectedType == ContentType.reviews) {
            if (movieViewModel.reviews.isEmpty) {
              return _buildEmptyMessage('No reviews found');  // Empty reviews message
            }
            return _buildReviewList(movieViewModel);  // Reviews list
          } else {
            if (movieViewModel.movies.isEmpty) {
              return _buildEmptyMessage('No content found');  // Empty content message
            }
            return _buildMovieList(movieViewModel);  // Movies/TV shows list
          }
        },
      ),
    );
  }

  /// Builds a message shown when no content is available
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

  /// Builds the list of reviews
  Widget _buildReviewList(MovieViewModel movieViewModel) {
    return ListView.builder(
      itemCount: movieViewModel.reviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: movieViewModel.reviews[index]);  // Individual review card
      },
    );
  }

  /// Builds the list of movies or TV shows
  /// Includes infinite scrolling and pull-to-refresh functionality
  Widget _buildMovieList(MovieViewModel movieViewModel) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            // Reload content on double tap
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
                  // Show movie details on long press
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
        // Load more button when more content is available
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
