// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:quickmovies/models/genre_model.dart';


// class GenreController extends GetxController {
//   var genrename = <Genre>[].obs;
//   var isLoading = true.obs;

//   final String _baseUrl = 'https://api.themoviedb.org/3/genre/movie/list';
//   final String _bearerToken =
//       'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGI1NTExMmVhNTFhOTM5ZGMzZWU1ZjVkOWNhZmNhYiIsIm5iZiI6MTc0NzE1NDgzNi41LCJzdWIiOiI2ODIzNzc5NDIyNGNiZThkMjc4NjQ3NGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.NtOjTodtMb93zJonE9f5qtyAEf7YmHYoxQZINQucqLE';

//   @override
//   void onInit() {
//     super.onInit();
//     fetchGenre();
//   }

//   void setLoading(value) {
//     isLoading.value = value;
//   }

//   String getGenreNameById(int id) {
//     final genre = genrename.firstWhere(
//       (g) => g.id == id,
//       orElse: () => Genre(id: id, name: id.toString()),
//     );

//     return genre.name;
//   }

//   Future<void> fetchGenre() async {
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
//         final List genreList = data['genres'];
//         genrename.value = genreList.map((e) => Genre.fromJson(e)).toList();
//         debugPrint(
//             'Fetched genres: ${genrename.map((g) => '${g.id}: ${g.name}').toList()}');

//         debugPrint('Fetched ${genrename.length} ge  nres successfully');
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


