import 'package:dartz/dartz.dart';
import 'package:einfachkeiten_frontend/src/core/error/failures.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews();
  Future<Either<Failure, Unit>> incrementNewsCounter(int newsItemId);
}
