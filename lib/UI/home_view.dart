import 'package:flutter/material.dart';
import 'package:newsapp/UI/profile_view.dart';
import 'package:provider/provider.dart';
import 'package:newsapp/providers/news_provider.dart';
import 'package:newsapp/widget/news_card.dart';
import 'package:newsapp/UI/bookmarks_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NewsApp"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarksPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileView()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            if (newsProvider.isLoading) {
              return const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (newsProvider.error != null) {
              return SizedBox(
                height: 400,
                child: Center(child: Text('Error: ${newsProvider.error}')),
              );
            }

            return Column(
              children: newsProvider.news.map((newsItem) {
                return NewsCard(newsItem: newsItem);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
