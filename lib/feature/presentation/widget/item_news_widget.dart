import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/model/topheadlinesnews/top_headlines_news_response_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemNewsWidget extends StatelessWidget {
  final ItemArticleTopHeadlinesNewsResponseModel? itemArticle;
  final String? strPublishedAt;

  ItemNewsWidget({
    this.itemArticle,
    this.strPublishedAt,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () async {
        final url = itemArticle?.url;
        if (url != null && await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Couldn\'t open detail news'),
            ),
          );
        }
      },
      child: SizedBox(
        height: 200.w,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: itemArticle?.urlToImage ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/img_not_found.jpg',
                        fit: BoxFit.cover,
                        width: 200.w,
                        height: 200.w,
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/img_placeholder.jpg',
                        fit: BoxFit.cover,
                        width: 200.w,
                        height: 200.w,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 200.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.2, 0.3, 0.8],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0.w),
              width: 200.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AutoSizeText(
                    itemArticle?.title ?? 'No Title',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                    minFontSize: 8,
                    maxFontSize: 48,
                  ),
                  itemArticle?.author == null
                ? SizedBox.shrink()
                : SizedBox(height: 8.0.w),
                  itemArticle?.author == null
                ? SizedBox.shrink()
                : AutoSizeText(
                    itemArticle!.author!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    minFontSize: 8,
                    maxFontSize: 16,
                  ),
                  SizedBox(height: 8.0.w),
                  Row(
                    children: [
                      AutoSizeText(
                        (strPublishedAt ?? 'Unknown Date') + ' | ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        minFontSize: 8,
                        maxFontSize: 16,
                      ),
                      AutoSizeText(
                        itemArticle?.source?.name ?? 'Unknown Source',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        minFontSize: 8,
                        maxFontSize: 16,
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
  }
}
