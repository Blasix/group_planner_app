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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      // final teamProvider = Provider.of<TeamProvider>(context, listen: false);
      // await teamProvider.fetchTeams();
      // await teamProvider.fetchSelectedTeam(context);
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
    List<TeamMemberModel> currentTeamMembers =
        teamProvider.getSelectedTeamMembers;

    final User? user = authInstance.currentUser;
    int teamLenght = currentTeamMembers.length;
    (teamLenght >= 7)
        ? setState(() {
            memberGrid = 3;
          })
        : setState(() {
            memberGrid = 2;
          });
    final TeamModel? selectedTeam = teamProvider.getSelectedTeam(context);

    //when teammodel is null, it means that the user has no team
    if (selectedTeam == null) {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          title: Text(AppLocalizations.of(context)!.group),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.noGroup,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectTeamScreen(),
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.selectGroup),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () {
                  _showTeamDialog();
                },
                child: Text(AppLocalizations.of(context)!.createGroup),
              ),
            ],
          ),
        ),
      );
    }

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
                        AppLocalizations.of(context)!.group,
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
                                SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            selectedTeam.name,
                                            style: kTitleTextStyle,
                                          ),
                                        ),
                                        Visibility(
                                            visible: (selectedTeam.leader ==
                                                user!.uid),
                                            child: InkWell(
                                              onTap: () {
                                                GlobalMethods.confirm(
                                                    context: context,
                                                    message:
                                                        'Are you sure you want to delete ${selectedTeam.name}?',
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
                                                            .doc(selectedTeam
                                                                .uuid)
                                                            .delete();

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(uid)
                                                            .update({
                                                          'selectedTeam': ''
                                                        });

                                                        // await teamProvider
                                                        //     .fetchTeams();
                                                        // ignore: use_build_context_synchronously
                                                        // await teamProvider
                                                        //     .fetchSelectedTeam(
                                                        //         context);
                                                        GlobalMethods.dialog(
                                                          context: context,
                                                          title: 'Succes!',
                                                          message:
                                                              '${selectedTeam.name} has been deleted',
                                                          contentType:
                                                              ContentType
                                                                  .success,
                                                        );
                                                      } on FirebaseException catch (error) {
                                                        GlobalMethods.dialog(
                                                          context: context,
                                                          title: 'On snap!',
                                                          message:
                                                              '${error.message}',
                                                          contentType:
                                                              ContentType
                                                                  .failure,
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
                                                              ContentType
                                                                  .failure,
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
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .delete,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
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
                            child: Text(AppLocalizations.of(context)!.create),
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
                              AppLocalizations.of(context)!.members,
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
                              Text(
                                AppLocalizations.of(context)!.noMembers,
                                style: const TextStyle(fontSize: 20),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  onPressed: () {},
                                  child: Text(
                                      AppLocalizations.of(context)!.addMembers))
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
                                value: currentTeamMembers[index],
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
