import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:group_planner_app/providers/team_provider.dart';
import 'package:group_planner_app/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../consts/firebase_consts.dart';
import '../services/global_methods.dart';
import '../widgets/team/member.dart';
import 'inner/team/select_team.dart';

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

  int memberGrid = 2;
  bool _isLoading = false;

  void _createTeam(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final User? user = authInstance.currentUser;
      final uid = user!.uid;
      final uuid = const Uuid().v4();
      await FirebaseFirestore.instance.collection('teams').doc(uuid).set({
        'id': uuid,
        'name': _teamCreateController.text,
        'leader': uid,
        'members': [
          uid,
        ],
        'events': [],
        'pictureUrl': '',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'selectedTeam': uuid});
      final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      await teamProvider.fetchTeams();
      await teamProvider.fetchSelectedTeam();
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
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    TeamModel? selectedTeam = teamProvider.getSelectedTeam!;
    List<MemberModel> members = teamProvider.getSelectedTeamMembers;
    final User? user = authInstance.currentUser;
    int teamLenght = members.length;
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Team',
                        style: kTitleTextStyle.copyWith(fontSize: 23),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedTeam.name,
                                      style: kTitleTextStyle,
                                    ),
                                    Visibility(
                                        visible:
                                            (selectedTeam.leader == user!.uid),
                                        child: TextButton(
                                          onPressed: () {
                                            GlobalMethods.confirm(
                                                context: context,
                                                message:
                                                    'Are you sure you want to delete ${selectedTeam.name}',
                                                onTap: () async {
                                                  final uid = authInstance
                                                      .currentUser!.uid;
                                                  Navigator.pop(context);
                                                  try {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('teams')
                                                        .doc(selectedTeam.uuid)
                                                        .delete();

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(uid)
                                                        .update({
                                                      'selectedTeam': ''
                                                    });

                                                    await teamProvider
                                                        .fetchTeams();
                                                    await teamProvider
                                                        .fetchSelectedTeam();
                                                    GlobalMethods.dialog(
                                                      context: context,
                                                      title: 'Succes!',
                                                      message:
                                                          '${selectedTeam.name} has been deleted',
                                                      contentType:
                                                          ContentType.success,
                                                    );
                                                  } on FirebaseException catch (error) {
                                                    GlobalMethods.dialog(
                                                      context: context,
                                                      title: 'On snap!',
                                                      message:
                                                          '${error.message}',
                                                      contentType:
                                                          ContentType.failure,
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
                                                      contentType:
                                                          ContentType.failure,
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
                                                });
                                          },
                                          child: const Text(
                                            'delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )),
                                  ],
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SelectTeamScreen(),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.menu_rounded,
                                      size: 40,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        // Debug buttons
                        children: [
                          // TextButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       teamLenght = teamLenght++;
                          //     });
                          //   },
                          //   child: const Text('add'),
                          // ),
                          // TextButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       teamLenght = teamLenght--;
                          //     });
                          //   },
                          //   child: const Text('remove'),
                          // ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Members',
                              style: kTitleTextStyle.copyWith(fontSize: 23),
                            ),
                            const Icon(Icons.add)
                          ],
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
                  child: (teamLenght == 0)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'There are no members in your team',
                                style: TextStyle(fontSize: 20),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  onPressed: () {},
                                  child: const Text('Click to add members'))
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: memberGrid,
                            mainAxisSpacing: 32 / memberGrid,
                            crossAxisSpacing: 32 / memberGrid,
                          ),
                          itemCount: teamLenght,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider.value(
                                value: members[index],
                                child: const MemberWidget());
                          },
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
                _createTeam(context);
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
