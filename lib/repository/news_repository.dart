import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/country_data_model.dart';
import '../models/categories_new_model.dart';
import '../models/news_channel_headlines_model.dart';

class NewsRepository {
  Future<CategoriesNewsModel> fetchNewsCategoires(String category) async {
    String newsUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=fbdd639693e34c3898aa0ddd72dc63be';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }

  Future<CountryHeadlinesModel> countryNews() async {
    String newsUrl =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=fbdd639693e34c3898aa0ddd72dc63be';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return CountryHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String newsChannel) async {
    String newsUrl =
        'https://newsapi.org/v2/top-headlines?sources=${newsChannel}&apiKey=fbdd639693e34c3898aa0ddd72dc63be';
    final response = await http.get(Uri.parse(newsUrl));
    print(response);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception('Error');
    }
  }
}
