// Widget that displays a movie card with poster, title, and rating
// Used in the movie list to show individual movie items
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../views/movie_detail_screen.dart';

/// A card widget that displays movie information including:
/// - Movie poster image
/// - Title
/// - Rating
/// 
/// The card is tappable and navigates to the movie detail screen when pressed.
class MovieCard extends StatelessWidget {
  /// The movie data to be displayed in the card
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigate to movie detail screen when card is tapped
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Container(
        // Add margin around the card for spacing
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Add shadow for elevation effect
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Display movie poster if available
              if (movie.posterPath != null)
                Image.network(
                  movie.posterUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Show error icon if image fails to load
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  },
                )
              // Show placeholder if no poster is available
              else
                Container(
                  height: 300,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.movie,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              // Overlay with movie title and rating
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  // Gradient background for better text readability
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie title
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Movie rating with star icon
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
