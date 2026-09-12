import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'League Spartan';

  static const TextStyle paragraph = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1,
    letterSpacing: 0,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 26 / 24,
    letterSpacing: 0,
  );

  static const TextStyle subtitulo = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1,
    letterSpacing: 0,
  );

  static const TextStyle tituloScreen = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: 0,
  );

  static const TextStyle textField = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 14 / 20,
    letterSpacing: 0,
  );
  
  static const TextStyle hint = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.w300,
  height: 1,
  letterSpacing: 0,
);
static const TextStyle button = TextStyle(
  fontFamily: fontFamily,
  fontSize: 24,
  fontWeight: FontWeight.w500,
  height: 1,
  letterSpacing: 0,
);
}
