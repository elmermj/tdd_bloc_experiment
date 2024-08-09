import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConstantConfig {
  final String keyNewsApi = dotenv.env['NEWS_API_KEY'] ?? '';
}