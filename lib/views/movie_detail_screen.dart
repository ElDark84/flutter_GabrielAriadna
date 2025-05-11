// Pantalla que muestra los detalles completos de una película o serie
// Incluye información como póster, título, calificación, descripción, reparto y presupuesto
import 'package:flutter/material.dart';
import '../models/movie.dart';

/// Widget que muestra una vista detallada de una película o serie
/// Características incluyen:
/// - Imagen del póster en tamaño grande
/// - Información detallada (título, fecha, calificación)
/// - Descripción completa
/// - Lista del reparto principal
/// - Información del presupuesto
/// - Botón para ver el tráiler (pendiente de implementar)
class MovieDetailScreen extends StatelessWidget {
  /// Datos de la película que se mostrarán en detalle
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatea el presupuesto con separadores de miles y símbolo de dólar
    final budgetFormatted = movie.budget != null
        ? '\$${movie.budget!.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ",")}'
        : 'Desconocido';

    return Scaffold(
      // Barra superior con el título de la película
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      // Contenido principal con desplazamiento
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar póster si está disponible
            if (movie.posterPath != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.posterUrl,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Título de la película
            Text(
              movie.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            // Fecha de lanzamiento
            Text(
              'Fecha de lanzamiento: ${movie.releaseDate}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Calificación con icono de estrella
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 24),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sección de descripción
            const Text(
              'Descripción:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              movie.overview.isNotEmpty ? movie.overview : 'Sin descripción disponible.',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            // Sección del reparto (solo si hay actores disponibles)
            if (movie.cast.isNotEmpty) ...[
              const Text(
                'Reparto principal:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              // Lista de chips con los nombres de los actores principales
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: movie.cast.take(5).map((actor) {
                  return Chip(
                    label: Text(actor),
                    backgroundColor: Colors.blueGrey,
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
            // Información del presupuesto
            Text(
              'Presupuesto: $budgetFormatted',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Botón para ver el tráiler (pendiente de implementar)
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implementar la funcionalidad del tráiler
                },
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Ver tráiler'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
