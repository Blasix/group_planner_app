import 'package:flutter/material.dart';

// Textstyles
const kTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

const kCaptionTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w300,
);

// const kButtonTextStyle = TextStyle(
//   fontSize: 15,
//   fontWeight: FontWeight.w400,
//   color: Colors.black,
// );

// Agenda
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - kToday.year, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + kToday.year, kToday.month, kToday.day);
