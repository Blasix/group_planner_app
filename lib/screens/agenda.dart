import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../consts/utils.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  Widget build(BuildContext context) {
    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime focusedDay = DateTime.now();
    DateTime? selectedDay;
    return SafeArea(
      child: TableCalendar(
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              selectedDay = selectedDay;
              focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          focusedDay = focusedDay;
        },
      ),
    );
  }
}
