import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:table_calendar/table_calendar.dart';

import '../consts/utils.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TableCalendar(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: Icon(IconlyLight.arrow_left_2),
          rightChevronIcon: Icon(IconlyLight.arrow_right_2),
        ),
        calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeData.dark().cardColor.withOpacity(0.6),
            ),
            selectedDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            )),
      ),
    );
  }
}
