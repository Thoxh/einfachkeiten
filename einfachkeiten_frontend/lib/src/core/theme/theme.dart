import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../values/values.dart';

class AppTheme {
  static ThemeData lightThemeData =
      themeData(_lightColorScheme, _appBarTheme, _cardTheme);

  static ThemeData themeData(
      ColorScheme colorScheme, AppBarTheme appBarTheme, CardTheme cardTheme) {
    return ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        colorScheme: colorScheme,
        textTheme: _textTheme,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        canvasColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
        focusColor: AppColors.primaryColor,
        appBarTheme: appBarTheme,
        cardTheme: cardTheme);
  }

  static final AppBarTheme _appBarTheme = AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      elevation: AppSizes.ELEVATION_0,
      titleTextStyle: _textTheme.headlineMedium,
      iconTheme: const IconThemeData(color: AppColors.primaryColor));

  static final CardTheme _cardTheme = CardTheme(
      elevation: AppSizes.ELEVATION_0,
      color: AppColors.surfaceColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.RADIUS_8)));

  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: AppColors.surfaceColor,
    background: AppColors.backgroundColor,
    error: AppColors.errorColor,
    onPrimary: AppColors.onPrimaryColor,
    onSecondary: AppColors.secondaryColor,
    onSurface: AppColors.surfaceColor,
    onBackground: AppColors.backgroundColor,
    onError: AppColors.errorColor,
    brightness: Brightness.light,
  );

  static const _bold = FontWeight.w700;
  static get bold => _bold;
  static const _semiBold = FontWeight.w600;
  static get semiBold => _semiBold;
  static const _medium = FontWeight.w500;
  static const _regular = FontWeight.w400;

  static final TextTheme _textTheme = TextTheme(
    headlineLarge: GoogleFonts.inter(
      fontSize: AppSizes.TEXT_SIZE_24,
      color: AppColors.primaryColor,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppSizes.TEXT_SIZE_18,
      color: AppColors.primaryColor,
      fontWeight: _bold,
      fontStyle: FontStyle.normal,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppSizes.TEXT_SIZE_10,
      color: AppColors.onPrimaryColor,
      fontWeight: _semiBold,
      fontStyle: FontStyle.normal,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppSizes.TEXT_SIZE_12,
      color: AppColors.primaryColor,
      fontWeight: _regular,
      fontStyle: FontStyle.normal,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppSizes.TEXT_SIZE_10,
      color: AppColors.secondaryColor,
      fontWeight: _regular,
      fontStyle: FontStyle.italic,
    ),
  );
}
