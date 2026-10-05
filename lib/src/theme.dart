import 'package:flutter/material.dart';

/// The VietGara brand color, shared with the web admin.
const brandColor = Color(0xFF1D4ED8);

ThemeData buildTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: brandColor,
    brightness: brightness,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  cardTheme: const CardThemeData(elevation: 0.5),
);
