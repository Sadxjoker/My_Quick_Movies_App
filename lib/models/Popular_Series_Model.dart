class PopularSeries {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String releaseDate;
  final List<int> genreIds;
  final int voteCount;
  final bool adult;
  final bool video;
  final String originalLanguage;
  final String originalTitle;
  final double popularity;

  PopularSeries({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.releaseDate,
    required this.genreIds,
    required this.voteCount,
    required this.adult,
    required this.video,
    required this.originalLanguage,
    required this.originalTitle,
    required this.popularity,
  });

  factory PopularSeries.fromJson(Map<String, dynamic> json) {
    return PopularSeries(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }
}
