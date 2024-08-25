import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_news/configs/const.dart';

class NewsDao {
  Future<List<dynamic>> fetchTopHeadlines() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=$NEWSAPIKEY'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
