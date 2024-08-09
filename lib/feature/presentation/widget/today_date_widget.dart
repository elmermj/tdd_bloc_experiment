import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateTodayWidget extends StatefulWidget {
  @override
  _DateTodayWidgetState createState() => _DateTodayWidgetState();
}

class _DateTodayWidgetState extends State<DateTodayWidget> {
  late String strToday;

  @override
  void initState() {
    strToday = DateFormat('EEEE, MMM dd, yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        strToday,
        style: TextStyle(
          fontSize: 24.sp,
          color: Colors.grey,
        ),
      ),
    );
  }
}