class TvSeries {
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double rating;
  final String firstAirDate;
  final List<int> genreIds;
  final List<String> originCountry;
  final String originalLanguage;
  final int voteCount;
  final double popularity;

  TvSeries({
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.rating,
    required this.firstAirDate,
    required this.genreIds,
    required this.originCountry,
    required this.originalLanguage,
    required this.voteCount,
    required this.popularity,
  });

  factory TvSeries.fromJson(Map<String, dynamic> json) {
    return TvSeries(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      firstAirDate: json['first_air_date'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'] ?? '',
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
    );
  }
}
