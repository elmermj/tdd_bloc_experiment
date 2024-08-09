import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_code_architecture_tdd/core/error/failure.dart';
import 'package:clean_code_architecture_tdd/feature/data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:clean_code_architecture_tdd/feature/domain/usecase/gettopheadlinesnews/get_top_headlines_news.dart';
import 'package:clean_code_architecture_tdd/feature/domain/usecase/searchtopheadlinesnews/search_top_headlines_news.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/bloc/topheadlinesnews/top_headlines_news_bloc.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/bloc/topheadlinesnews/top_headlines_news_event.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/bloc/topheadlinesnews/top_headlines_news_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixture/fixture_reader.dart';
import 'top_headlines_news_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetTopHeadlinesNews>(), MockSpec<SearchTopHeadlinesNews>()])
void main() {
  late MockGetTopHeadlinesNews mockGetTopHeadlinesNews;
  late MockSearchTopHeadlinesNews mockSearchTopHeadlinesNews;
  late TopHeadlinesNewsBloc topHeadlinesNewsBloc;

  setUp(() {
    mockGetTopHeadlinesNews = MockGetTopHeadlinesNews();
    mockSearchTopHeadlinesNews = MockSearchTopHeadlinesNews();
    topHeadlinesNewsBloc = TopHeadlinesNewsBloc(
      getTopHeadlinesNews: mockGetTopHeadlinesNews,
      searchTopHeadlinesNews: mockSearchTopHeadlinesNews,
    );
  });

  tearDown(() {
    topHeadlinesNewsBloc.close();
  });

  test(
    'make sure that AssertionError will be called when accepting null arguments',
    () async {
      expect(
        () => TopHeadlinesNewsBloc(
          getTopHeadlinesNews: null,
          searchTopHeadlinesNews: null,
        ),
        throwsAssertionError,
      );
      expect(
        () => TopHeadlinesNewsBloc(
          getTopHeadlinesNews: mockGetTopHeadlinesNews,
          searchTopHeadlinesNews: null,
        ),
        throwsAssertionError,
      );
      expect(
        () => TopHeadlinesNewsBloc(
          getTopHeadlinesNews: null,
          searchTopHeadlinesNews: mockSearchTopHeadlinesNews,
        ),
        throwsAssertionError,
      );
    },
  );

  test(
    'make sure that initialState must be InitialTopHeadlinesNewsState',
    () async {
      expect(topHeadlinesNewsBloc.state, InitialTopHeadlinesNewsState());
    },
  );

  test(
    'make sure that no state are emitted when TopHeadlinesNewsBloc is closed',
    () async {
      await topHeadlinesNewsBloc.close();
      await expectLater(topHeadlinesNewsBloc.stream, emitsInOrder([emitsDone]));
    },
  );

  group('LoadTopHeadlinesNews', () {
    const tCategory = 'technology';
    final tTopHeadlinesNewsResponseModel = TopHeadlinesNewsResponseModel.fromJson(
      json.decode(
        fixture('top_headlines_news_response_model.json'),
      ),
    );

    test(
      'make sure that the GetTopHeadlinesNews use case is really called',
      () async {
        when(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory)))
            .thenAnswer((_) async => Right(tTopHeadlinesNewsResponseModel));

        topHeadlinesNewsBloc.add(LoadTopHeadlinesNewsEvent(category: tCategory));
        await untilCalled(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory)));

        verify(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory))).called(1);
      },
    );

    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [LoadingTopHeadlinesNewsState, LoadedTopHeadlinesNewsState] when receive LoadTopHeadlinesNewsEvent with a successful process',
      build: () {
        when(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory)))
            .thenAnswer((_) async => Right(tTopHeadlinesNewsResponseModel));
        return topHeadlinesNewsBloc;
      },
      act: (bloc) => bloc.add(LoadTopHeadlinesNewsEvent(category: tCategory)),
      expect: () => [
        LoadingTopHeadlinesNewsState(),
        LoadedTopHeadlinesNewsState(listArticles: tTopHeadlinesNewsResponseModel.articles!),
      ],
      verify: (_) async {
        verify(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory))).called(1);
      },
    );

    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [LoadingTopHeadlinesNewsState, FailureTopHeadlinesNewsState] when receive LoadTopHeadlinesNewsEvent with a failed process from endpoint',
      build: () {
        when(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory)))
            .thenAnswer((_) async => Left(ServerFailure('testErrorMessage')));
        return topHeadlinesNewsBloc;
      },
      act: (bloc) => bloc.add(LoadTopHeadlinesNewsEvent(category: tCategory)),
      expect: () => [
        LoadingTopHeadlinesNewsState(),
        FailureTopHeadlinesNewsState(errorMessage: 'testErrorMessage'),
      ],
      verify: (_) async {
        verify(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory))).called(1);
      },
    );

    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [LoadingTopHeadlinesNewsState, FailureTopHeadlinesNewsState] when the internet connection has a problem',
      build: () {
        when(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory)))
            .thenAnswer((_) async => Left(ConnectionFailure()));
        return topHeadlinesNewsBloc;
      },
      act: (bloc) => bloc.add(LoadTopHeadlinesNewsEvent(category: tCategory)),
      expect: () => [
        LoadingTopHeadlinesNewsState(),
        FailureTopHeadlinesNewsState(errorMessage: messageConnectionFailure),
      ],
      verify: (_) async {
        verify(mockGetTopHeadlinesNews(ParamsGetTopHeadlinesNews(category: tCategory))).called(1);
      },
    );
  });

  group('ChangeCategoryTopHeadlinesNews', () {
    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [ChangedCategoryTopHeadlinesNewsState] when receive ChangeCategoryTopHeadlinesNewsEvent with a successful process',
      build: () => topHeadlinesNewsBloc,
      act: (bloc) => bloc.add(ChangeCategoryTopHeadlinesNewsEvent(indexCategorySelected: 1)),
      expect: () => [
        ChangedCategoryTopHeadlinesNewsState(indexCategorySelected: 1),
      ],
    );
  });

  group('SearchTopHeadlinesNews', () {
    const tKeyword = 'testKeyword';
    final tTopHeadlinesNewsResponseModel = TopHeadlinesNewsResponseModel.fromJson(
      json.decode(
        fixture('top_headlines_news_response_model.json'),
      ),
    );

    test(
      'make sure that the SearchTopHeadlinesNews use case is really called',
      () async {
        when(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword)))
            .thenAnswer((_) async => Right(tTopHeadlinesNewsResponseModel));

        topHeadlinesNewsBloc.add(SearchTopHeadlinesNewsEvent(keyword: tKeyword));
        await untilCalled(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword)));

        verify(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword)));
      },
    );

    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [LoadingTopHeadlinesNewsState, SearchSuccessTopHeadlinesNewsState] when receive SearchTopHeadlinesNewsEvent with a successful process',
      build: () {
        when(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword)))
            .thenAnswer((_) async => Right(tTopHeadlinesNewsResponseModel));
        return topHeadlinesNewsBloc;
      },
      act: (bloc) => bloc.add(SearchTopHeadlinesNewsEvent(keyword: tKeyword)),
      expect: () => [
        LoadingTopHeadlinesNewsState(),
        SearchSuccessTopHeadlinesNewsState(listArticles: tTopHeadlinesNewsResponseModel.articles!),
      ],
      verify: (_) async {
        verify(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword))).called(1);
      },
    );

    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [LoadingTopHeadlinesNewsState, FailureTopHeadlinesNewsState] when receive SearchTopHeadlinesNewsEvent with a failed process from endpoint',
      build: () {
        when(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword)))
            .thenAnswer((_) async => Left(ServerFailure('testErrorMessage')));
        return topHeadlinesNewsBloc;
      },
      act: (bloc) => bloc.add(SearchTopHeadlinesNewsEvent(keyword: tKeyword)),
      expect: () => [
        LoadingTopHeadlinesNewsState(),
        FailureTopHeadlinesNewsState(errorMessage: 'testErrorMessage'),
      ],
      verify: (_) async {
        verify(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword))).called(1);
      },
    );

    blocTest<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      'make sure to emit [LoadingTopHeadlinesNewsState, FailureTopHeadlinesNewsState] when the internet connection has a problem',
      build: () {
        when(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword)))
            .thenAnswer((_) async => Left(ConnectionFailure()));
        return topHeadlinesNewsBloc;
      },
      act: (bloc) => bloc.add(SearchTopHeadlinesNewsEvent(keyword: tKeyword)),
      expect: () => [
        LoadingTopHeadlinesNewsState(),
        FailureTopHeadlinesNewsState(errorMessage: messageConnectionFailure),
      ],
      verify: (_) async {
        verify(mockSearchTopHeadlinesNews(ParamsSearchTopHeadlinesNews(keyword: tKeyword))).called(1);
      },
    );
  });
}
