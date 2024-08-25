import '../daos/news.dart';

class NewsService {
  /// Fetch the headlines
  Future<List<dynamic>> fetchTopHeadlines() async {
    return NewsDao().fetchTopHeadlines();
  }
}
