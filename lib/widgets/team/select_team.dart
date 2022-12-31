// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/firebase_consts.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:provider/provider.dart';

import '../../services/global_methods.dart';
import '../../services/utils.dart';

class SelectTeamWidget extends StatefulWidget {
  const SelectTeamWidget({Key? key}) : super(key: key);

  @override
  State<SelectTeamWidget> createState() => _SelectTeamWidgetState();
}

class _SelectTeamWidgetState extends State<SelectTeamWidget> {
  @override
  Widget build(BuildContext context) {
    final teamModel = Provider.of<TeamModel>(context);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).canvasColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                ),
                height: 60,
                width: 60,
                child: const Center(child: Text("icon")),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    teamModel.name,
                    style: kTitleTextStyle,
                  ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  final uid = authInstance.currentUser!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({'selectedTeam': teamModel.uuid});
                    Navigator.pop(context);
                  } on FirebaseException catch (error) {
                    GlobalMethods.dialog(
                      context: context,
                      title: 'Oh snap!',
                      message: '${error.message}',
                      contentType: ContentType.failure,
                    );
                    return;
                  } catch (error) {
                    GlobalMethods.dialog(
                      context: context,
                      title: 'Oh snap!',
                      message: '$error',
                      contentType: ContentType.failure,
                    );
                    return;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
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
