import 'package:clean_code_architecture_tdd/feature/data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/item_news_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemNewsWidget', () {
    late ItemArticleTopHeadlinesNewsResponseModel mockArticle;

    setUp(() {
      mockArticle = ItemArticleTopHeadlinesNewsResponseModel(
        title: 'Test Title',
        author: 'Test Author',
        url: 'https://example.com',
        urlToImage: 'https://example.com/image.jpg',
        source: ItemSourceTopHeadlinesNewsResponseModel(name: 'Test Source'),
      );
    });

    testWidgets('renders correctly with all data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ItemNewsWidget(
            itemArticle: mockArticle,
            strPublishedAt: '2023-05-20',
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
      expect(find.text('2023-05-20 | Test Source'), findsOneWidget);
    });

    testWidgets('renders correctly with missing data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ItemNewsWidget(
            itemArticle: ItemArticleTopHeadlinesNewsResponseModel(),
          ),
        ),
      );

      expect(find.text('No Title'), findsOneWidget);
      expect(find.text('Unkown Date | Unkown Source'), findsOneWidget);
    });

    testWidgets('launches URL when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ItemNewsWidget(
            itemArticle: mockArticle,
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('shows error SnackBar when URL cannot be launched', (WidgetTester tester) async {
      ItemArticleTopHeadlinesNewsResponseModel tMockArticle = ItemArticleTopHeadlinesNewsResponseModel(
        title: 'Test Title',
        author: 'Test Author',
        url: null,
        urlToImage: 'https://example.com/image.jpg',
        source: ItemSourceTopHeadlinesNewsResponseModel(name: 'Test Source'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemNewsWidget(
              itemArticle: tMockArticle,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Couldn\'t open detail news'), findsOneWidget);
    });

  });
}
