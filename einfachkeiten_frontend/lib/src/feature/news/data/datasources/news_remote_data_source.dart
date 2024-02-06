import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:einfachkeiten_frontend/src/core/error/exceptions.dart';
import 'package:einfachkeiten_frontend/src/core/values/values.dart';
import 'package:einfachkeiten_frontend/src/feature/news/config/news_config.dart';
import 'package:einfachkeiten_frontend/src/feature/news/data/models/news_model.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';
import 'package:http/http.dart' as http;

abstract class NewsRemoteDataSource {
  Future<List<NewsEntity>> getNews();
  Future<void> incrementNewsCounter(int newsItemId);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NewsEntity>> getNews() async {
    final response = await client
        .get(NewsConfig.cmsUri, headers: NewsConfig.cmsHeader)
        .timeout(AppConfig.apiTimeout,
            onTimeout: () => throw ServerException());

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> news = jsonData['data'];
        return news
            .map((newsElement) => NewsModel.fromJson(newsElement))
            .toList();
      } catch (_) {
        throw TransformException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> incrementNewsCounter(int newsItemId) async {
    final response = await client
        .post(NewsConfig.cmsIncrementCounterFlowUri,
            headers: NewsConfig.cmsHeader,
            body: json.encode({'id': newsItemId}))
        .timeout(AppConfig.apiTimeout,
            onTimeout: () => throw ServerException());
    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException();
    }
  }
}
