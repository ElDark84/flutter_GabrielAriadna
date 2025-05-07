class Review {
  final String author;
  final String content;
  final double rating;
  final String createdAt;

  Review({
    required this.author,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] ?? 'Anonymous',
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] ?? DateTime.now().toString(),
    );
  }
}