import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickmovies/Movie_View_Screen.dart';
import 'package:quickmovies/Movie_View_Screen2.dart';
import 'package:quickmovies/controllers/Latest_movie_controller.dart';
import 'package:quickmovies/controllers/Popular_Series_Controller.dart';
import 'package:quickmovies/controllers/Popular_movie_controller.dart';
import 'package:quickmovies/controllers/Search_Result_controller.dart';
import 'package:quickmovies/controllers/Tv_Series_Controller.dart';
import 'package:quickmovies/controllers/Upcoming_Controller.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  PopularMovieController popularMovieController =
      Get.put(PopularMovieController());
  LatestMovieController latestMovieController =
      Get.put(LatestMovieController());
  TvSeriesController tvSeriesController = Get.put(TvSeriesController());
  PopularSeriesController popularSeriesController =
      Get.put(PopularSeriesController());
  UpcomingController upcomingController = Get.put(UpcomingController());
  final SearchResultController searchResultController =
      Get.put(SearchResultController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          toolbarHeight: 120,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  "Find Movies, TV series,\nand more..",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SearchBar(
                  controller: searchController,
                  onSubmitted: (value) {
                    searchResultController.search(value);
                  },
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 27, 29, 43),
                  ),
                  hintText: "Search...",
                  hintStyle: WidgetStateProperty.all(
                    const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: [
                    GestureDetector(
                      onTap: () {
                        searchResultController.search(searchController.text);
                      },
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  textStyle: WidgetStateProperty.all(
                    const TextStyle(color: Colors.white),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(5),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            padding: EdgeInsets.symmetric(horizontal: 10),
            dividerHeight: 0,
            indicatorPadding: EdgeInsets.symmetric(vertical: 5),
            isScrollable: true,
            indicator: UnderlineTabIndicator(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(width: 3, color: Colors.deepOrangeAccent.shade100),
              insets: EdgeInsets.only(left: 0, right: 30),
            ),
            tabAlignment: TabAlignment.center,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.deepOrangeAccent.shade200,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
            tabs: [
              Tab(text: "Latest"),
              Tab(text: "Popular"),
              Tab(text: "Tv Series"),
              Tab(text: "Popular Series"),
              Tab(text: "Upcoming"),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    children: [
                      // Latest Movies
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 2.7,
                          ),
                          itemCount: latestMovieController.latestmovie.length,
                          itemBuilder: (context, index) {
                            final latestmovie =
                                latestMovieController.latestmovie[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MovieViewScreen(
                                        movieId: latestmovie.id),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w200${latestmovie.posterPath}',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.deepOrange,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        latestmovie.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Popular Movies
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 products per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 2.7, // Tweak height
                          ),
                          itemCount:
                              popularMovieController.popularmovies.length,
                          itemBuilder: (context, index) {
                            final popularmovie =
                                popularMovieController.popularmovies[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieViewScreen(
                                        movieId: popularmovie.id)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w200${popularmovie.posterPath}',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.deepOrange,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        popularmovie.title, // title
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Tv Series
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 products per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 2.7, // Tweak height
                          ),
                          itemCount: tvSeriesController.tvseries.length,
                          itemBuilder: (context, index) {
                            final tvseries = tvSeriesController.tvseries[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieViewScreen2(
                                        movieId: tvseries.id)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w200${tvseries.posterPath}',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.deepOrange,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        tvseries.name, // title
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Popular Series
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 products per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 2.7, // Tweak height
                          ),
                          itemCount:
                              popularSeriesController.popularseries.length,
                          itemBuilder: (context, index) {
                            final popularseries =
                                popularSeriesController.popularseries[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieViewScreen2(
                                        movieId: popularseries.id)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w200${popularseries.posterPath}',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.deepOrange,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        popularseries.title, // title
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Upcoming Movies
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 products per row
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2 / 2.7, // Tweak height
                          ),
                          itemCount: upcomingController.upcomingmovies.length,
                          itemBuilder: (context, index) {
                            final upcomingmovie =
                                upcomingController.upcomingmovies[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieViewScreen2(
                                        movieId: upcomingmovie.id)));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w200${upcomingmovie.posterPath}',
                                          width: double.infinity,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.deepOrange,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Center(
                                            child: Icon(Icons.error,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        upcomingmovie.title, // title
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  /// Overlay Search Results
                  Obx(() {
                    if (searchResultController.isLoading.value) {
                      return Container(
                        color: Colors.black.withOpacity(0.6),  
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Colors.deepOrangeAccent,
                        )),
                      );
                    }

                    if (searchController.text.isNotEmpty &&
                        searchResultController.combinedResults.isNotEmpty) {
                      return Container(
                        color: Colors.black.withOpacity(0.95),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Horizontal movie card list
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: searchResultController
                                      .combinedResults.length,
                                  itemBuilder: (context, index) {
                                    final result = searchResultController
                                        .combinedResults[index];
                                    final title = result['title'] ??
                                        result['name'] ??
                                        'No Title';
                                    final posterPath = result['poster_path'];

                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        searchController.clear();
                                        searchResultController.combinedResults
                                            .clear();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MovieViewScreen(
                                                movieId: result['id']),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: const Color(0xFF1B1D2B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        child: SizedBox(
                                          width: 140,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              posterPath != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      12)),
                                                      child: Image.network(
                                                        'https://image.tmdb.org/t/p/w200$posterPath',
                                                        height: 150,
                                                        width: 140,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 180,
                                                      width: 140,
                                                      color: Colors.grey[800],
                                                      child: const Icon(
                                                          Icons.image,
                                                          color: Colors.white),
                                                    ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),
                              Container(
                                height: 1,
                                color: Colors.grey,
                              ),

                              // Vertical text list
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchResultController
                                    .combinedResults.length,
                                itemBuilder: (context, index) {
                                  final result = searchResultController
                                      .combinedResults[index];
                                  final title = result['title'] ??
                                      result['name'] ??
                                      'No Title';

                                  return ListTile(
                                    title: Text(
                                      title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      searchController.clear();
                                      searchResultController.combinedResults
                                          .clear();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MovieViewScreen(
                                              movieId: result['id']),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
