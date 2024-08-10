import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConstantConfig {
  // final String keyNewsApi = dotenv.env['NEWS_API_KEY'] ?? ''; //uncomment this line when you want to debug locally
  final String keyNewsApi = Platform.environment['NEWS_API_KEY'] ?? ''; //uncomment this line when you want to use with CI/CD
}