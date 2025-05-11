// Modelo de datos que representa una reseña de película o serie
class Review {
  // Propiedades de la reseña
  final String author;  // Nombre del autor de la reseña
  final String content;  // Contenido o texto de la reseña
  final double rating;  // Calificación numérica
  final String createdAt;  // Fecha de creación de la reseña

  // Constructor que inicializa todas las propiedades
  Review({
    required this.author,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  // Constructor de fábrica que crea una instancia de Review desde JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      // Usa 'Anonymous' como valor por defecto si no hay autor
      author: json['author'] ?? 'Anonymous',
      // Usa cadena vacía como valor por defecto si no hay contenido
      content: json['content'] ?? '',
      // Convierte el rating a double, usa 0.0 como valor por defecto
      rating: (json['rating'] ?? 0.0).toDouble(),
      // Usa la fecha actual como valor por defecto si no hay fecha de creación
      createdAt: json['created_at'] ?? DateTime.now().toString(),
    );
  }
}