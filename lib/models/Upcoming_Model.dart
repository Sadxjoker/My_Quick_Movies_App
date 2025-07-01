class Upcoming {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final String originalLanguage;
  final List<int> genreIds;
  final bool adult;
  final bool video;

  Upcoming({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.originalLanguage,
    required this.genreIds,
    required this.adult,
    required this.video,
  });

  factory Upcoming.fromJson(Map<String, dynamic> json) {
    return Upcoming(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? true,
      video: json['video'] ?? true,
    );
  }
}
