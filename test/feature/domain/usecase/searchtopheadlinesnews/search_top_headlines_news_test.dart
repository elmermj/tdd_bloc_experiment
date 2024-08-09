import 'dart:convert';

import 'package:clean_code_architecture_tdd/feature/data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:clean_code_architecture_tdd/feature/domain/repository/news/news_repository.dart';
import 'package:clean_code_architecture_tdd/feature/domain/usecase/searchtopheadlinesnews/search_top_headlines_news.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import 'search_top_headlines_news_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NewsRepository>()])
void main() {
  late SearchTopHeadlinesNews searchTopHeadlinesNews;
  late MockNewsRepository mockNewsRepository;
  final tKeyword = 'testKeyword';
  final tParamsSearchTopHeadlinesNews = ParamsSearchTopHeadlinesNews(keyword: tKeyword);

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    searchTopHeadlinesNews = SearchTopHeadlinesNews(newsRepository: mockNewsRepository);
  });

  test(
    'make sure that NewsRepository successfully gets a successful or failed response from the searchTopHeadlinesNews '
    'endpoint',
    () async {
      // arrange
      final tTopHeadlinesNewsResponseModel = TopHeadlinesNewsResponseModel.fromJson(
        json.decode(
          fixture('top_headlines_news_response_model.json'),
        ),
      );
      when(mockNewsRepository.searchTopHeadlinesNews(tKeyword))
          .thenAnswer((_) async => Right(tTopHeadlinesNewsResponseModel));

      // act
      final result = await searchTopHeadlinesNews(tParamsSearchTopHeadlinesNews);

      // assert
      expect(result, Right(tTopHeadlinesNewsResponseModel));
      verify(mockNewsRepository.searchTopHeadlinesNews(tKeyword));
      verifyNoMoreInteractions(mockNewsRepository);
    },
  );

  test(
    'make sure the props value',
    () async {
      // assert
      expect(
        tParamsSearchTopHeadlinesNews.props,
        [tParamsSearchTopHeadlinesNews.keyword],
      );
    },
  );

  test(
    'make sure the output of the toString function',
    () async {
      // assert
      expect(
        tParamsSearchTopHeadlinesNews.toString(),
        'ParamsSearchTopHeadlinesNews{keyword: ${tParamsSearchTopHeadlinesNews.keyword}}',
      );
    },
  );
}
