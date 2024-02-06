part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

final class NewsInital extends NewsState {}

final class Loading extends NewsState {}

final class Loaded extends NewsState {
  final List<NewsEntity> news;

  const Loaded({required this.news});
}

final class Error extends NewsState {
  final String message;

  const Error({required this.message});
}

final class Success extends NewsState {}
