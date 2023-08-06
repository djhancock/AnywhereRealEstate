import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpsons_demo/flavor.dart';

ThemeData appTheme(BuildContext context) {
  final flavor = Provider.of<Flavor>(context);

  switch (flavor) {
    case Flavor.simpsons:
      return _getSimpsonsTheme(context);
    case Flavor.theWire:
      return _getTheWireTheme(context);
  }
}

ThemeData _getSimpsonsTheme(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3700b3)),
    toggleButtonsTheme: ToggleButtonsThemeData(
      selectedColor: Colors.blue,
      color: Colors.blue.withAlpha(128),
      textStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

ThemeData _getTheWireTheme(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF027A1C)),
    toggleButtonsTheme: ToggleButtonsThemeData(
      selectedColor: Colors.blue,
      color: Colors.blue.withAlpha(128),
      textStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
