import 'package:einfachkeiten_frontend/src/feature/news/domain/usecases/increment_news_counter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:einfachkeiten_frontend/src/core/error/failures.dart';
import 'package:einfachkeiten_frontend/src/core/usecases/usecase.dart';
import 'package:einfachkeiten_frontend/src/core/values/values.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/usecases/get_news.dart';
import 'package:equatable/equatable.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;
  final IncrementNewsCounter incrementNewsCounter;

  NewsBloc({required this.getNews, required this.incrementNewsCounter})
      : super(NewsInital()) {
    on<GetNewsEvent>(_handleGetNewsEvent);
    on<IncrementNewsCounterEvent>(_handleIncrementCounterEvent);
  }

  Future<void> _handleGetNewsEvent(
      GetNewsEvent event, Emitter<NewsState> emit) async {
    emit(Loading());

    final failureOrNews = await getNews(NoParams());

    failureOrNews.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (news) => emit(Loaded(news: news)),
    );
  }

  Future<void> _handleIncrementCounterEvent(
      IncrementNewsCounterEvent event, Emitter<NewsState> emit) async {
    await incrementNewsCounter(Params(newsItemId: event.newsItemId));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppMessages.SERVER_FAILURE_MESSAGE;
      case TransformFailure:
        return AppMessages.TRANSFORM_FAILURE_MESSAGE;
      case NetworkFailure:
        return AppMessages.NETWORK_FAILURE_MESSAGE;
      default:
        return AppMessages.UNEXPECTED_ERROR_MESSAGE;
    }
  }
}
