import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context) => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor: Colors.blue,
        color: Colors.blue.withAlpha(128),
        textStyle: const TextStyle(
          color: Colors.white,
        )));
