import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../data/model/topheadlinesnews/top_headlines_news_response_model.dart';

abstract class NewsRepository {

  Future<Either<Failure, TopHeadlinesNewsResponseModel>> getTopHeadlinesNews(String category);

  Future<Either<Failure, TopHeadlinesNewsResponseModel>> searchTopHeadlinesNews(String keyword);
}