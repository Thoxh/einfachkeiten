import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.titleEnglish,
    required super.titleGerman,
    required super.contentEnglish,
    required super.contentGerman,
    required super.speechSourceEnglish,
    required super.speechSourceGerman,
    required super.publishedAt,
    required super.imageSource,
    required super.visible,
    required super.viewCounter,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      titleEnglish: json['titleEnglish'],
      titleGerman: json['titleGerman'],
      contentEnglish: json['contentEnglish'],
      contentGerman: json['contentGerman'],
      speechSourceEnglish: json['speechSourceEnglish'],
      speechSourceGerman: json['speechSourceGerman'],
      publishedAt: DateTime.parse(json['publishedAt']),
      imageSource: json['imageSource'],
      visible: json['visible'],
      viewCounter: json['viewCounter'],
    );
  }
}
