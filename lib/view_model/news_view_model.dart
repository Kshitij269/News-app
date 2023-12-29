import 'package:news_app/models/categories_new_model.dart';
import 'package:news_app/models/country_data_model.dart';
import 'package:news_app/models/news_channel_headlines_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<CategoriesNewsModel> fetchSearchDataApi(String data) async {
    final response = await _rep.fetchSearchData(data);
    return response;
  }

  Future<CountryHeadlinesModel> fetchCountryNewsApi() async {
    final response = await _rep.countryNews();
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoryNewsApi(String category) async {
    final response = await _rep.fetchNewsCategoires(category);
    return response;
  }

  Future<NewsChannelsHeadlinesModel> channelHeadlinesModelNewsApi() async {
    final response =
        await _rep.fetchNewsChannelHeadlinesApi("the-times-of-india");
    return response;
  }
}
