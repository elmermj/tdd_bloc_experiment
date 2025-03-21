import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FailureMessageWidget extends StatelessWidget {
  final String errorTitle;
  final String errorSubtitle;

  FailureMessageWidget({
    this.errorTitle = 'You seem to be offline',
    this.errorSubtitle = 'Check your wi-fi connection or cellular data \nand try again.',
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/svg/undraw_newspaper.svg',
          width: ScreenUtil.defaultSize.width / 3,
          height: ScreenUtil.defaultSize.height / 3,
        ),
        SizedBox(height: 8),
        Text(
          errorTitle,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          errorSubtitle,
          style: TextStyle(
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
