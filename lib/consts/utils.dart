import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:group_planner_app/providers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

// class BlackColor extends StatelessWidget {
//   const BlackColor({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     bool isDarkTheme = Provider.of<DarkThemeProvider>(context).getDarkTheme;
//     Color kBlackColor = isDarkTheme ? Colors.black : Colors.white;
//     return kBlackColor;
//   }
// }

// class Utils {
//   BuildContext context;
//   Utils(this.context);

//   bool get getTheme => Provider.of<DarkThemeProvider>(context).getDarkTheme;

//   Color get blackColor => getTheme ? Colors.black : Colors.white;
//   Color get whiteColor => getTheme ? Colors.white : Colors.black;
//   Size get screenSize => MediaQuery.of(context).size;
// }

// Other
// const kSpacingUnit = 10;
const kPrimaryColor = Color(0xFFFFC107);

// Textstyles
final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(17),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(13),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(15),
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

// Agenda
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
