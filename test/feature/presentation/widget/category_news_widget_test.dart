import 'package:clean_code_architecture_tdd/feature/data/model/categorynews/category_news_model.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/bloc/topheadlinesnews/top_headlines_news_bloc.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/category_news_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'category_news_widget_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TopHeadlinesNewsBloc>()])
void main() {
  testWidgets('renders CategoryNewsWidget correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(375, 812), // Example design size, adjust as needed
        builder: (ctx, builder) => MaterialApp(
          home: Scaffold(
            body: CategoryNewsWidget(
              listCategories: [
                CategoryNewsModel(title: 'Business', image: 'assets/images/img_business.png'),
                CategoryNewsModel(
                  title: 'Entertainment',
                  image: 'assets/images/img_entertainment.png'
                ),
              ],
              indexDefaultSelected: 0,
            ),
          ),
        ),
      ),
    );

    // Verify
    expect(find.text('Business'), findsOneWidget);
    expect(find.text('Entertainment'), findsOneWidget);
  });

  testWidgets('changes selected category on tap', (WidgetTester tester) async {
    final mockBloc = MockTopHeadlinesNewsBloc();

    // Build the widget tree with the CategoryNewsWidget
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: Size(375, 812), // Example design size, adjust as needed
        builder: (ctx, builder) => MaterialApp(
          home: Scaffold(
            body: BlocProvider<TopHeadlinesNewsBloc>.value(
              value: mockBloc,
              child: CategoryNewsWidget(
                listCategories: [
                  CategoryNewsModel(
                    title: 'Business',
                    image: 'assets/images/img_business.png'
                  ),
                  CategoryNewsModel(
                    title: 'Entertainment',
                    image: 'assets/images/img_entertainment.png'
                  ),
                ],
                indexDefaultSelected: 0,
              ),
            ),
          ),
        ),
      ),
    );

    // Verify initial state
    expect(find.byWidgetPredicate((widget) {
      return widget is Container &&
      widget.decoration ==  BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(color: Colors.white, width: 2.0),
                            );
    }), findsOneWidget);

    // Tap on the 'Entertainment' category
    await tester.tap(find.text('Entertainment'));
    await tester.pump();

    // Verify final state
    expect(find.byWidgetPredicate((widget) {
      return 
      widget is Container &&
      widget.decoration ==  BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(color: Colors.white, width: 2.0),
                            );
    }), findsOneWidget);

    expect(find.byWidgetPredicate((widget) {
      return widget is Container &&
      widget.decoration ==  BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            );
    }), findsOneWidget);
  });
}
