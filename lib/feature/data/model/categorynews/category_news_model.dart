import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_news_model.g.dart';

@JsonSerializable()
class CategoryNewsModel extends Equatable {
  final String? image;
  final String? title;

  CategoryNewsModel({
    this.image,
    this.title,
  });

  factory CategoryNewsModel.fromJson(Map<String, dynamic> json) => _$CategoryNewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryNewsModelToJson(this);

  @override
  List<Object> get props => [image!, title!];

  @override
  String toString() {
    return 'CategoryNewsModel{image: $image, title: $title}';
  }
}
