import 'package:dartz/dartz.dart';
import 'package:einfachkeiten_frontend/src/core/error/exceptions.dart';
import 'package:einfachkeiten_frontend/src/core/error/failures.dart';
import 'package:einfachkeiten_frontend/src/core/platform/network_info.dart';
import 'package:einfachkeiten_frontend/src/feature/news/data/datasources/news_remote_data_source.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNews = await remoteDataSource.getNews();
        return Right(remoteNews);
      } on ServerException {
        return Left(ServerFailure());
      } on TransformException {
        return Left(TransformFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> incrementNewsCounter(int newsItemId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.incrementNewsCounter(newsItemId);
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
