import 'dart:convert';

import 'package:clean_code_architecture_tdd/feature/data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:clean_code_architecture_tdd/feature/domain/repository/news/news_repository.dart';
import 'package:clean_code_architecture_tdd/feature/domain/usecase/gettopheadlinesnews/get_top_headlines_news.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import '../searchtopheadlinesnews/search_top_headlines_news_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NewsRepository>()])
void main() {
  late GetTopHeadlinesNews getTopHeadlinesNews;
  late MockNewsRepository mockNewsRepository;
  final tCategory = 'technology';

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    getTopHeadlinesNews = GetTopHeadlinesNews(newsRepository: mockNewsRepository);
  });

  test(
    'make sure that NewsRepository successfully gets a successful or failed response from the getTopHeadlinesNews '
    'endpoint',
    () async {
      // arrange
      final tTopHeadlinesNewsResponseModel = TopHeadlinesNewsResponseModel.fromJson(
        json.decode(
          fixture('top_headlines_news_response_model.json'),
        ),
      );
      when(mockNewsRepository.getTopHeadlinesNews(tCategory))
          .thenAnswer((_) async => Right(tTopHeadlinesNewsResponseModel));

      // act
      final result = await getTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory));

      // assert
      expect(result, Right(tTopHeadlinesNewsResponseModel));
      verify(mockNewsRepository.getTopHeadlinesNews(tCategory));
      verifyNoMoreInteractions(mockNewsRepository);
    },
  );

  test(
    'make sure the output of the toString function',
    () async {
      // arrange
      final tParamsGetTopHeadlinesNews = ParamsGetTopHeadlinesNews(category: tCategory);

      // assert
      expect(
        tParamsGetTopHeadlinesNews.toString(),
        'ParamsGetTopHeadlinesNews{category: $tCategory}',
      );
    },
  );
}
