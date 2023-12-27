import 'package:news_app/models/country_data_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<CountryHeadlinesModel> fetchCountryNewsApi() async {
    final response = await _rep.countryNews();
    return response;
  }
}
