import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paz1dv/config/app/app_palette.dart';

class AppTypography {
  // Font families
  static const _bigShoulders = 'Big Shoulders Display';
  static const _dmSans = 'DM Sans';

  // Font sizes for portfolio website
  static const double _fontSize12 = 12;
  static const double _fontSize14 = 14;
  static const double _fontSize15 = 15; // Add this line
  static const double _fontSize16 = 16;
  static const double _fontSize18 = 18;
  static const double _fontSize20 = 20;
  static const double _fontSize24 = 24;
  static const double _fontSize28 = 28;
  static const double _fontSize32 = 32;
  static const double _fontSize40 = 40;
  static const double _fontSize48 = 48;
  static const double _fontSize64 = 64;
  static const double _fontSize80 = 80;

  // Line heights
  static const double _lineHeight16 = 16;
  static const double _lineHeight20 = 20;
  static const double _lineHeight22 = 22; // Add this line
  static const double _lineHeight24 = 24;
  static const double _lineHeight28 = 28;
  static const double _lineHeight32 = 32;
  static const double _lineHeight40 = 40;
  static const double _lineHeight48 = 48;
  static const double _lineHeight56 = 56;
  static const double _lineHeight72 = 72;
  static const double _lineHeight88 = 88;

  // Letter spacing
  static const double _letterSpacingTight = -0.5;
  static const double _letterSpacingNormal = 0.0;
  static const double _letterSpacingWide = 0.5;
  static const double _letterSpacingExtraWide = 1.0;

  static TextStyle _getStyle({
    required BuildContext context,
    required String fontFamily,
    required FontWeight weight,
    required double fontSize,
    required double height,
    required double letterSpacing,
    Color? color,
  }) {
    final defaultColor = AppPalette.adaptiveColor(
      context,
      light: AppPalette.darkMode,
      dark: AppPalette.lightMode,
    );

    return (fontFamily == _bigShoulders
        ? GoogleFonts.bigShouldersDisplay
        : GoogleFonts.dmSans)(
      color: color ?? defaultColor,
      fontWeight: weight,
      fontSize: fontSize,
      height: height / fontSize,
      letterSpacing: letterSpacing,
    );
  }

  // MAIN HEADINGS - Big Shoulders Display
  static TextStyle heading1(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _bigShoulders,
    weight: FontWeight.w700,
    fontSize: _fontSize64,
    height: _lineHeight72,
    letterSpacing: _letterSpacingTight,
    color: color,
  );

  static TextStyle heading2(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _bigShoulders,
    weight: FontWeight.w700,
    fontSize: _fontSize48,
    height: _lineHeight56,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  static TextStyle heading3(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _bigShoulders,
    weight: FontWeight.w600,
    fontSize: _fontSize40,
    height: _lineHeight48,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  static TextStyle heading4(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _bigShoulders,
    weight: FontWeight.w600,
    fontSize: _fontSize32,
    height: _lineHeight40,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  static TextStyle heading5(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _bigShoulders,
    weight: FontWeight.w600,
    fontSize: _fontSize28,
    height: _lineHeight32,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  static TextStyle heading6(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _bigShoulders,
    weight: FontWeight.w600,
    fontSize: _fontSize24,
    height: _lineHeight28,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  // SUBTITLES - Big Shoulders Display with lighter weight
  static TextStyle subtitleLarge(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _bigShoulders,
        weight: FontWeight.w500,
        fontSize: _fontSize24,
        height: _lineHeight28,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  static TextStyle subtitleMedium(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _bigShoulders,
        weight: FontWeight.w500,
        fontSize: _fontSize20,
        height: _lineHeight24,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  static TextStyle subtitleSmall(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _bigShoulders,
        weight: FontWeight.w400,
        fontSize: _fontSize18,
        height: _lineHeight24,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  // BODY TEXT - DM Sans for readability
  static TextStyle bodyLarge(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _dmSans,
    weight: FontWeight.w400,
    fontSize: _fontSize18,
    height: _lineHeight28,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  static TextStyle bodyMedium(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w400,
        fontSize: _fontSize16,
        height: _lineHeight24,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  static TextStyle bodySmall(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _dmSans,
    weight: FontWeight.w400,
    fontSize: _fontSize14,
    height: _lineHeight20,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  // BODY TEXT VARIATIONS - DM Sans with different weights
  static TextStyle bodyLargeBold(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w700,
        fontSize: _fontSize18,
        height: _lineHeight28,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  static TextStyle bodyMediumBold(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w700,
        fontSize: _fontSize16,
        height: _lineHeight24,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  static TextStyle bodySmallBold(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w700,
        fontSize: _fontSize14,
        height: _lineHeight20,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );

  // LABELS & UI ELEMENTS - DM Sans
  static TextStyle labelLarge(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w500,
        fontSize: _fontSize16,
        height: _lineHeight20,
        letterSpacing: _letterSpacingWide,
        color: color,
      );

  static TextStyle labelMedium(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w500,
        fontSize: _fontSize14,
        height: _lineHeight16,
        letterSpacing: _letterSpacingWide,
        color: color,
      );

  static TextStyle labelSmall(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w500,
        fontSize: _fontSize12,
        height: _lineHeight16,
        letterSpacing: _letterSpacingWide,
        color: color,
      );

  // BUTTON TEXT - DM Sans
  static TextStyle buttonLarge(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w600,
        fontSize: _fontSize16,
        height: _lineHeight20,
        letterSpacing: _letterSpacingWide,
        color: color,
      );

  static TextStyle buttonMedium(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w600,
        fontSize: _fontSize14,
        height: _lineHeight16,
        letterSpacing: _letterSpacingWide,
        color: color,
      );

  static TextStyle buttonSmall(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w600,
        fontSize: _fontSize12,
        height: _lineHeight16,
        letterSpacing: _letterSpacingWide,
        color: color,
      );

  // CAPTION & OVERLINE - DM Sans
  static TextStyle caption(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _dmSans,
    weight: FontWeight.w400,
    fontSize: _fontSize12,
    height: _lineHeight16,
    letterSpacing: _letterSpacingNormal,
    color: color,
  );

  static TextStyle overline(BuildContext context, {Color? color}) => _getStyle(
    context: context,
    fontFamily: _dmSans,
    weight: FontWeight.w500,
    fontSize: _fontSize12,
    height: _lineHeight16,
    letterSpacing: _letterSpacingExtraWide,
    color: color,
  );

  // BULLET POINTS - DM Sans with special styling for key points
  static TextStyle bulletPoint(BuildContext context, {Color? color}) =>
      _getStyle(
        context: context,
        fontFamily: _dmSans,
        weight: FontWeight.w500,
        fontSize: _fontSize15,
        height: _lineHeight22,
        letterSpacing: _letterSpacingNormal,
        color: color,
      );
}
