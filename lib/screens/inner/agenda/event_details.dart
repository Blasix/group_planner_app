import 'package:flutter/material.dart';
import 'package:group_planner_app/widgets/agenda/voted_members.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/event_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/member_model.dart';
import '../../../providers/member_provider.dart';
import '../../../providers/team_provider.dart';

class EventDetails extends StatelessWidget {
  final EventModel? event;
  const EventDetails({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    // get current team members
    final teamProvider = Provider.of<TeamProvider>(context);
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
        title: const Text("event details"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("Name:"),
                const Spacer(),
                Text(event!.name),
              ],
            ),
            const Divider(),
            const Text("description?"),
            const Divider(),
            Row(
              children: [
                const Text("Date & Time:"),
                const Spacer(),
                Text(DateFormat.yMMMd(AppLocalizations.of(context)!.localeName)
                    .format(event!.eventTime.toDate())
                    .toString()),
                const SizedBox(width: 10),
                Text(TimeOfDay.fromDateTime(event!.eventTime.toDate())
                    .format(context)),
              ],
            ),
            const Divider(),
            const Text("location?"),
            const Divider(),
            const Text("Votes:"),
            Expanded(
              child: ListView.builder(
                itemCount: votedMembers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                    value: votedMembers[index],
                    child: const VotedMembers(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
