import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/view_model.dart';
import '../widgets/movie_card.dart';
import '../widgets/review_card.dart';


class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MovieViewModel>().loadContent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildSearchBar(),
              _buildCategoryChips(),
              const SizedBox(height: 8),
              _buildContentList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
      child: Container(
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
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey.shade400),
              onPressed: () {
                _searchController.clear();
                context.read<MovieViewModel>().searchContent('');
              },
            ),
          ),
          onChanged: (value) {
            context.read<MovieViewModel>().searchContent(value);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Consumer<MovieViewModel>(
      builder: (context, movieViewModel, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildCategoryChip('Películas', ContentType.movies, movieViewModel.selectedType),
              const SizedBox(width: 8),
              _buildCategoryChip('Series', ContentType.tvShows, movieViewModel.selectedType),
              const SizedBox(width: 8),
              _buildCategoryChip('Reviews', ContentType.reviews, movieViewModel.selectedType),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, ContentType type, ContentType selectedType) {
    final isSelected = type == selectedType;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade400,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<MovieViewModel>().setContentType(type);
        }
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildContentList() {
    return Expanded(
      child: Consumer<MovieViewModel>(
        builder: (context, movieViewModel, child) {
          if (movieViewModel.isLoading &&
              ((movieViewModel.selectedType == ContentType.reviews && movieViewModel.reviews.isEmpty) ||
               (movieViewModel.selectedType != ContentType.reviews && movieViewModel.movies.isEmpty))) {
            return const Center(
              child: SpinKitDoubleBounce(color: Colors.blue, size: 50.0),
            );
          }

          if (movieViewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    movieViewModel.error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
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

          if (movieViewModel.selectedType == ContentType.reviews) {
            if (movieViewModel.reviews.isEmpty) {
              return _buildEmptyMessage('No reviews found');
            }
            return _buildReviewList(movieViewModel);
          } else {
            if (movieViewModel.movies.isEmpty) {
              return _buildEmptyMessage('No content found');
            }
            return _buildMovieList(movieViewModel);
          }
        },
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList(MovieViewModel movieViewModel) {
    return ListView.builder(
      itemCount: movieViewModel.reviews.length,
      itemBuilder: (context, index) {
        return ReviewCard(review: movieViewModel.reviews[index]);
      },
    );
  }

  Widget _buildMovieList(MovieViewModel movieViewModel) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: movieViewModel.movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movieViewModel.movies[index]);
            },
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
