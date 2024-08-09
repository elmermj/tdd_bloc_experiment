import 'package:clean_code_architecture_tdd/feature/data/model/categorynews/category_news_model.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/bloc/topheadlinesnews/top_headlines_news_bloc.dart';
import 'package:clean_code_architecture_tdd/feature/presentation/bloc/topheadlinesnews/top_headlines_news_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryNewsWidget extends StatefulWidget {
  final List<CategoryNewsModel> listCategories;
  final int indexDefaultSelected;

  CategoryNewsWidget({
    required this.listCategories,
    required this.indexDefaultSelected,
  });

  @override
  _CategoryNewsWidgetState createState() => _CategoryNewsWidgetState();
}

class _CategoryNewsWidgetState extends State<CategoryNewsWidget> {
  late int indexCategorySelected;

  @override
  void initState() {
    indexCategorySelected = widget.indexDefaultSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var itemCategory = widget.listCategories[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8.w,
              right: index == widget.listCategories.length - 1 ? 0 : 8.w,
            ),
            child: GestureDetector(
              onTap: () {
                if (indexCategorySelected == index) {
                  return;
                }
                setState(() => indexCategorySelected = index);
                var topHeadlinesNewsBloc = BlocProvider.of<TopHeadlinesNewsBloc>(context);
                topHeadlinesNewsBloc.add(
                  ChangeCategoryTopHeadlinesNewsEvent(indexCategorySelected: index),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: itemCategory.title!.toLowerCase() == 'all' ? Color(0xFFBBCDDC) : null,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                  image: itemCategory.title!.toLowerCase() == 'all'
                      ? null
                      : DecorationImage(
                          image: AssetImage(
                            itemCategory.image!,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: itemCategory.title!.toLowerCase() == 'all' ? 32.w : 24.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(indexCategorySelected == index ? 0.2 : 0.6),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    border: indexCategorySelected == index
                        ? Border.all(
                            color: Colors.white,
                            width: 2.0,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      itemCategory.title!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: widget.listCategories.length,
      ),
    );
  }
}