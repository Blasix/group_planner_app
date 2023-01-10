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
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outlined, color: Colors.red),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('teams')
                    .doc(selectedTeam!.uuid)
                    .collection('events')
                    .doc(event!.uuid)
                    .delete();
              } catch (e) {
                GlobalMethods.dialogFailure(
                  context: context,
                  message: e.toString(),
                );
              } finally {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        title: const Text("event details"),
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
                    const Text(
                      "Name:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      event!.name,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const Text(
                      "Description:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      event!.description,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const Text(
                      "Date & Time:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Votes:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true, // important
                        itemCount: votedMembers.length,
                        separatorBuilder: (BuildContext context, int index) =>
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
