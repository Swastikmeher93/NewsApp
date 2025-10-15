import 'package:flutter/material.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/services/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<News> _news = [];
  bool _isLoading = false;
  String? _error;
  List<News> _bookmarks = [];

  List<News> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<News> get bookmarks => _bookmarks;

  Future<void> fetchNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _news = await _apiService.fetchNews();
      await loadBookmarks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];
    _bookmarks = _news
        .where((news) => bookmarkedTitles.contains(news.title))
        .toList();
  }

  Future<void> toggleBookmark(News newsItem) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedTitles = prefs.getStringList('bookmarks') ?? [];

    if (bookmarkedTitles.contains(newsItem.title)) {
      bookmarkedTitles.remove(newsItem.title);
      _bookmarks.removeWhere((item) => item.title == newsItem.title);
    } else {
      bookmarkedTitles.add(newsItem.title);
      _bookmarks.add(newsItem);
    }

    await prefs.setStringList('bookmarks', bookmarkedTitles);
    notifyListeners();
  }

  bool isBookmarked(News newsItem) {
    return _bookmarks.any((item) => item.title == newsItem.title);
  }
}
