import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/category_news_widget.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/failure_message_widget.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/item_news_widget.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/today_date_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/categorynews/category_news_model.dart';
import '../../../data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import '../../bloc/topheadlinesnews/bloc.dart';
import '../search/search_page.dart';
import '../settings/settings_page.dart';
import '../../../../injection_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final topHeadlinesNewsBloc = sl<TopHeadlinesNewsBloc>();
  final listCategories = [
    CategoryNewsModel(image: '', title: 'All'),
    CategoryNewsModel(image: 'assets/images/img_business.png', title: 'Business'),
    CategoryNewsModel(image: 'assets/images/img_entertainment.png', title: 'Entertainment'),
    CategoryNewsModel(image: 'assets/images/img_health.png', title: 'Health'),
    CategoryNewsModel(image: 'assets/images/img_science.png', title: 'Science'),
    CategoryNewsModel(image: 'assets/images/img_sport.png', title: 'Sports'),
    CategoryNewsModel(image: 'assets/images/img_technology.png', title: 'Technology'),
  ];
  final refreshIndicatorState = GlobalKey<RefreshIndicatorState>();

  bool isLoadingCenterIOS = false;
  late Completer completerRefresh;
  var indexCategorySelected = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isIOS) {
        isLoadingCenterIOS = true;
        topHeadlinesNewsBloc.add(
          LoadTopHeadlinesNewsEvent(category: listCategories[indexCategorySelected].title!.toLowerCase()),
        );
      } else {
        completerRefresh = Completer();
        refreshIndicatorState.currentState!.show();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: BlocProvider<TopHeadlinesNewsBloc>(
        create: (context) => topHeadlinesNewsBloc,
        child: BlocListener<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
          listener: (context, state) {
            if (state is FailureTopHeadlinesNewsState) {
              _resetRefreshIndicator();
            } else if (state is LoadedTopHeadlinesNewsState) {
              _resetRefreshIndicator();
            } else if (state is ChangedCategoryTopHeadlinesNewsState) {
              indexCategorySelected = state.indexCategorySelected;
              if (Platform.isIOS) {
                isLoadingCenterIOS = true;
                var category = listCategories[indexCategorySelected].title!.toLowerCase();
                topHeadlinesNewsBloc.add(LoadTopHeadlinesNewsEvent(category: category));
              } else {
                refreshIndicatorState.currentState!.show();
              }
            }
          },
          child: ValueListenableBuilder(
            valueListenable: Hive.box('settings').listenable(),
            builder: (context, box, widget) {
              var isDarkMode = box.get('darkMode') ?? false;
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: isDarkMode ? null : Color(0xFFEFF5F5),
                  ),
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      color: isDarkMode ? null : Color(0xFFEFF5F5),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    'Daily News',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SearchPage()),
                                      );
                                    },
                                    child: Hero(
                                      tag: 'iconSearch',
                                      child: Icon(
                                        Icons.search,
                                        size: 24.w,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SettingsPage(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.settings,
                                      size: 24.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DateTodayWidget(),
                          SizedBox(height: 24.h),
                          CategoryNewsWidget(
                            listCategories: listCategories, 
                            indexDefaultSelected: indexCategorySelected,
                          ),
                          SizedBox(height: 24.h),
                          Expanded(
                            child: _buildWidgetContentNews(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _resetRefreshIndicator() {
    if (isLoadingCenterIOS) {
      isLoadingCenterIOS = false;
    }
    completerRefresh.complete();
    completerRefresh = Completer();
  }

  Widget _buildWidgetContentNews() {
    return BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
      builder: (context, state) {
        var listArticles = <ItemArticleTopHeadlinesNewsResponseModel>[];
        if (state is LoadedTopHeadlinesNewsState) {
          listArticles.addAll(state.listArticles);
        }
        return Stack(
          children: [
            RefreshIndicator(
              key: refreshIndicatorState,
              onRefresh: () {
                topHeadlinesNewsBloc.add(
                  LoadTopHeadlinesNewsEvent(category: listCategories[indexCategorySelected].title!.toLowerCase()),
                );
                return completerRefresh.future;
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  var itemArticle = listArticles[index];
                  var dateTimePublishedAt = DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(itemArticle.publishedAt!, true);
                  var strPublishedAt = DateFormat('MMM dd, yyyy HH:mm').format(dateTimePublishedAt);
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () async {
                        if (await canLaunchUrlString(itemArticle.url!)) {
                          await launchUrlString(itemArticle.url!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Couldn\'t open detail news'),
                          ));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: itemArticle.urlToImage==null? null: DecorationImage(
                            image: NetworkImage(
                              itemArticle.urlToImage!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black.withOpacity(0.0),
                                  ],
                                  stops: [
                                    0.0,
                                    1.0,
                                  ],
                                ),
                              ),
                              padding: EdgeInsets.all(24.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.circular(48),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 8.w,
                                    ),
                                    child: Text(
                                      'Latest News',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    itemArticle.title!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AutoSizeText(
                                        strPublishedAt+' | '+itemArticle.source!.name,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                        minFontSize: 8,
                                        maxFontSize: 24,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 1 ? 32.h : 16.h,
                        bottom: 16.h,
                      ),
                      child: ItemNewsWidget(
                        itemArticle: itemArticle,
                        strPublishedAt: strPublishedAt,
                      ),
                    );
                  }
                },
                itemCount: listArticles.length,
              ),
            ),
            listArticles.isEmpty && state is FailureTopHeadlinesNewsState ? _buildWidgetFailureLoadData() : Container(),
          ],
        );
      },
    );
  }

  Widget _buildWidgetFailureLoadData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FailureMessageWidget(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
            ),
            onPressed: () {
              if (Platform.isIOS) {
                isLoadingCenterIOS = true;
                topHeadlinesNewsBloc.add(
                  LoadTopHeadlinesNewsEvent(category: listCategories[indexCategorySelected].title!.toLowerCase()),
                );
              } else {
                refreshIndicatorState.currentState!.show();
              }
            },
            child: Text(
              'Try Again'.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

