import 'dart:async';
import 'dart:io';

import 'package:clean_code_architecture_tdd/feature/presentation/widget/failure_message_widget.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/widget/item_news_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/topheadlinesnews/bloc.dart';
import '../../../../injection_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final topHeadlinesNewsBloc = sl<TopHeadlinesNewsBloc>();
  final controllerKeyword = TextEditingController();
  final focusNodeIconSearch = FocusNode();
  late String keyword;
  late Timer debounce;

  @override
  void initState() {
    keyword = '';
    controllerKeyword.addListener(_onSearching);
    super.initState();
  }

  @override
  void dispose() {
    focusNodeIconSearch.dispose();
    controllerKeyword.removeListener(_onSearching);
    controllerKeyword.dispose();
    debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var theme = Theme.of(context);
    var isDarkTheme = theme.brightness == Brightness.dark;
    return Scaffold(
      body: BlocProvider<TopHeadlinesNewsBloc>(
        create: (context) => topHeadlinesNewsBloc,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: isDarkTheme ? null : Color(0xFFEFF5F5),
            ),
            SafeArea(
              child: Container(
                color: isDarkTheme ? null : Color(0xFFEFF5F5),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 16.w,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(99.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controllerKeyword,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Searching something?',
                                      hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.grey,
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: 'iconSearch',
                                  child: Focus(
                                    focusNode: focusNodeIconSearch,
                                    child: Icon(
                                      Icons.search,
                                      size: 24.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: BlocBuilder<TopHeadlinesNewsBloc, TopHeadlinesNewsState>(
                        builder: (context, state) {
                          if (state is LoadingTopHeadlinesNewsState) {
                            return Center(
                              child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator(),
                            );
                          } else if (state is FailureTopHeadlinesNewsState) {
                            return FailureMessageWidget();
                          } else if (state is SearchSuccessTopHeadlinesNewsState) {
                            var listArticles = state.listArticles;
                            if (listArticles.isEmpty) {
                              return FailureMessageWidget(
                                errorTitle: 'Data not found',
                                errorSubtitle: 'Hm, we couldn\'t find what you were looking for.',
                              );
                            } else {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  var itemArticle = listArticles[index];
                                  var dateTimePublishedAt =
                                      DateFormat('yyy-MM-ddTHH:mm:ssZ').parse(itemArticle.publishedAt!, true);
                                  var strPublishedAt = DateFormat('MMM dd, yyyy HH:mm').format(dateTimePublishedAt);
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    child: ItemNewsWidget(
                                      itemArticle: itemArticle,
                                      strPublishedAt: strPublishedAt,
                                    ),
                                  );
                                },
                                itemCount: listArticles.length,
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearching() {
    if (debounce.isActive) {
      debounce.cancel();
    }
    debounce = Timer(Duration(milliseconds: 800), () {
      var keyword = controllerKeyword.text.trim();
      if (keyword.isEmpty || this.keyword == keyword) {
        return;
      }
      this.keyword = keyword;
      focusNodeIconSearch.requestFocus();
      topHeadlinesNewsBloc.add(SearchTopHeadlinesNewsEvent(keyword: keyword));
    });
  }
}
