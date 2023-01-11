import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:group_planner_app/widgets/agenda/voted_members.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/event_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/member_model.dart';
import '../../../providers/member_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../services/global_methods.dart';
import '../../../services/utils.dart';

class EventDetails extends StatefulWidget {
  final String? eventID;
  const EventDetails({super.key, this.eventID});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final _eventController = TextEditingController();
  final _eventDescController = TextEditingController();
  TimeOfDay? time;
  DateTime? _selectedDay;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _eventController.dispose();
    _eventDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final selectedTeam = teamProvider.getSelectedTeam(context);
    final List<EventModel> events = teamProvider.getSelectedTeamEvents;
    EventModel event =
        events.firstWhere((element) => element.uuid == widget.eventID);
    List<TeamMemberModel> currentTeamMembers =
        teamProvider.getSelectedTeamMembers;
    // get current member because he might have voted and is not in team members list
    final memberProvider = Provider.of<MemberProvider>(context);
    TeamMemberModel currentMember = TeamMemberModel(
        id: memberProvider.getCurrentMember.id,
        name: memberProvider.getCurrentMember.name,
        pictureURL: memberProvider.getCurrentMember.pictureURL);
    // get the members who voted
    List<TeamMemberModel> votedMembers = currentTeamMembers
        .where((element) => event.votes.contains(element.id))
        .toList();

    if (event.votes.contains(currentMember.id)) {
      votedMembers.add(currentMember);
    }

    void editEvent() {
      setState(() {
        _eventController.text = event.name;
        _eventDescController.text = event.description;
        _selectedDay = event.eventTime.toDate();
        time = TimeOfDay.fromDateTime(event.eventTime.toDate());
      });
      showDialog(
          context: context,
          builder: (context) {
            final selectedTeam =
                Provider.of<TeamProvider>(context).getSelectedTeam(context);
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.editEvent),
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
                                        localeName:
                                            AppLocalizations.of(context)!
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
                                        colorScheme:
                                            ThemeData().colorScheme.copyWith(
                                                  onSurface: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  primary: Theme.of(context)
                                                      .primaryColor,
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
                                  initialTime: time!,
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
                                  child: Text(time!.format(context)),
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
                                final isValid =
                                    _formKey.currentState!.validate();
                                FocusScope.of(context).unfocus();
                                if (isValid) {
                                  try {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                    final docRef = FirebaseFirestore.instance
                                        .collection('teams')
                                        .doc(selectedTeam!.uuid)
                                        .collection('events')
                                        .doc(event.uuid);
                                    await docRef.update({
                                      'name': _eventController.text,
                                      'description': _eventDescController.text,
                                      'eventTime': DateTime(
                                          _selectedDay!.year,
                                          _selectedDay!.month,
                                          _selectedDay!.day,
                                          time!.hour,
                                          time!.minute),
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

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () {
              editEvent();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outlined, color: Colors.red),
            onPressed: () {
              GlobalMethods.confirm(
                context: context,
                message: AppLocalizations.of(context)!.delete(event.name),
                onTap: () async {
                  if (Navigator.canPop(context)) Navigator.of(context).pop();
                  try {
                    await FirebaseFirestore.instance
                        .collection('teams')
                        .doc(selectedTeam!.uuid)
                        .collection('events')
                        .doc(event.uuid)
                        .delete();
                    GlobalMethods.dialog(
                      context: context,
                      title: 'Succes!',
                      message:
                          AppLocalizations.of(context)!.deletion(event.name),
                    );
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
                  } finally {
                    if (Navigator.canPop(context)) Navigator.of(context).pop();
                  }
                },
              );
            },
          ),
        ],
        title: Text(AppLocalizations.of(context)!.eventDetails),
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.eventName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      event.name,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Text(
                      AppLocalizations.of(context)!.eventDescription,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    event.description.isEmpty
                        ? Text(
                            AppLocalizations.of(context)!.eventNoDescription,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          )
                        : Text(
                            event.description,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          ),
                    const Divider(
                      thickness: 1,
                    ),
                    Text(
                      AppLocalizations.of(context)!.eventDateTime,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat.yMMMd(
                                  AppLocalizations.of(context)!.localeName)
                              .format(event.eventTime.toDate())
                              .toString(),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          TimeOfDay.fromDateTime(event.eventTime.toDate())
                              .format(context),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
                      ],
                    ),
                    // const Divider(
                    //   thickness: 1,
                    // ),
                    // const Text(
                    //   "Location:",
                    //   style:
                    //       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    // //TODO implement location
                    // // const Text(event!.location),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.eventVotes,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      event.votes.isEmpty
                          ? Text(
                              AppLocalizations.of(context)!.eventNoVotes,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .color),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true, // important
                              itemCount: votedMembers.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(
                                thickness: 1,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return ChangeNotifierProvider.value(
                                  value: votedMembers[index],
                                  child: const VotedMembers(),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
