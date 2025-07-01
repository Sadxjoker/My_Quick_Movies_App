class MovieIdModel {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String releaseDate;
  final List<String> genre;
  final int runtime;
  final String tagline;
  final String status;
  final String originalLanguage;
  final int voteCount;
  final int budget;
  final int revenue;
  

  MovieIdModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.genre,
    required this.runtime,
    required this.tagline,
    required this.status,
    required this.originalLanguage,
    required this.voteCount,
    required this.budget,
    required this.revenue,
  });

  factory MovieIdModel.fromJson(Map<String, dynamic> json) {
    return MovieIdModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genre: (json['genres'] as List<dynamic>?)
              ?.map((genre) => genre['name'] as String)
              .toList() ??
          [],
      runtime: json['runtime'] ?? 0,
      tagline: json['tagline'] ?? '',
      status: json['status'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      voteCount: json['vote_count'] ?? 0,
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }
}

