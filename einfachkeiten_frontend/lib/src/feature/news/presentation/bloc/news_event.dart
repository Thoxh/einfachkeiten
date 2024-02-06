part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class GetNewsEvent extends NewsEvent {}

class IncrementNewsCounterEvent extends NewsEvent {
  final int newsItemId;

  const IncrementNewsCounterEvent({required this.newsItemId});

  @override
  List<Object> get props => [newsItemId];
}
