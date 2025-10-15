import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:newsapp/providers/news_provider.dart';
import 'package:newsapp/widget/news_card.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          final bookmarks = newsProvider.bookmarks;

          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks yet'));
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final newsItem = bookmarks[index];
              return NewsCard(newsItem: newsItem);
            },
          );
        },
      ),
    );
  }
}
