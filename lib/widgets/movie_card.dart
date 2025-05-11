// Widget que muestra una tarjeta de película con póster, título y calificación
// Se utiliza en la lista de películas para mostrar elementos individuales
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../views/movie_detail_screen.dart';

/// Widget de tarjeta que muestra la información de la película incluyendo:
/// - Imagen del póster de la película
/// - Título
/// - Calificación
/// 
/// La tarjeta es interactiva y navega a la pantalla de detalles de la película al presionarla.
class MovieCard extends StatelessWidget {
  /// Los datos de la película que se mostrarán en la tarjeta
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navegar a la pantalla de detalles de la película al tocar la tarjeta
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Container(
        // Agregar margen alrededor de la tarjeta para espaciado
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Agregar sombra para efecto de elevación
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
              // Mostrar póster de la película si está disponible
              if (movie.posterPath != null)
                Image.network(
                  movie.posterUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Mostrar icono de error si la imagen falla al cargar
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
              // Mostrar marcador de posición si no hay póster disponible
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
              // Superposición con título y calificación de la película
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  // Fondo con gradiente para mejor legibilidad del texto
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
                      // Título de la película
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Calificación de la película con icono de estrella
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
