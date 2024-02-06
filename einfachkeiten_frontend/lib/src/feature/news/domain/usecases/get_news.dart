import 'package:dartz/dartz.dart';
import 'package:einfachkeiten_frontend/src/core/error/failures.dart';
import 'package:einfachkeiten_frontend/src/core/usecases/usecase.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/repositories/news_repository.dart';

class GetNews extends UseCase<List<NewsEntity>, NoParams> {
  final NewsRepository repository;

  GetNews(this.repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(NoParams params) async {
    return await repository.getNews();
  }
}
