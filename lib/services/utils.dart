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

// Agenda
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
