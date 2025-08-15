import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/Movie_View_Screen.dart';
import 'package:quickmovies/controllers/movie_id_controller.dart';
import 'package:quickmovies/controllers/Popular_movie_controller.dart';
import 'package:quickmovies/models/Popular_movie_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

late PopularMovie selectedMovie;

class _HomeScreenState extends State<HomeScreen> {
  PopularMovieController movieController = Get.put(PopularMovieController());
  MovieIdController movieIdController = Get.put(MovieIdController());

  @override
  void initState() {
    super.initState();
    // When movies are fetched, select a random one
    ever(movieController.popularmovies, (_) {
      if (movieController.popularmovies.isNotEmpty) {
        selectedMovie =
            (movieController.popularmovies.toList()..shuffle()).first;
        setState(() {}); // refresh UI with new selectedMovie
      }
    });
    movieController.fetchMovies(); // fetch popular movies
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Row(
            children: [
              SizedBox(width: 35),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Stream ',
                      style: TextStyle(
                          color: Colors.deepOrangeAccent, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'Everywhere',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Colors.black,
            child: movieController.popularmovies.isEmpty
                ? SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.deepOrange,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${selectedMovie.posterPath}' ??
                            '',
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: 135,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieViewScreen(movieId: selectedMovie.id),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, top: 5, bottom: 5),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                MovieViewScreen(
                                                    movieId: selectedMovie.id),
                                          ));
                                        },
                                        icon: Image.asset(
                                            "assets/icons/play2.png"),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Continue Watching",
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            selectedMovie.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(width: 30),
              Text(
                "Trending",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ],
          ),
          Obx(() {
            if (movieController.isLoading.value) {
              return SizedBox(
                height: 350,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
              ); // or a fallback widget
            }
            return CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 10),
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                height: MediaQuery.of(context).size.height * 0.5,
                enlargeFactor: 0.2,
              ),
              items: movieController.popularmovies
                  .map(
                    (homemovie) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MovieViewScreen(movieId: homemovie.id)));
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.8, // 80% width
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Stack(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w200${homemovie.posterPath}' ??
                                    '',
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                              ),
                              Positioned(
                                right: 12,
                                top: 12,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.3))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "IDMb",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 10),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Colors.amberAccent,
                                                size: 20,
                                              ),
                                              Text(
                                                homemovie.rating
                                                    .toStringAsFixed(1),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 10,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 3, sigmaY: 3),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.3)),
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Text(
                                            homemovie.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}
