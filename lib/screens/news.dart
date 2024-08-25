import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/news.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> _newsArticles;

  @override
  void initState() {
    super.initState();
    _newsArticles = NewsService().fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Headlines'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _newsArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news found'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              final imageUrl = article['urlToImage'] ?? '';
              final title = article['title'] ?? 'No title';
              final description = article['description'] ?? 'No description';
              final newsUrl = article['url'];

              return newsCard(imageUrl, title, description, newsUrl);
            },
          );
        },
      ),
    );
  }

  // The card layout for news
  Widget newsCard(imageUrl, title, description, newsUrl) {
    return GestureDetector(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(newsUrl))) {
            await launchUrl(
              Uri.parse(newsUrl),
              mode: LaunchMode.platformDefault,
            );
          } else {
            throw 'Could not launch ${newsUrl}';
          }
        },
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                // The image of the news
                imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: MediaQuery.sizeOf(context).height * 0.24,
                        width: MediaQuery.sizeOf(context).width * 0.32,
                      )
                    : Container(
                        color: Colors.grey,
                        height: MediaQuery.sizeOf(context).height * 0.24,
                        width: MediaQuery.sizeOf(context).width * 0.32,
                        child: Center(
                          child: Text('No Image'),
                        ),
                      ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // The title of the news
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(title,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 16,
                                // Bold
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis)),
                      ),
                      // The description of the news
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(description,
                            maxLines: 5,
                            style: const TextStyle(
                                fontSize: 12, overflow: TextOverflow.ellipsis)),
                      ),
                      // A gap
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ],
            )));
  }
}
