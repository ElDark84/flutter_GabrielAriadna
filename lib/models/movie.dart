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

    return Movie(
      id: json['id'],
      // Usa 'name' para series de TV y 'title' para películas
      title: isTVShow ? json['name'] : json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      // Convierte el valor numérico a double para la calificación
      voteAverage: (json['vote_average'] as num).toDouble(),
      // Usa 'first_air_date' para series y 'release_date' para películas
      releaseDate: isTVShow ? json['first_air_date'] : json['release_date'],
      name: json['name'],
      firstAirDate: json['first_air_date'],
      // Extrae los nombres de los actores del JSON si están disponibles
      cast: json['cast'] != null
          ? List<String>.from(json['cast'].map((c) => c['name']))
          : [],
      budget: json['budget'],
    );
  }

  // Getter que construye la URL completa del póster
  String get posterUrl {
    if (posterPath == null) return '';  // Retorna cadena vacía si no hay póster
    // Construye la URL usando la base de TMDB y la ruta del póster
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}
