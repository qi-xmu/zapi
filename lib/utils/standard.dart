import 'package:flutter/material.dart';

const double verMargin = 5;
const double horMargin = 15;
const double verPadding = 5;
const double horPadding = 10;

const double minHeight = 60;

const double topPadding = 10;
const double bottomPadding = 100;

const double radius = 10;

const Color lightColor = Colors.black54;
const Color dartColor = Colors.white70;

/* 生成色彩 */
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
