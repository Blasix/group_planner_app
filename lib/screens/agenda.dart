import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../consts/firebase_consts.dart';
import '../models/event_model.dart';
import '../models/team_model.dart';
import '../providers/team_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/agenda/events.dart';
import 'inner/team/no_team.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _eventController = TextEditingController();
  final _eventDescController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setState(() {
      _selectedDay = _focusedDay;
    });
    super.initState();
  }

  @override
  void dispose() {
    _eventController.dispose();
    _eventDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final TeamModel? selectedTeam = teamProvider.getSelectedTeam(context);
    final List<EventModel> events = teamProvider.getSelectedTeamEvents;
    final List<EventModel> currentEvents = [];
    for (var element in events) {
      if (DateFormat('yyyy-MM-dd').format(element.eventTime.toDate()) ==
          DateFormat('yyyy-MM-dd').format(_selectedDay!)) {
        currentEvents.add(element);
      }
    }
    if (selectedTeam == null) {
      return const NoTeam();
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            createEvent();
          },
          label: Text(
            AppLocalizations.of(context)!.addEvent,
            style: const TextStyle(color: Colors.black),
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
              eventLoader: (day) {
                return events
                    .where((event) =>
                        event.eventTime.toDate().day == day.day &&
                        event.eventTime.toDate().month == day.month &&
                        event.eventTime.toDate().year == day.year)
                    .toList();
              },
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
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    shape: BoxShape.circle,
                  ),
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
                itemCount: currentEvents.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                      value: currentEvents[index], child: const EventsWidget());
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void createEvent() {
    showDialog(
        context: context,
        builder: (context) {
          final selectedTeam =
              Provider.of<TeamProvider>(context).getSelectedTeam(context);
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.addEvent),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.eventName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Theme.of(context).canvasColor,
                                focusColor: Theme.of(context).canvasColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ),
                              controller: _eventController,
                              validator: ValidationBuilder(
                                      localeName: AppLocalizations.of(context)!
                                          .localeName)
                                  .maxLength(20)
                                  .required()
                                  .build(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              minLines: 3,
                              maxLines: 8,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .eventDescriptionOptional,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Theme.of(context).canvasColor,
                                focusColor: Theme.of(context).canvasColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ),
                              ),
                              controller: _eventDescController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            onTap: () async {
                              final DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDay!,
                                firstDate: kFirstDay,
                                lastDate: kLastDay,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ThemeData()
                                          .colorScheme
                                          .copyWith(
                                            onSurface: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            primary:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (newDate != null) {
                                setState(() {
                                  _selectedDay = newDate;
                                });
                              }
                            },
                            child: Material(
                              color: Theme.of(context).canvasColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(DateFormat.yMMMd(
                                        AppLocalizations.of(context)!
                                            .localeName)
                                    .format(_selectedDay!)
                                    .toString()),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            onTap: () async {
                              final TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: time,
                              );
                              if (newTime != null) {
                                setState(() {
                                  time = newTime;
                                });
                              }
                            },
                            child: Material(
                              color: Theme.of(context).canvasColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(time.format(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!.confirm,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              final isValid = _formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();
                              if (isValid) {
                                try {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                  final User? user = authInstance.currentUser;
                                  final uid = user!.uid;
                                  final docRef = FirebaseFirestore.instance
                                      .collection('teams')
                                      .doc(selectedTeam!.uuid)
                                      .collection('events')
                                      .doc();
                                  await docRef.set({
                                    'name': _eventController.text,
                                    'description': _eventDescController.text,
                                    'uuid': docRef.id,
                                    'votes': [
                                      uid,
                                    ],
                                    'eventTime': DateTime(
                                        _selectedDay!.year,
                                        _selectedDay!.month,
                                        _selectedDay!.day,
                                        time.hour,
                                        time.minute),
                                  });
                                } on FirebaseException catch (error) {
                                  GlobalMethods.dialogFailure(
                                    context: context,
                                    message: '${error.message}',
                                  );
                                  return;
                                } catch (error) {
                                  GlobalMethods.dialogFailure(
                                    context: context,
                                    message: '$error',
                                  );
                                  return;
                                }
                                _eventController.clear();
                                _eventDescController.clear();
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
