import 'package:equatable/equatable.dart';
import '../../../data/model/topheadlinesnews/top_headlines_news_response_model.dart';

abstract class TopHeadlinesNewsState extends Equatable {
  const TopHeadlinesNewsState();

  @override
  List<Object> get props => [];
}

class InitialTopHeadlinesNewsState extends TopHeadlinesNewsState {}

class LoadingTopHeadlinesNewsState extends TopHeadlinesNewsState {}

class LoadedTopHeadlinesNewsState extends TopHeadlinesNewsState {
  final List<ItemArticleTopHeadlinesNewsResponseModel> listArticles;

  LoadedTopHeadlinesNewsState({required this.listArticles});

  @override
  List<Object> get props => [listArticles];

  @override
  String toString() {
    return 'LoadedTopHeadlinesNewsState{listArticles: $listArticles}';
  }
}

class FailureTopHeadlinesNewsState extends TopHeadlinesNewsState {
  final String errorMessage;

  FailureTopHeadlinesNewsState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'FailureTopHeadlinesNewsState{errorMessage: $errorMessage}';
  }
}

class ChangedCategoryTopHeadlinesNewsState extends TopHeadlinesNewsState {
  final int indexCategorySelected;

  ChangedCategoryTopHeadlinesNewsState({required this.indexCategorySelected});

  @override
  List<Object> get props => [indexCategorySelected];

  @override
  String toString() {
    return 'ChangedCategoryTopHeadlinesNewsState{indexCategorySelected: $indexCategorySelected}';
  }
}

class SearchSuccessTopHeadlinesNewsState extends TopHeadlinesNewsState {
  final List<ItemArticleTopHeadlinesNewsResponseModel> listArticles;

  SearchSuccessTopHeadlinesNewsState({required this.listArticles});

  @override
  List<Object> get props => [listArticles];

  @override
  String toString() {
    return 'SearchSuccessTopHeadlinesNewsState{listArticles: $listArticles}';
  }
}