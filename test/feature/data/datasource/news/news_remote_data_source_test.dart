import 'package:clean_code_architecture_tdd/config/constant_config.dart';
import 'package:clean_code_architecture_tdd/feature/data/datasource/news/news_remote_data_source.dart';
import 'package:clean_code_architecture_tdd/feature/data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'news_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<ConstantConfig>()])
void main() {
  late MockDio mockDio;
  late MockConstantConfig mockConstantConfig;
  late NewsRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    mockConstantConfig = MockConstantConfig();
    dataSource = NewsRemoteDataSourceImpl(
      dio: mockDio,
      constantConfig: mockConstantConfig,
    );
  });

  group('getTopHeadlinesNews', () {
    final category = 'business';
    final mockResponseData = {
      'status': 'ok',
      'totalResults': 2,
      'articles': [
        {'title': 'Article 1', 'description': 'Description 1'},
        {'title': 'Article 2', 'description': 'Description 2'},
      ],
    };

    test('returns TopHeadlinesNewsResponseModel when response is successful', () async {
      // arrange
      when(mockConstantConfig.keyNewsApi).thenReturn('testApiKey');
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
        (_) async => Response(
          data: mockResponseData,
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.getTopHeadlinesNews(category);

      // assert
      expect(result, isA<TopHeadlinesNewsResponseModel>());
      verify(mockDio.get('/v2/top-headlines', queryParameters: {
        'country': 'us',
        'apiKey': 'testApiKey',
        'category': category,
      })).called(1);
    });

    test('throws DioException when response is not successful', () async {
      // arrange
      when(mockConstantConfig.keyNewsApi).thenReturn('testApiKey');
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      // act & assert
      expect(
        () async => await dataSource.getTopHeadlinesNews(category),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('searchTopHeadlinesNews', () {
    final keyword = 'Flutter';
    final mockResponseData = {
      'status': 'ok',
      'totalResults': 1,
      'articles': [
        {'title': 'Flutter News', 'description': 'Flutter is awesome'},
      ],
    };

    test('returns TopHeadlinesNewsResponseModel when response is successful', () async {
      // arrange
      when(mockConstantConfig.keyNewsApi).thenReturn('testApiKey');
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
        (_) async => Response(
          data: mockResponseData,
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
        ),
      );

      // act
      final result = await dataSource.searchTopHeadlinesNews(keyword);

      // assert
      expect(result, isA<TopHeadlinesNewsResponseModel>());
      verify(mockDio.get('/v2/top-headlines', queryParameters: {
        'country': 'id',
        'apiKey': 'testApiKey',
        'q': keyword,
      })).called(1);
    });

    test('throws DioException when response is not successful', () async {
      // arrange
      when(mockConstantConfig.keyNewsApi).thenReturn('testApiKey');
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
        ),
      );

      // act & assert
      expect(
        () async => await dataSource.searchTopHeadlinesNews(keyword),
        throwsA(isA<DioException>()),
      );
    });
  });
}
