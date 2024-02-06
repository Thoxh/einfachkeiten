import 'package:einfachkeiten_frontend/injection_container.dart';
import 'package:einfachkeiten_frontend/src/feature/news/presentation/bloc/news_bloc.dart';
import 'package:einfachkeiten_frontend/src/feature/news/presentation/pages/news_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final GoRouter _router = GoRouter(
    initialLocation: '/news',
    errorBuilder: (context, state) => Text(
        "Diese Seite konnte nicht gefunden werden: ${state.error.toString()}"),
    routes: <GoRoute>[
      GoRoute(
        path: '/news',
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<NewsBloc>(
                create: (context) => sl<NewsBloc>()..add(GetNewsEvent()),
                child: const NewsPage()),
      ),
    ],
  );

  GoRouter get router => _router;
  RouterDelegate<Object>? get routerDelegate => _router.routerDelegate;
  RouteInformationParser<Object>? get routeInformationParser =>
      _router.routeInformationParser;
  RouteInformationProvider get routeInformationProvider =>
      _router.routeInformationProvider;
}
