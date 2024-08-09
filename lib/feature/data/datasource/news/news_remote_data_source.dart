import 'package:dio/dio.dart';
import '../../../../config/constant_config.dart';
import '../../model/topheadlinesnews/top_headlines_news_response_model.dart';

abstract class NewsRemoteDataSource {
  /// Calls the [baseUrl]/v2/top-headlines?category=:category&country=:country&apiKey=:apiKey endpoint
  ///
  /// Throws a [DioException] for all error codes.
  Future<TopHeadlinesNewsResponseModel> getTopHeadlinesNews(String category);

  /// Calls the [baseUrl]/v2/top-headlines?country=:country&apiKey=:apiKey&q=:q
  ///
  /// Throws a [DioException] for all error codes.
  Future<TopHeadlinesNewsResponseModel> searchTopHeadlinesNews(String keyword);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;
  final ConstantConfig constantConfig;

  NewsRemoteDataSourceImpl({
    required this.dio,
    required this.constantConfig,
  });

  @override
  Future<TopHeadlinesNewsResponseModel> getTopHeadlinesNews(String category) async {
    var response;
    if (category == 'all') {
      response = await dio.get(
        '/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': constantConfig.keyNewsApi,
        },
      );
    } else {
      response = await dio.get(
        '/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': constantConfig.keyNewsApi,
          'category': category,
        },
      );
    }
    if (response.statusCode == 200) {
      return TopHeadlinesNewsResponseModel.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(), response: response);
    }
  }

  @override
  Future<TopHeadlinesNewsResponseModel> searchTopHeadlinesNews(String keyword) async {
    var response = await dio.get(
      '/v2/top-headlines',
      queryParameters: {
        'country': 'id',
        'apiKey': constantConfig.keyNewsApi,
        'q': keyword,
      },
    );
    if (response.statusCode == 200) {
      return TopHeadlinesNewsResponseModel.fromJson(response.data);
    } else {
      throw DioException(requestOptions: RequestOptions(), response: response);
    }
  }
}
