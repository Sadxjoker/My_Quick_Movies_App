import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/controllers/Tv_Series_Controller.dart';
import 'package:quickmovies/controllers/movie_id_controller.dart';
import 'package:quickmovies/controllers/Popular_movie_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieViewScreen2 extends StatefulWidget {
  final int movieId;
  const MovieViewScreen2({super.key, required this.movieId});

  @override
  State<MovieViewScreen2> createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends State<MovieViewScreen2> {
  final MovieIdController movieIdController = Get.put(MovieIdController());
  final PopularMovieController popularMovieController =
      Get.put(PopularMovieController());
  final TvSeriesController tvSeriesController = Get.put(TvSeriesController());

  late int selectedMovieId;

  @override
  void initState() {
    super.initState();
    selectedMovieId = widget.movieId;
    movieIdController.fetchMovieDetail(selectedMovieId);
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Not Found Movie!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is a Testing API, not for playing movies.\nIf you want to watch movies, please use an official streaming service.',
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () async {
                final url = Uri.parse("http://moviebox.ph");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  Get.snackbar("Error", "Could not open website");
                }
              },
              child: Row(
                children: [
                  const Text("Visit: "),
                  const Text(
                    "Visit: http://moviebox.ph",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Back',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (movieIdController.isLoading.value ||
          movieIdController.movieDetail.value == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final movie = movieIdController.movieDetail.value!;

      return Scaffold(
        body: ListView(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 330,
                  child: movie.posterPath.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 100,
                          ),
                        ),
                ),
                Positioned.fill(
                  child: Center(
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
                        child: InkWell(
                          onTap: () => dialog(context),
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 50,
                              color: Colors.deepOrangeAccent.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.deepOrangeAccent,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Obx(() => IconButton(
                          onPressed: () {
                            if (movieIdController.isFavorite.value) {
                              // Remove from favorites
                              movieIdController.removeFromFavorites(movie);
                              Get.snackbar(
                                  "Success", "Movie removed from favorites");
                            } else {
                              // Add to favorites
                              movieIdController.addToFavorites(movie);
                              Get.snackbar(
                                  "Success", "Movie added to favorites");
                            }
                          },
                          icon: Icon(
                            movieIdController.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.deepOrange,
                            size: 30,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: Colors.white.withOpacity(0.5),
                              offset: Offset(-1, -1),
                            ),
                          ],
                        ),
                        child: Text("4K", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.watch_later_outlined,
                          color: Colors.grey, size: 15),
                      SizedBox(width: 3),
                      Text('${movie.runtime} minutes',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(width: 10),
                      Icon(Icons.star_rounded, size: 15),
                      SizedBox(width: 3),
                      Text(movie.rating.toStringAsFixed(1),
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(color: Colors.grey.shade800, height: 1),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Release date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(movie.releaseDate,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Genre",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 200,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(31, 14, 13, 13),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Wrap(
                                children: movie.genre.map((genreName) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.black,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 2,
                                          color: Colors.white.withOpacity(0.5),
                                          offset: const Offset(-1, -1),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      genreName,
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Synopsis",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  ReadMoreText(text: movie.overview),
                  SizedBox(height: 10),
                  Text(
                    "Related Movies",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tvSeriesController.tvseries.length,
                        itemBuilder: (context, index) {
                          final related = tvSeriesController.tvseries[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMovieId = related.id;
                                movieIdController
                                    .fetchMovieDetail(selectedMovieId);
                              });
                            },
                            child: SizedBox(
                              width: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Card(
                                    margin: EdgeInsets.only(top: 10),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w200${related.posterPath}',
                                      width: 130,
                                      height: 160,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          related.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Text(
                                        '(${related.firstAirDate.split('-')[0]})',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int limit;
  const ReadMoreText({super.key, required this.text, this.limit = 50});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: isExpanded ? widget.text : widget.text.substring(0, widget.limit),
        style: const TextStyle(fontSize: 11, color: Colors.grey),
        children: [
          if (!isExpanded)
            TextSpan(
              text: " Read More..",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = true;
                  });
                },
            ),
        ],
      ),
    );
  }
}
