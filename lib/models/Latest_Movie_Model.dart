class LatestMovie {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String releaseDate;
  final List<int> genreIds;
  final String originalLanguage;
  final bool adult;
  final bool video;
  final int voteCount;
  final double popularity;

  LatestMovie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.genreIds,
    required this.originalLanguage,
    required this.adult,
    required this.video,
    required this.voteCount,
    required this.popularity,
  });

  factory LatestMovie.fromJson(Map<String, dynamic> json) {
    return LatestMovie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }
}
