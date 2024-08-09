// integration_test/search_page_test.dart
import 'package:clean_code_architecture_tdd/app.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/page/home/home_page.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/page/search/search_page.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/item_news_widget.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Search functionality test', (WidgetTester tester) async {

    await tester.pumpWidget(App());

    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.byType(SearchPage), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ItemNewsWidget), findsNothing);


    await tester.enterText(find.byType(TextField), 'technology');
    await tester.pump();


    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();


    expect(find.byType(ItemNewsWidget), findsWidgets);
  });
}
