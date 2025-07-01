class PopularMovie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double rating;
  final String releaseDate;
  final List<int> genreid;
  final String descrip;
  final int voteCount;

  PopularMovie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.rating,
    required this.releaseDate,
    required this.genreid,
    required this.descrip,
    required this.voteCount,
  });

  factory PopularMovie.fromJson(Map<String, dynamic> json) {
    return PopularMovie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genreid: List<int>.from(json['genre_ids'] ?? []),
      descrip: json['overview'] ?? '',
      voteCount: json['vote_count'] ?? 0,
    );
  }
}
