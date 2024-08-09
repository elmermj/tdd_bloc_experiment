import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'top_headlines_news_response_model.g.dart';

@JsonSerializable()
class TopHeadlinesNewsResponseModel extends Equatable {
  final String? status;
  final int? totalResults;
  final List<ItemArticleTopHeadlinesNewsResponseModel>? articles;

  TopHeadlinesNewsResponseModel({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory TopHeadlinesNewsResponseModel.fromJson(Map<String, dynamic> json) => _$TopHeadlinesNewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopHeadlinesNewsResponseModelToJson(this);

  @override
  List<Object> get props => [status!, totalResults!, articles!];

  @override
  String toString() {
    return 'TopHeadlinesNewsResponseModel{status: $status, totalResults: $totalResults, articles: $articles}';
  }
}

@JsonSerializable()
class ItemArticleTopHeadlinesNewsResponseModel extends Equatable {
  final ItemSourceTopHeadlinesNewsResponseModel? source;
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  ItemArticleTopHeadlinesNewsResponseModel({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory ItemArticleTopHeadlinesNewsResponseModel.fromJson(Map<String, dynamic> json) => _$ItemArticleTopHeadlinesNewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemArticleTopHeadlinesNewsResponseModelToJson(this);

  @override
  List<Object> get props => [source!, author!, title!, description!, url!, urlToImage!, publishedAt!, content!];

  @override
  String toString() {
    return 'ItemArticleTopHeadlinesNewsResponseModel{source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content}';
  }
}

@JsonSerializable()
class ItemSourceTopHeadlinesNewsResponseModel extends Equatable {
  final String name;

  ItemSourceTopHeadlinesNewsResponseModel({required this.name});

  factory ItemSourceTopHeadlinesNewsResponseModel.fromJson(Map<String, dynamic> json) => _$ItemSourceTopHeadlinesNewsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemSourceTopHeadlinesNewsResponseModelToJson(this);

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'ItemSourceTopHeadlinesNewsResponseModel{name: $name}';
  }
}
