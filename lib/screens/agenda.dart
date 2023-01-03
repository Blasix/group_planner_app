import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/team_model.dart';
import '../providers/team_provider.dart';
import '../services/utils.dart';
import '../widgets/agenda/events.dart';
import 'inner/team/no_team.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  TimeOfDay time = const TimeOfDay(hour: 0, minute: 0);
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final TeamModel? selectedTeam = teamProvider.getSelectedTeam(context);

    if (selectedTeam == null) {
      return const NoTeam();
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return AlertDialog(
                      shape: ShapeBorder.lerp(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        1,
                      ),
                      title: Text(
                          "Add Event (${_focusedDay.toString().split(" ")[0]})"),
                      content: SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration:
                                  InputDecoration(hintText: 'event name'),
                              // controller: _eventController,
                            ),
                            // const Spacer(),
                            TextButton(
                                onPressed: () async {
                                  final TimeOfDay? newTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: time,
                                  );
                                  setState(() {
                                    if (newTime != null) time = newTime;
                                  });
                                },
                                child:
                                    Text('select time ${time.format(context)}'))
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.no),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.yes),
                          onPressed: () {
                            // if (_eventController.text.isEmpty) {

                            // } else {
                            //   if (selectedEvents[selectedDay] != null) {
                            //     selectedEvents[selectedDay].add(
                            //       Event(title: _eventController.text),
                            //     );
                            //   } else {
                            //     selectedEvents[selectedDay] = [
                            //       Event(title: _eventController.text)
                            //     ];
                            //   }

                            // }
                            Navigator.pop(context);
                            // _eventController.clear();
                            // setState((){});
                            // return;
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
          label: const Text(
            'Add event',
            style: TextStyle(color: Colors.black),
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        body: Column(
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
            )
          ],
        ),
      ),
    );
  }
}
