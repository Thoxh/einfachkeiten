import 'package:dartz/dartz.dart';
import 'package:einfachkeiten_frontend/src/core/error/failures.dart';
import 'package:einfachkeiten_frontend/src/core/usecases/usecase.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/repositories/news_repository.dart';
import 'package:equatable/equatable.dart';

class IncrementNewsCounter extends UseCase<void, Params> {
  final NewsRepository repository;

  IncrementNewsCounter(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.incrementNewsCounter(params.newsItemId);
  }
}

class Params extends Equatable {
  final int newsItemId;

  const Params({required this.newsItemId});

  @override
  List<Object?> get props => [newsItemId];
}
