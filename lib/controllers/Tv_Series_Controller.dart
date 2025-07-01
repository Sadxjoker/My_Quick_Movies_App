import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quickmovies/models/Tv_Series_Model.dart';

class TvSeriesController extends GetxController {
  var tvseries = <TvSeries>[].obs;
  var isLoading = true.obs;

  final String _baseUrl = 'https://api.themoviedb.org/3/tv/airing_today';
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

  /// ✅ Fetch all Tv series
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
        final List tvList = data['results'];
        tvseries.value = tvList.map((e) => TvSeries.fromJson(e)).toList();
        debugPrint('✅ Fetched ${tvseries.length} movies successfully');
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
