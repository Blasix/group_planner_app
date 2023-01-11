import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/widgets/agenda/voted_members.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/event_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/member_model.dart';
import '../../../providers/member_provider.dart';
import '../../../providers/team_provider.dart';
import '../../../services/global_methods.dart';

class EventDetails extends StatelessWidget {
  final EventModel? event;
  const EventDetails({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    final selectedTeam = teamProvider.getSelectedTeam(context);
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
        .where((element) => event!.votes.contains(element.id))
        .toList();
    if (event!.votes.contains(currentMember.id)) {
      votedMembers.add(currentMember);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.edit_outlined, color: Colors.blue),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: const Icon(Icons.delete_outlined, color: Colors.red),
            onPressed: () {
              GlobalMethods.confirm(
                context: context,
                message: AppLocalizations.of(context)!.delete(event!.name),
                onTap: () async {
                  if (Navigator.canPop(context)) Navigator.of(context).pop();
                  try {
                    await FirebaseFirestore.instance
                        .collection('teams')
                        .doc(selectedTeam!.uuid)
                        .collection('events')
                        .doc(event!.uuid)
                        .delete();
                    GlobalMethods.dialog(
                      context: context,
                      title: 'Succes!',
                      message:
                          AppLocalizations.of(context)!.deletion(event!.name),
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
                      event!.name,
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
                    event!.description.isEmpty
                        ? Text(
                            AppLocalizations.of(context)!.eventNoDescription,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          )
                        : Text(
                            event!.description,
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
                              .format(event!.eventTime.toDate())
                              .toString(),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          TimeOfDay.fromDateTime(event!.eventTime.toDate())
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
                      event!.votes.isEmpty
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
