import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/services/utils.dart';
import 'package:uuid/uuid.dart';

import '../consts/firebase_consts.dart';
import '../services/global_methods.dart';
import '../widgets/team/member.dart';
import '../widgets/team/team.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({Key? key}) : super(key: key);

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final TextEditingController _teamCreateController =
      TextEditingController(text: "");

  @override
  void dispose() {
    _teamCreateController.dispose();
    super.dispose();
  }

  int teamLenght = 0;
  int memberGrid = 2;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    (teamLenght >= 7)
        ? setState(() {
            memberGrid = 3;
          })
        : setState(() {
            memberGrid = 2;
          });

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SafeArea(
            child: Column(
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team',
                        style: kTitleTextStyle.copyWith(fontSize: 23),
                      ),
                      const TeamWidget(),
                      Row(
                        // Debug buttons
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                teamLenght++;
                              });
                            },
                            child: const Text('add'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                teamLenght--;
                              });
                            },
                            child: const Text('remove'),
                          ),
                          TextButton(
                            onPressed: () {
                              _showTeamDialog();
                            },
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Members',
                          style: kTitleTextStyle.copyWith(fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Theme.of(context).canvasColor,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     bottom: 16,
                      //   ),
                      //   child: Text(
                      //     'Members',
                      //     style: kTitleTextStyle.copyWith(fontSize: 23),
                      //   ),
                      // ),
                      (teamLenght == 0)
                          ? Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'There are no members in your team',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor),
                                        onPressed: () {},
                                        child:
                                            const Text('Click to add members'))
                                  ],
                                ),
                              ),
                            )
                          : Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: memberGrid,
                                  mainAxisSpacing: 32 / memberGrid,
                                  crossAxisSpacing: 32 / memberGrid,
                                ),
                                itemCount: teamLenght,
                                itemBuilder: (BuildContext context, int index) {
                                  return const MemberWidget();
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future _showTeamDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Please enter a team name'),
          content: TextField(
            controller: _teamCreateController,
            decoration: const InputDecoration(hintText: "Team name"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  final User? user = authInstance.currentUser;
                  final uid = user!.uid;
                  final uuid = const Uuid().v4();
                  await FirebaseFirestore.instance
                      .collection('teams')
                      .doc(uuid)
                      .set({
                    'id': uuid,
                    'name': _teamCreateController.text,
                    'leader': uid,
                    'members': [
                      uid,
                    ],
                    'events': [],
                    'pictureUrl': '',
                    'createdAt': Timestamp.now(),
                  });
                  Navigator.pop(context);
                } on FirebaseException catch (error) {
                  GlobalMethods.dialog(
                    context: context,
                    title: 'On snap!',
                    message: '${error.message}',
                    contentType: ContentType.failure,
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                } catch (error) {
                  GlobalMethods.dialog(
                    context: context,
                    title: 'On snap!',
                    message: '$error',
                    contentType: ContentType.failure,
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  return;
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: const Text(
                'create',
              ),
            ),
          ],
        );
      },
    );
  }
}
