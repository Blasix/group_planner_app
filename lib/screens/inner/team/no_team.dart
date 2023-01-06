import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:group_planner_app/screens/inner/team/select_team.dart';
import 'package:uuid/uuid.dart';

import '../../../consts/firebase_consts.dart';
import '../../../services/global_methods.dart';

class NoTeam extends StatefulWidget {
  const NoTeam({super.key});

  @override
  State<NoTeam> createState() => _NoTeamState();
}

class _NoTeamState extends State<NoTeam> {
  final TextEditingController _teamCreateController =
      TextEditingController(text: "");

  @override
  void dispose() {
    _teamCreateController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _createTeam(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      GlobalMethods.dialog(
        context: context,
        title: 'Succes!',
        message: '${_teamCreateController.text} has been created',
      );
      if (Navigator.canPop(context)) Navigator.pop(context);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Future showTeamDialog() async {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              1,
            ),
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

    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
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
                  showTeamDialog();
                },
                child: Text(AppLocalizations.of(context)!.createGroup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
