import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:group_planner_app/providers/team_provider.dart';
import 'package:group_planner_app/services/dynamic_link.dart';
import 'package:group_planner_app/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../consts/firebase_consts.dart';
import '../services/global_methods.dart';
import '../widgets/team/member.dart';
import 'inner/team/no_team.dart';
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
      return const NoTeam();
    }

    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                AdSize.banner.height,
            child: SafeArea(
                child: Column(
              children: [
                Flexible(
                  flex: 1,
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
                                                  _showTeamEditDialog(
                                                    selectedTeam,
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .edit,
                                                  style: const TextStyle(
                                                      color: Colors.blue),
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
                        // Row(
                        //   // Debug buttons
                        //   children: [
                        //     // TextButton(
                        //     //   onPressed: () {
                        //     //     setState(() {
                        //     //       teamLenght = teamLenght++;
                        //     //     });
                        //     //   },
                        //     //   child: const Text('add'),
                        //     // ),
                        //     // TextButton(
                        //     //   onPressed: () {
                        //     //     setState(() {
                        //     //       teamLenght = teamLenght--;
                        //     //     });
                        //     //   },
                        //     //   child: const Text('remove'),
                        //     // ),
                        //     TextButton(
                        //       onPressed: () {
                        //         _showTeamDialog();
                        //       },
                        //       child: Text(AppLocalizations.of(context)!.create),
                        //     ),
                        //   ],
                        // ),
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
                              InkWell(
                                onTap: () {
                                  DynamicLinkProvider()
                                      .createLink(selectedTeam.uuid)
                                      .then(
                                    (value) {
                                      Share.share(value);
                                    },
                                  );
                                },
                                child: const Icon(Icons.add),
                              )
                            ],
                          ),
                        ),
                      ],
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
                                      onPressed: () {
                                        DynamicLinkProvider()
                                            .createLink(selectedTeam.uuid)
                                            .then(
                                          (value) {
                                            Share.share(value);
                                          },
                                        );
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .addMembers))
                                ],
                              ),
                            )
                          : GridView.builder(
                              physics: const BouncingScrollPhysics(),
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
        ),
      ),
    );
  }

  Future _showTeamEditDialog(
    selectedTeam,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.edit,
          ),
          content: SizedBox(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Actualy make uption to change team name
                const Text('change name:'),
                TextField(
                    decoration: InputDecoration(hintText: selectedTeam.name)),
                const Spacer(),
                InkWell(
                  onTap: () {
                    GlobalMethods.confirm(
                        context: context,
                        message:
                            'Are you sure you want to delete ${selectedTeam.name}?',
                        onTap: () async {
                          final uid = authInstance.currentUser!.uid;
                          if (Navigator.canPop(context)) Navigator.pop(context);
                          try {
                            setState(() {
                              _isLoading = true;
                            });
                            await FirebaseFirestore.instance
                                .collection('teams')
                                .doc(selectedTeam.uuid)
                                .delete();

                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({'selectedTeam': ''});

                            GlobalMethods.dialog(
                              context: context,
                              title: 'Succes!',
                              message: '${selectedTeam.name} has been deleted',
                            );
                          } on FirebaseException catch (error) {
                            GlobalMethods.dialogFailure(
                              context: context,
                              message: '${error.message}',
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          } catch (error) {
                            GlobalMethods.dialogFailure(
                              context: context,
                              message: '$error',
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                        });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          // actions: [],
        );
      },
    );
  }
}
