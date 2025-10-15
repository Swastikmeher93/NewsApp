import 'package:flutter/material.dart';
import 'package:newsapp/model/news.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/providers/news_provider.dart';
import 'package:provider/provider.dart';

class HomeDetailsPage extends StatelessWidget {
  final News newsItem;

  const HomeDetailsPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newsItem.source.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newsItem.urlToImage != null && newsItem.urlToImage!.isNotEmpty)
              SizedBox(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  newsItem.urlToImage!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    newsItem.title,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ) ??
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    context.watch<NewsProvider>().isBookmarked(newsItem)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  onPressed: () {
                    context.read<NewsProvider>().toggleBookmark(newsItem);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (newsItem.description != null)
              Text(
                newsItem.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8),
            Text(
              'Published At: ${DateFormat('dd MMMM, yyyy').format(DateTime.parse(newsItem.publishedAt))}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            if (newsItem.author != null)
              Text(
                'Author: ${newsItem.author}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            if (newsItem.content != null)
              Text(
                newsItem.content!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
          ],
        ),
      ),
    );
  }
}
