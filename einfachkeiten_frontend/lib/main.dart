import 'package:einfachkeiten_frontend/localization.dart';
import 'package:einfachkeiten_frontend/src/core/routes/router.dart';
import 'package:einfachkeiten_frontend/src/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'injection_container.dart' as di;

void main() async {
  initializeDateFormatting('de_DE', null);
  await di.init();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _appRouter = AppRouter();

  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization.init(
      mapLocales: [
        const MapLocale(
          'en',
          AppLocale.EN,
          countryCode: 'US',
        ),
        const MapLocale(
          'de',
          AppLocale.DE,
          countryCode: 'DE',
        ),
      ],
      initLanguageCode: 'de',
    );
    _localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThemeData,
        supportedLocales: _localization.supportedLocales,
        localizationsDelegates: _localization.localizationsDelegates,
        routerDelegate: _appRouter.routerDelegate,
        routeInformationParser: _appRouter.routeInformationParser,
        routeInformationProvider: _appRouter.routeInformationProvider,
      );
}
