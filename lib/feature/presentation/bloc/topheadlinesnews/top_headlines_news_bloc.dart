import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../core/error/failure.dart';
import '../../../domain/usecase/gettopheadlinesnews/get_top_headlines_news.dart';
import '../../../domain/usecase/searchtopheadlinesnews/search_top_headlines_news.dart';

import 'bloc.dart';

class TopHeadlinesNewsBloc extends Bloc<TopHeadlinesNewsEvent, TopHeadlinesNewsState> {
  final GetTopHeadlinesNews? getTopHeadlinesNews;
  final SearchTopHeadlinesNews? searchTopHeadlinesNews;

  TopHeadlinesNewsBloc({
    required this.getTopHeadlinesNews,
    required this.searchTopHeadlinesNews,
  })  : assert(getTopHeadlinesNews != null),
        assert(searchTopHeadlinesNews != null),
        super(InitialTopHeadlinesNewsState()) {
    on<LoadTopHeadlinesNewsEvent>(_onLoadTopHeadlinesNewsEvent);
    on<ChangeCategoryTopHeadlinesNewsEvent>(_onChangeCategoryTopHeadlinesNewsEvent);
    on<SearchTopHeadlinesNewsEvent>(_onSearchTopHeadlinesNewsEvent);
  }


  Future<void> _onLoadTopHeadlinesNewsEvent(
    LoadTopHeadlinesNewsEvent event,
    Emitter<TopHeadlinesNewsState> emit,
  ) async {
    emit(LoadingTopHeadlinesNewsState());
    final response = await getTopHeadlinesNews!(ParamsGetTopHeadlinesNews(category: event.category));
    emit(response.fold(
      (failure) {
        if (failure is ServerFailure) {
          return FailureTopHeadlinesNewsState(errorMessage: failure.errorMessage);
        }
        if (failure is ConnectionFailure) {
          return FailureTopHeadlinesNewsState(errorMessage: failure.errorMessage);
        }
        throw Exception(failure);
      },
      (data) => LoadedTopHeadlinesNewsState(listArticles: data.articles!),
    ));
  }

  Future<void> _onChangeCategoryTopHeadlinesNewsEvent(
    ChangeCategoryTopHeadlinesNewsEvent event,
    Emitter<TopHeadlinesNewsState> emit,
  ) async {
    emit(ChangedCategoryTopHeadlinesNewsState(indexCategorySelected: event.indexCategorySelected));
  }

  Future<void> _onSearchTopHeadlinesNewsEvent(
    SearchTopHeadlinesNewsEvent event,
    Emitter<TopHeadlinesNewsState> emit,
  ) async {
    emit(LoadingTopHeadlinesNewsState());
    final result = await searchTopHeadlinesNews!(ParamsSearchTopHeadlinesNews(keyword: event.keyword));
    emit(result.fold(
      (failure) {
        if (failure is ServerFailure) {
          return FailureTopHeadlinesNewsState(errorMessage: failure.errorMessage);
        }
        if (failure is ConnectionFailure) {
          return FailureTopHeadlinesNewsState(errorMessage: failure.errorMessage);
        }
        throw Exception(failure);
      },
      (response) => SearchSuccessTopHeadlinesNewsState(listArticles: response.articles!),
    ));
  }
}
