import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final int id;
  final String titleEnglish;
  final String titleGerman;
  final String contentEnglish;
  final String contentGerman;
  final String speechSourceEnglish;
  final String speechSourceGerman;
  final DateTime publishedAt;
  final String imageSource;
  final bool visible;
  final int viewCounter;

  const NewsEntity({
    required this.id,
    required this.titleEnglish,
    required this.titleGerman,
    required this.contentEnglish,
    required this.contentGerman,
    required this.speechSourceEnglish,
    required this.speechSourceGerman,
    required this.publishedAt,
    required this.imageSource,
    required this.visible,
    required this.viewCounter,
  });

  @override
  List<Object?> get props => [
        id,
        titleEnglish,
        titleGerman,
        contentEnglish,
        contentGerman,
        speechSourceEnglish,
        speechSourceGerman,
        publishedAt,
        imageSource,
        visible,
        viewCounter
      ];
}
