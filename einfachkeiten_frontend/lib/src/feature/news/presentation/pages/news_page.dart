// Dart and Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

// Package imports
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project-specific imports
import 'package:einfachkeiten_frontend/localization.dart';
import 'package:einfachkeiten_frontend/src/core/components/einfachkeiten_icons.dart';
import 'package:einfachkeiten_frontend/src/core/components/state_loading_widget.dart';
import 'package:einfachkeiten_frontend/src/core/components/state_message_widget.dart';
import 'package:einfachkeiten_frontend/src/core/theme/theme.dart';
import 'package:einfachkeiten_frontend/src/core/values/values.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';
import 'package:einfachkeiten_frontend/src/feature/news/presentation/bloc/news_bloc.dart';
import 'package:einfachkeiten_frontend/src/feature/news/presentation/pages/news_details_dialog.dart';

/// Represents the news page within the app.
class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsBloc = BlocProvider.of<NewsBloc>(context);
    return Scaffold(body: _buildBody(newsBloc, context));
  }

  /// Builds the main body of the news page.
  SafeArea _buildBody(NewsBloc newsBloc, BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => newsBloc.add(GetNewsEvent()),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                    flex: 12, child: _buildNewsList(state, newsBloc, context)),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Builds the header of the news page.
  Widget _buildHeader(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final FlutterLocalization localization = FlutterLocalization.instance;
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.PADDING_8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.solidNewspaper),
            const SizedBox(width: AppSizes.WIDTH_12),
            Text(
              "Einfachkeiten",
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(width: AppSizes.WIDTH_40),
            Tooltip(
              message: AppLocale.changeLanguage.getString(context),
              child: IconButton(
                  onPressed: () {
                    if (localization.currentLocale.localeIdentifier ==
                        'en_US') {
                      localization.translate('de');
                    } else {
                      localization.translate('en');
                    }
                  },
                  icon: const FaIcon(FontAwesomeIcons.language)),
            )
          ],
        ),
      ),
    );
  }

  /// Builds the list of news articles.
  Widget _buildNewsList(
      NewsState state, NewsBloc newsBloc, BuildContext context) {
    DeviceType deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.bigDesktop:
        return _getStateWidget(state, newsBloc, true, 4);
      case DeviceType.desktop:
        return _getStateWidget(state, newsBloc, true, 3);
      case DeviceType.tablet:
        return _getStateWidget(state, newsBloc, true, 2);
      case DeviceType.mobile:
        return ListView(
          children: [_getStateWidget(state, newsBloc, false, 0)],
        );
    }
  }

  /// Returns the appropriate widget based on the current state.
  /// Returns the appropriate widget based on the current state, and whether to use a GridView.
  Widget _getStateWidget(
      NewsState state, NewsBloc newsBloc, bool gridView, int crossAxisCount) {
    if (state is Loaded) {
      if (gridView) {
        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSizes.PADDING_8,
              mainAxisSpacing: AppSizes.PADDING_8,
              childAspectRatio: 0.8),
          children: state.news
              .map((news) => NewsWidget(news: news))
              .toList()
              .reversed
              .toList(),
        );
      } else {
        return Column(
          children: state.news
              .map((news) => NewsWidget(news: news))
              .toList()
              .reversed
              .toList(),
        );
      }
    } else {
      switch (state.runtimeType) {
        case NewsInital:
          return const StateMessageWidget(
              message: AppMessages.UNEXPECTED_ERROR_MESSAGE);
        case Loading:
          return const StateLoadingWidget();
        case Error:
          return StateMessageWidget(message: (state as Error).message);
        default:
          return const StateMessageWidget(
              message: AppMessages.UNEXPECTED_ERROR_MESSAGE);
      }
    }
  }
}

/// Represents a widget that displays a news article.
class NewsWidget extends StatelessWidget {
  final NewsEntity news;

  const NewsWidget({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final FlutterLocalization localization = FlutterLocalization.instance;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.PADDING_16),
      child: InkWell(
        onTap: () => _onNewsTap(context),
        child: Card(
          child: _buildCardContent(theme, localization, context),
        ),
      ),
    );
  }

  /// Handles tap on a news item, showing its details.
  void _onNewsTap(BuildContext context) {
    BlocProvider.of<NewsBloc>(context)
        .add(IncrementNewsCounterEvent(newsItemId: news.id));
    showDialog(
      context: context,
      builder: (context) => NewsDetailsDialog(news: news),
    );
  }

  /// Builds the content of the news card.
  Widget _buildCardContent(
      ThemeData theme, FlutterLocalization localization, BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.PADDING_12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNewsHeader(theme, localization),
            _buildNewsBody(theme, localization, context),
            _buildNewsFooter(theme, localization),
          ],
        ),
      ),
    );
  }

  /// Builds the header of the news card, including the publish time and an action icon.
  Widget _buildNewsHeader(ThemeData theme, FlutterLocalization localization) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppSizes.RADIUS_6))),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.PADDING_18, vertical: AppSizes.PADDING_5),
            child: Text(
              '${DateFormat('HH:mm').format(news.publishedAt)}${localization.currentLocale.localeIdentifier == "de_DE" ? " Uhr" : ""}',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ),
        ),
        IconButton(
          iconSize: AppSizes.ICON_SIZE_20,
          onPressed: () {},
          icon: const FaIcon(FontAwesomeIcons.circleArrowRight),
        ),
      ],
    );
  }

  /// Builds the body of the news card, including the title, content, and a read more prompt.
  Widget _buildNewsBody(
      ThemeData theme, FlutterLocalization localization, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.currentLocale.localeIdentifier == 'de_DE'
              ? news.titleGerman
              : news.titleEnglish,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.HEIGHT_8),
        Text(
          localization.currentLocale.localeIdentifier == 'de_DE'
              ? news.contentGerman
              : news.contentEnglish,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          style: theme.textTheme.bodyMedium,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocale.readMore.getString(context),
            style:
                theme.textTheme.bodyMedium?.copyWith(fontWeight: AppTheme.bold),
          ),
        ),
        const SizedBox(height: AppSizes.HEIGHT_8),
      ],
    );
  }

  /// Builds the footer of the news card, including an image, publish date, and view counter.
  Widget _buildNewsFooter(ThemeData theme, FlutterLocalization localization) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                news.imageSource,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.HEIGHT_8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE, dd.MM.yyyy',
                      localization.currentLocale.localeIdentifier)
                  .format(news.publishedAt),
              style: theme.textTheme.bodySmall,
            ),
            Row(
              children: [
                Text(news.viewCounter.toString(),
                    style: theme.textTheme.bodySmall),
                const SizedBox(width: AppSizes.PADDING_6),
                const FaIcon(
                  color: AppColors.secondaryColor,
                  FontAwesomeIcons.solidEye,
                  size: AppSizes.ICON_SIZE_12,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

enum DeviceType {
  bigDesktop,
  desktop,
  tablet,
  mobile,
}

DeviceType getDeviceType(BuildContext context) {
  // Get the screen width.
  double screenWidth = MediaQuery.of(context).size.width;

  // Define breakpoints for desktop and tablet sizes.
  const double bigDesktopBreakpoint = 1500;
  const double desktopBreakpoint = 1150;
  const double tabletBreakpoint = 768.0;

  if (screenWidth >= bigDesktopBreakpoint) {
    return DeviceType.bigDesktop;
  } else if (screenWidth >= desktopBreakpoint) {
    return DeviceType.desktop;
  } else if (screenWidth >= tabletBreakpoint) {
    return DeviceType.tablet;
  } else {
    return DeviceType.mobile;
  }
}
