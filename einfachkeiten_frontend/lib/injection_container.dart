import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:einfachkeiten_frontend/src/core/platform/network_info.dart';
import 'package:einfachkeiten_frontend/src/feature/news/data/datasources/news_remote_data_source.dart';
import 'package:einfachkeiten_frontend/src/feature/news/data/repositories/news_repository_impl.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/repositories/news_repository.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/usecases/increment_news_counter.dart';
import 'package:einfachkeiten_frontend/src/feature/news/presentation/bloc/news_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'src/feature/news/domain/usecases/get_news.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => NewsBloc(getNews: sl(), incrementNewsCounter: sl()));
  sl.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton(() => GetNews(sl()));
  sl.registerLazySingleton(() => IncrementNewsCounter(sl()));
  sl.registerLazySingleton<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
