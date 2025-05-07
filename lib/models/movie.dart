class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;
  final String? name; // Para series de TV
  final String? firstAirDate; // Para series de TV

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    this.name,
    this.firstAirDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Determinar si es una película o una serie de TV
    final bool isTVShow = json['name'] != null;

    return Movie(
      id: json['id'],
      title: isTVShow ? json['name'] : json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: isTVShow ? json['first_air_date'] : json['release_date'],
      name: json['name'],
      firstAirDate: json['first_air_date'],
    );
  }

  String get posterUrl {
    if (posterPath == null) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}