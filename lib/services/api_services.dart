import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newsapp/model/news.dart';

class ApiService {
  Future<List<News>> fetchNews() async {
    final apiKey = '96baa19cd52c4893aec2c7ea42d0c57d';
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'] ?? [];
        return articles.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }
}
