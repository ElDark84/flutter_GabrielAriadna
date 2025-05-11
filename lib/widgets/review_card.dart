// Importaciones necesarias para el widget de tarjeta de reseña
import 'package:flutter/material.dart';  // Widgets y componentes básicos de Flutter
import '../models/review.dart';  // Modelo de datos para reseñas

// Widget que muestra una tarjeta con la información de una reseña
class ReviewCard extends StatelessWidget {
  // Reseña que se mostrará en la tarjeta
  final Review review;

  // Constructor que requiere una reseña
  const ReviewCard({Key? key, required this.review}) : super(key: key);

  @override
  // Método que construye la interfaz de usuario de la tarjeta
  Widget build(BuildContext context) {
    return Card(
      // Márgenes alrededor de la tarjeta
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,  // Elevación para dar efecto de sombra
      child: Padding(
        padding: const EdgeInsets.all(16),  // Padding interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // Alineación a la izquierda
          children: [
            // Fila superior con el autor y la calificación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Espacio entre autor y calificación
              children: [
                // Nombre del autor
                Text(
                  review.author,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Fila con la calificación y el icono de estrella
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),  // Icono de estrella
                    const SizedBox(width: 4),  // Espacio entre icono y número
                    Text(
                      review.rating.toStringAsFixed(1),  // Calificación con un decimal
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),  // Espacio vertical
            // Contenido de la reseña
            Text(
              review.content,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),  // Espacio vertical
            // Fecha de creación de la reseña
            Text(
              review.createdAt,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],  // Color gris para la fecha
              ),
            ),
          ],
        ),
      ),
    );
  }
} 