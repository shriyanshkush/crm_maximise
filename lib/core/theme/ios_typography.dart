import 'package:flutter/material.dart';

/// iOS-style typography using San Francisco font (system default on iOS)
class IOSTypography {
  // San Francisco font family - Flutter automatically uses it on iOS
  // For Web/Android, we'll use system default which provides good fallback
  static const String fontFamily = '.SF Pro Text'; // Works on iOS, falls back gracefully on other platforms

  // iOS 18+ Display Styles
  static TextStyle largeTitle({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w700,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 34,
      fontWeight: weight,
      letterSpacing: 0.37,
      height: 1.2,
      color: color,
    );
  }

  static TextStyle title1({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 28,
      fontWeight: weight,
      letterSpacing: 0.36,
      height: 1.2,
      color: color,
    );
  }

  static TextStyle title2({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      fontWeight: weight,
      letterSpacing: 0.35,
      height: 1.3,
      color: color,
    );
  }

  static TextStyle title3({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: weight,
      letterSpacing: 0.38,
      height: 1.3,
      color: color,
    );
  }

  static TextStyle headline({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      fontWeight: weight,
      letterSpacing: -0.41,
      height: 1.35,
      color: color,
    );
  }

  static TextStyle body({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      fontWeight: weight,
      letterSpacing: -0.41,
      height: 1.35,
      color: color,
    );
  }

  static TextStyle callout({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: weight,
      letterSpacing: -0.32,
      height: 1.3,
      color: color,
    );
  }

  static TextStyle subheadline({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: weight,
      letterSpacing: -0.24,
      height: 1.35,
      color: color,
    );
  }

  static TextStyle footnote({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: weight,
      letterSpacing: -0.08,
      height: 1.35,
      color: color,
    );
  }

  static TextStyle caption1({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: weight,
      letterSpacing: 0,
      height: 1.3,
      color: color,
    );
  }

  static TextStyle caption2({
    Color color = Colors.black,
    FontWeight weight = FontWeight.w400,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: 11,
      fontWeight: weight,
      letterSpacing: 0.07,
      height: 1.3,
      color: color,
    );
  }
}
