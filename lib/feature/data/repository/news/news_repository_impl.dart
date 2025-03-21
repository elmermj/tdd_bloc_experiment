import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../datasource/news/news_remote_data_source.dart';
import '../../model/topheadlinesnews/top_headlines_news_response_model.dart';
import '../../../domain/repository/news/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource newsRemoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.newsRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TopHeadlinesNewsResponseModel>> getTopHeadlinesNews(String category) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await newsRemoteDataSource.getTopHeadlinesNews(category);
        return Right(response);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message!));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, TopHeadlinesNewsResponseModel>> searchTopHeadlinesNews(String keyword) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        var response = await newsRemoteDataSource.searchTopHeadlinesNews(keyword);
        return Right(response);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message!));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
