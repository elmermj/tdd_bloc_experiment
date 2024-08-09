import 'dart:convert';

import 'package:clean_code_architecture_tdd/config/constant_config.dart';
import 'package:clean_code_architecture_tdd/feature/data/datasource/news/news_remote_data_source.dart';
import 'package:clean_code_architecture_tdd/feature/data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixture/fixture_reader.dart';
import 'news_remote_data_source_untest.mocks.dart';


@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late NewsRemoteDataSourceImpl newsRemoteDataSource;
  late ConstantConfig constantConfig;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    constantConfig = ConstantConfig();
    newsRemoteDataSource = NewsRemoteDataSourceImpl(
      dio: mockDio,
      constantConfig: constantConfig,
    );

    registerFallbackValue(Uri());
  });

  group('getTopHeadlinesNews', () {
    final tCategory = 'technology';
    final tTopHeadlinesNewsResponseModel = TopHeadlinesNewsResponseModel.fromJson(
      json.decode(
        fixture('top_headlines_news_response_model.json'),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture('top_headlines_news_response_model.json'));
      final response = Response(
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
        requestOptions: RequestOptions(
          path: '/v2/top-headlines',
        )
      );
      print('Setting up mock for Dio.get');
      when(() => mockDio.get(
        any<String>(named: 'path'),
        queryParameters: any<Map<String, dynamic>>(named: 'queryParameters'),
      )).thenAnswer((_) async {
        print('Mock invoked with: ${_.positionalArguments}');
        return Future.value(response);
      });
      print('Mock setup completed');
    }

    test(
      'make sure there is a GET request to endpoint /v2/top-headlines?country=:country&apiKey=:apiKey',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await newsRemoteDataSource.getTopHeadlinesNews('all');

        // assert
        verify(
          () => mockDio.get(
            '/v2/top-headlines',
            queryParameters: {
              'country': 'id',
              'apiKey': constantConfig.keyNewsApi,
            },
          ),
        ).called(1);

        verifyNever(mockDio.noSuchMethod(any()));
      },
    );

    test(
      'make sure there is a GET request to endpoint /v2/top-headlines?country=:country&apiKey=:apiKey&category=:category',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await newsRemoteDataSource.getTopHeadlinesNews(tCategory);

        // assert
        verify(
          () => mockDio.get(
            '/v2/top-headlines',
            queryParameters: {
              'category': tCategory,
              'country': 'id',
              'apiKey': constantConfig.keyNewsApi,
            },
          ),
        ).called(1);
      },
    );

    test(
      'make sure to return the TopHeadlinesNewsResponseModel object when the '
      'response code is successful from the endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await newsRemoteDataSource.getTopHeadlinesNews(tCategory);

        // assert
        expect(result, tTopHeadlinesNewsResponseModel);
      },
    );

    test(
      'make sure to receive DioError when the response code fails from the endpoint',
      () async {
        // arrange
        final response = Response(
          data: 'Bad Request',
          statusCode: 400,
          requestOptions: RequestOptions()
        );
        when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => response);

        // act
        final call = newsRemoteDataSource.getTopHeadlinesNews(tCategory);

        // assert
        expect(() => call, throwsA(isA<DioException>()));
      },
    );
  });

  group('searchTopHeadlinesNews', () {
    final tKeyword = 'testKeyword';
    final tTopHeadlinesNewsResponseModel = TopHeadlinesNewsResponseModel.fromJson(
      json.decode(
        fixture('top_headlines_news_response_model.json'),
      ),
    );

    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture('top_headlines_news_response_model.json'));
      final response = Response(
        data: responsePayload,
        statusCode: 200,
        headers: Headers.fromMap({
          Headers.contentTypeHeader: [Headers.jsonContentType],
        }),
        requestOptions: RequestOptions()
      );
      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => response);
    }

    test(
      'make sure there is a GET request to endpoint /v2/top-headlines?country=:country&apiKey=:apiKey&q=:q',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        await newsRemoteDataSource.searchTopHeadlinesNews(tKeyword);

        // assert
        verify(
          () => mockDio.get(
            '/v2/top-headlines',
            queryParameters: {
              'country': 'id',
              'apiKey': constantConfig.keyNewsApi,
              'q': tKeyword,
            },
          ),
        ).called(1);
      },
    );

    test(
      'make sure to return the TopHeadlinesNewsResponseModel object when the response code is success from the '
      'endpoint',
      () async {
        // arrange
        setUpMockDioSuccess();

        // act
        final result = await newsRemoteDataSource.searchTopHeadlinesNews(tKeyword);

        // assert
        expect(result, tTopHeadlinesNewsResponseModel);
      },
    );

    test(
      'make sure to receive DioError when the response code fails from the endpoint',
      () async {
        // arrange
        final response = Response(
          data: 'Bad Request',
          statusCode: 400,
          requestOptions: RequestOptions()
        );
        when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters'))).thenAnswer((_) async => response);

        // act
        final call = newsRemoteDataSource.searchTopHeadlinesNews(tKeyword);

        // assert
        expect(() => call, throwsA(isA<DioException>()));
      },
    );
  });
}
