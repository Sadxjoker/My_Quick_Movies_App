import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchResultController extends GetxController {
  var isLoading = false.obs;
  var combinedResults = [].obs;

  final String accessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZGI1NTExMmVhNTFhOTM5ZGMzZWU1ZjVkOWNhZmNhYiIsIm5iZiI6MTc0NzE1NDgzNi41LCJzdWIiOiI2ODIzNzc5NDIyNGNiZThkMjc4NjQ3NGEiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.NtOjTodtMb93zJonE9f5qtyAEf7YmHYoxQZINQucqLE';

  final String baseUrl = 'https://api.themoviedb.org/3';

  Map<String, String> get headers => {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      };

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    isLoading.value = true;
    try {
      final encodedQuery = Uri.encodeComponent(query);

      final movieRes = await http.get(
        Uri.parse(
            '$baseUrl/search/movie?query=$encodedQuery&include_adult=false'),
        headers: headers,
      );
      print('🎬 Movie Response: ${movieRes.body}');

      final tvRes = await http.get(
        Uri.parse('$baseUrl/search/tv?query=$encodedQuery&include_adult=false'),
        headers: headers,
      );
      print('📺 TV Response: ${tvRes.body}');

      final movieData = json.decode(movieRes.body)['results'] as List;
      final tvData = json.decode(tvRes.body)['results'] as List;

      combinedResults.value = [...movieData, ...tvData];
    } catch (e) {
      print('❌ Search error: $e');
      combinedResults.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
