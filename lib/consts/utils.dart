import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Textstyles
final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(17),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(13),
  fontWeight: FontWeight.w300,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(15),
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

// Agenda
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + kToday.year, kToday.month, kToday.day);
