// Modelo de datos que representa una película o serie de televisión
class Movie {
  // Propiedades básicas de la película/serie
  final int id;  // Identificador único
  final String title;  // Título de la película o serie
  final String overview;  // Descripción o sinopsis
  final String? posterPath;  // Ruta del póster (opcional)
  final double voteAverage;  // Calificación promedio
  final String releaseDate;  // Fecha de lanzamiento
  final String? name;  // Nombre (usado para series de TV)
  final String? firstAirDate;  // Fecha de primera emisión (para series de TV)

  // Propiedades adicionales
  final List<String> cast;  // Lista de actores principales
  final int? budget;  // Presupuesto de la película (opcional)

  // Constructor que inicializa todas las propiedades
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    this.name,
    this.firstAirDate,
    this.cast = const [],  // Lista vacía por defecto
    this.budget,
  });

  // Constructor de fábrica que crea una instancia de Movie desde JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Determina si el contenido es una serie de TV
    final bool isTVShow = json['name'] != null;

    // Obtiene el título o nombre según el tipo de contenido
    final String title = isTVShow ? json['name'] : json['title'];
    
    // Obtiene la fecha de lanzamiento o primera emisión según el tipo de contenido
    final String releaseDate = isTVShow ? json['first_air_date'] : json['release_date'];

    // Construye la URL completa del póster si existe una ruta
    String? posterUrl;
    if (json['poster_path'] != null) {
      posterUrl = 'https://image.tmdb.org/t/p/w500${json['poster_path']}';
    }

    // Crea y retorna una nueva instancia de Movie con los datos procesados
    return Movie(
      id: json['id'],
      title: title,
      overview: json['overview'] ?? '',
      posterPath: posterUrl,
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      releaseDate: releaseDate,
      name: isTVShow ? json['name'] : null,
      firstAirDate: isTVShow ? json['first_air_date'] : null,
      budget: json['budget'],
    );
  }

  // Getter para obtener la URL del póster
  String get posterUrl => posterPath ?? 'https://via.placeholder.com/500x750?text=No+Image';
}
