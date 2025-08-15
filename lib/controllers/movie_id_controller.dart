// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:quickmovies/models/movie_id_model.dart';

// class MovieIdController extends GetxController {
//   var isLoading = false.obs;

//   Rx<MovieIdModel?> movieDetail = Rx<MovieIdModel?>(null);

//   final String _bearerToken =
//       'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGI1NTExMmVhNTFhOTM5ZGMzZWU1ZjVkOWNhZmNhYiIsIm5iZiI6MTc0NzE1NDgzNi41LCJzdWIiOiI2ODIzNzc5NDIyNGNiZThkMjc4NjQ3NGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.NtOjTodtMb93zJonE9f5qtyAEf7YmHYoxQZINQucqLE';

//   Future<void> fetchMovieDetail(int movieId) async {
//     try {
//       isLoading.value = true;
//       final response = await http.get(
//         Uri.parse('https://api.themoviedb.org/3/movie/$movieId'),
//         headers: {
//           'Authorization': 'Bearer $_bearerToken',
//           'accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         movieDetail.value = MovieIdModel.fromJson(data);
//         debugPrint("✅ Movie detail loaded for ID: $movieId");
//       } else {
//         debugPrint("❌ Failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("❌ Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickmovies/models/movie_id_model.dart';

class MovieIdController extends GetxController {
  var isLoading = false.obs;
  RxBool isFavorite = false.obs;

  Rx<MovieIdModel?> movieDetail = Rx<MovieIdModel?>(null);
  RxList<MovieIdModel> favoritesList = <MovieIdModel>[].obs;

  final storage = GetStorage();

  final String _bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGI1NTExMmVhNTFhOTM5ZGMzZWU1ZjVkOWNhZmNhYiIsIm5iZiI6MTc0NzE1NDgzNi41LCJzdWIiOiI2ODIzNzc5NDIyNGNiZThkMjc4NjQ3NGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.NtOjTodtMb93zJonE9f5qtyAEf7YmHYoxQZINQucqLE';

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // 🔹 Load favorites from storage
  void loadFavorites() {
    final storedData = storage.read('favorites');
    if (storedData != null) {
      List decoded = jsonDecode(storedData);
      favoritesList
          .assignAll(decoded.map((e) => MovieIdModel.fromJson(e)).toList());
    }
  }

  // 🔹 Save favorites to storage
  void saveFavorites() {
    storage.write('favorites', jsonEncode(favoritesList));
  }

  // 🔹 Add to favorites
  void addToFavorites(MovieIdModel movie) {
    if (!favoritesList.any((m) => m.id == movie.id)) {
      favoritesList.add(movie);
      saveFavorites();
    }
    isFavorite.value = true;
  }

  // 🔹 Remove from favorites
  void removeFromFavorites(MovieIdModel movie) {
    favoritesList.removeWhere((m) => m.id == movie.id);
    saveFavorites();
    isFavorite.value = false;
  }

  // 🔹 Check favorite status
  void checkIfFavorite(int movieId) {
    isFavorite.value = favoritesList.any((m) => m.id == movieId);
  }

  // 🔹 Fetch movie detail
  Future<void> fetchMovieDetail(int movieId) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/movie/$movieId'),
        headers: {
          'Authorization': 'Bearer $_bearerToken',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        movieDetail.value = MovieIdModel.fromJson(data);

        // check if already favorite
        checkIfFavorite(movieId);
        debugPrint("✅ Movie detail loaded for ID: $movieId");
      } else {
        debugPrint("❌ Failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
