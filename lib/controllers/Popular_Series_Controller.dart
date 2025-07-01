// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:quickmovies/models/movie_model.dart';

// class MovieController extends GetxController {
//   var movies = <Movie>[].obs;
//   var isLoading = true.obs;

//   final String _baseUrl = 'https://api.themoviedb.org/3/movie/popular';
//   final String _bearerToken =
//       'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGI1NTExMmVhNTFhOTM5ZGMzZWU1ZjVkOWNhZmNhYiIsIm5iZiI6MTc0NzE1NDgzNi41LCJzdWIiOiI2ODIzNzc5NDIyNGNiZThkMjc4NjQ3NGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.NtOjTodtMb93zJonE9f5qtyAEf7YmHYoxQZINQucqLE';

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMovies();
//   }

//   void setLoading(value) {
//     isLoading.value = value;
//   }

//   Future<void> fetchMovies() async {
//     try {
//       setLoading(true);
//       final response = await http.get(
//         Uri.parse(_baseUrl),
//         headers: {
//           'Authorization': 'Bearer $_bearerToken',
//           'accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = jsonDecode(response.body);
//         final List moviesList = data['results'];
//         movies.value = moviesList.map((e) => Movie.fromJson(e)).toList();
//         debugPrint('Fetched ${movies.length} movies successfully');
//       } else {
//         debugPrint('Failed to fetch movies: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint("Error fetching movies: ${e.toString()}");
//     } finally {
//       setLoading(false);
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickmovies/models/Popular_movie_model.dart';

class PopularSeriesController extends GetxController {
  var popularseries = <PopularMovie>[].obs;
  var isLoading = true.obs;

  final String _baseUrl = 'https://api.themoviedb.org/3/tv/popular';
  final String _bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGI1NTExMmVhNTFhOTM5ZGMzZWU1ZjVkOWNhZmNhYiIsIm5iZiI6MTc0NzE1NDgzNi41LCJzdWIiOiI2ODIzNzc5NDIyNGNiZThkMjc4NjQ3NGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.NtOjTodtMb93zJonE9f5qtyAEf7YmHYoxQZINQucqLE';

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  void setLoading(value) {
    isLoading.value = value;
  }

  /// ✅ Fetch all popular movies
  Future<void> fetchMovies() async {
    try {
      setLoading(true);
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List popularmoviesList = data['results'];
        popularseries.value =
            popularmoviesList.map((e) => PopularMovie.fromJson(e)).toList();
        debugPrint('✅ Fetched ${popularseries.length} movies successfully');
      } else {
        debugPrint('❌ Failed to fetch movies: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Error fetching movies: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }
}
