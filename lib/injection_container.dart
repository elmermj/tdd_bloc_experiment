import 'package:dio/dio.dart';
import 'config/constant_config.dart';
import 'config/flavor_config.dart';
import 'core/network/network_info.dart';
import 'core/util/dio_logging_interceptor.dart';
import 'feature/data/datasource/news/news_remote_data_source.dart';
import 'feature/data/repository/news/news_repository_impl.dart';
import 'feature/domain/repository/news/news_repository.dart';
import 'feature/domain/usecase/gettopheadlinesnews/get_top_headlines_news.dart';
import 'feature/domain/usecase/searchtopheadlinesnews/search_top_headlines_news.dart';
import 'feature/presentation/bloc/topheadlinesnews/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(
    () => TopHeadlinesNewsBloc(
      getTopHeadlinesNews: sl(),
      searchTopHeadlinesNews: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetTopHeadlinesNews(newsRepository: sl()));
  sl.registerLazySingleton(() => SearchTopHeadlinesNews(newsRepository: sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(newsRemoteDataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(dio: sl(), constantConfig: sl()));

  /**
   * ! Core
   */
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.baseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    return dio;
  });
  sl.registerLazySingleton(() => ConstantConfig());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
