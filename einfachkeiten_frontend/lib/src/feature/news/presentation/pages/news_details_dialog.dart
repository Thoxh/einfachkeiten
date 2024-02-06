// Flutter imports
import 'package:flutter/material.dart';
import 'dart:math' as math;

// Package imports
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Project-specific imports
import 'package:einfachkeiten_frontend/src/core/values/values.dart';
import 'package:einfachkeiten_frontend/src/feature/news/config/news_config.dart';
import 'package:einfachkeiten_frontend/src/feature/news/domain/entities/news_entity.dart';
import 'package:flutter_localization/flutter_localization.dart';

/// A dialog widget to display details of a news article.
class NewsDetailsDialog extends StatelessWidget {
  final NewsEntity news;

  const NewsDetailsDialog({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FlutterLocalization localization = FlutterLocalization.instance;
    final AudioPlayer player = AudioPlayer();

    // Get the screen width.
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      child: SingleChildScrollView(
        child: SizedBox(
          width: math.max(screenWidth / 3, 400.0),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.PADDING_24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, theme, localization, player),
                const SizedBox(height: AppSizes.HEIGHT_8),
                _buildTitle(theme, localization),
                const SizedBox(height: AppSizes.HEIGHT_8),
                _buildContent(theme, localization),
                const SizedBox(height: AppSizes.HEIGHT_18),
                _buildImage(news.imageSource),
                const SizedBox(height: AppSizes.HEIGHT_8),
                _buildFooter(theme, localization),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the header section including the time, play, stop buttons, and close icon.
  Widget _buildHeader(BuildContext context, ThemeData theme,
      FlutterLocalization localization, AudioPlayer player) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTimeAndAudioControls(theme, localization, player),
        _buildCloseButton(context, player),
      ],
    );
  }

  /// Builds the time display and audio control buttons.
  Widget _buildTimeAndAudioControls(
      ThemeData theme, FlutterLocalization localization, AudioPlayer player) {
    return Row(
      children: [
        _buildTimeDisplay(theme, localization),
        const SizedBox(width: AppSizes.WIDTH_8),
        _buildPlayButton(player, localization),
        _buildStopButton(player),
      ],
    );
  }

  /// Displays the time of the news publication.
  Widget _buildTimeDisplay(ThemeData theme, FlutterLocalization localization) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.RADIUS_6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.PADDING_18, vertical: AppSizes.PADDING_5),
        child: Text(
          '${DateFormat('HH:mm').format(news.publishedAt)}${localization.currentLocale.localeIdentifier == "de_DE" ? " Uhr" : ""}',
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  /// Builds play button to start playing the news audio.
  Widget _buildPlayButton(
      AudioPlayer player, FlutterLocalization localization) {
    return IconButton(
      iconSize: AppSizes.ICON_SIZE_22,
      onPressed: () async {
        await player.play(UrlSource(
            '${NewsConfig.cmsFilesUri}/${localization.currentLocale.localeIdentifier == "de_DE" ? news.speechSourceGerman : news.speechSourceEnglish}?download'));
      },
      icon: const FaIcon(FontAwesomeIcons.solidCirclePlay),
    );
  }

  /// Builds stop button to stop the news audio.
  Widget _buildStopButton(AudioPlayer player) {
    return IconButton(
      iconSize: AppSizes.ICON_SIZE_22,
      onPressed: () async {
        await player.stop();
      },
      icon: const FaIcon(FontAwesomeIcons.solidCircleStop),
    );
  }

  /// Builds a button to close the dialog.
  Widget _buildCloseButton(BuildContext context, AudioPlayer player) {
    return IconButton(
      iconSize: AppSizes.ICON_SIZE_22,
      onPressed: () async {
        await player.stop();
        Navigator.of(context).pop();
      },
      icon: const FaIcon(FontAwesomeIcons.solidCircleXmark),
    );
  }

  /// Builds the title section of the news.
  Widget _buildTitle(ThemeData theme, FlutterLocalization localization) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        localization.currentLocale.localeIdentifier == 'de_DE'
            ? news.titleGerman
            : news.titleEnglish,
        style: theme.textTheme.headlineMedium,
      ),
    );
  }

  /// Builds the content section of the news.
  Widget _buildContent(ThemeData theme, FlutterLocalization localization) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        localization.currentLocale.localeIdentifier == 'de_DE'
            ? news.contentGerman
            : news.contentEnglish,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }

  /// Builds the image section of the news.
  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(imageUrl),
    );
  }

  /// Builds the footer section including the publication date and view counter.
  Widget _buildFooter(ThemeData theme, FlutterLocalization localization) {
    return Row(
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
            Text(news.viewCounter.toString(), style: theme.textTheme.bodySmall),
            const SizedBox(width: AppSizes.PADDING_6),
            const FaIcon(
              color: AppColors.secondaryColor,
              FontAwesomeIcons.solidEye,
              size: AppSizes.ICON_SIZE_12,
            ),
          ],
        ),
      ],
    );
  }
}
