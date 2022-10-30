import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/utils.dart';
import '../widgets/agenda/events.dart';

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
      child: Column(
        children: [
          TableCalendar(
            locale: AppLocalizations.of(context)!.localeName,
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
                weekendTextStyle: TextStyle(
                  color: ThemeData.dark().cardColor,
                ),
                outsideTextStyle: TextStyle(
                  color: ThemeData.dark().cardColor.withOpacity(0.8),
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeData.dark().cardColor.withOpacity(0.6),
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                )),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return const EventsWidget();
              },
            ),
          ),
        ],
      ),
    );
  }
}
