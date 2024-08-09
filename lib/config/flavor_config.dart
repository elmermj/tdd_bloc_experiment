import 'package:flutter/material.dart';

enum Flavor {
  DEVELOPMENT,
  PRODUCTION,
}

class FlavorValues {
  final String baseUrl;

  FlavorValues({required this.baseUrl});
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final Color colorPrimary;
  final Color colorPrimaryDark;
  final Color colorPrimaryLight;
  final Color colorAccent;
  final FlavorValues values;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    Color colorPrimary = Colors.blue,
    Color colorPrimaryDark = Colors.blue,
    Color colorPrimaryLight = Colors.blue,
    Color colorAccent = Colors.blueAccent,
    required FlavorValues values,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      _enumName(flavor),
      colorPrimary,
      colorPrimaryDark,
      colorPrimaryLight,
      colorAccent,
      values,
    );
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.name,
    this.colorPrimary,
    this.colorPrimaryDark,
    this.colorPrimaryLight,
    this.colorAccent,
    this.values,
  );

  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError('FlavorConfig has not been initialized.');
    }
    return _instance!;
  }

  static String _enumName(Flavor flavor) {
    return flavor.toString().split('.').last;
  }

  static bool isProduction() => _instance?.flavor == Flavor.PRODUCTION;

  static bool isDevelopment() => _instance?.flavor == Flavor.DEVELOPMENT;
}
