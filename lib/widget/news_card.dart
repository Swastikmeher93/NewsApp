import 'package:flutter/material.dart';
import 'package:newsapp/model/news.dart';
import 'package:newsapp/UI/home_details_page.dart';
import 'package:newsapp/providers/news_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewsCard extends StatelessWidget {
  final News newsItem;

  const NewsCard({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDetailsPage(newsItem: newsItem),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                height: 150,
                width: double.infinity,
                child: newsItem.urlToImage != null
                    ? Image.network(newsItem.urlToImage!, fit: BoxFit.cover)
                    : Container(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                newsItem.source.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              // Title
              Text(
                newsItem.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // Date and icon row
              Row(
                children: [
                  Text(
                    'Published on: ${DateFormat('dd MMMM, yyyy').format(DateTime.parse(newsItem.publishedAt))}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
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
            ],
          ),
        ),
      ),
    );
  }
}
