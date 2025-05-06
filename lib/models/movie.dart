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
