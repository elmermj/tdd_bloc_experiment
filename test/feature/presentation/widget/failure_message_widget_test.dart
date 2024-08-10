import 'package:clean_code_architecture_tdd/feature/presentation/widget/failure_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  // Initialize ScreenUtil for testing purposes
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('FailureMessageWidget displays the correct elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FailureMessageWidget(
            errorTitle: 'Test Error Title',
            errorSubtitle: 'Test error subtitle.',
          ),
        ),
      ),
    );
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('Test Error Title'), findsOneWidget);
    expect(find.text('Test error subtitle.'), findsOneWidget);
  });

  testWidgets('FailureMessageWidget displays default values', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FailureMessageWidget(),
        ),
      ),
    );

    expect(find.text('You seem to be offline'), findsOneWidget);
    expect(find.text('Check your wi-fi connection or cellular data \nand try again.'), findsOneWidget);
  });

  
}
