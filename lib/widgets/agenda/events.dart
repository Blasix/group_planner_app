import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/models/event_model.dart';
import 'package:provider/provider.dart';
import '../../consts/firebase_consts.dart';
import '../../models/team_model.dart';
import '../../providers/team_provider.dart';
import '../../services/utils.dart';

class EventsWidget extends StatefulWidget {
  const EventsWidget({Key? key}) : super(key: key);

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  @override
  Widget build(BuildContext context) {
    final eventModel = Provider.of<EventModel>(context);
    final teamProvider = Provider.of<TeamProvider>(context);
    final selectedTeam = teamProvider.getSelectedTeam(context);
    int teamLenght = teamProvider.getSelectedTeamMembers.length + 1;
    final uid = authInstance.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).cardColor),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${eventModel.name} - ${TimeOfDay.fromDateTime(eventModel.eventTime.toDate()).format(context)}",
                      style: kTitleTextStyle.copyWith(fontSize: 24),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: eventModel.votes.contains(uid)
                      ? const Icon(
                          Icons.check,
                          size: 36,
                        )
                      : InkWell(
                          onTap: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('teams')
                                  .doc(selectedTeam!.uuid)
                                  .collection('events')
                                  .doc(eventModel.uuid)
                                  .update({
                                'votes': FieldValue.arrayUnion([uid])
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Icon(
                            Icons.add,
                            size: 36,
                          ),
                        ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
              child: ProgressBar(
                max: teamLenght.toDouble(),
                current: eventModel.votes.length.toDouble(),
                color: Theme.of(context).primaryColor,
                colorBG: Theme.of(context).canvasColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final Color color;
  final Color colorBG;

  const ProgressBar(
      {Key? key,
      required this.max,
      required this.current,
      required this.color,
      required this.colorBG})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 12,
              decoration: BoxDecoration(
                color: colorBG,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: percent,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ],
        );
      },
    );
  }
}
