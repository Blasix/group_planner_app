import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
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
        message:
            AppLocalizations.of(context)!.creation(_teamCreateController.text),
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
      final formKey = GlobalKey<FormState>();
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
            title: Text(AppLocalizations.of(context)!.enterGroupName),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: _teamCreateController,
                      validator: ValidationBuilder(
                              localeName:
                                  AppLocalizations.of(context)!.localeName)
                          .maxLength(20)
                          .required()
                          .build(),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.groupName,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor,
                        focusColor: Theme.of(context).canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          final isValid = formKey.currentState!.validate();
                          FocusScope.of(context).unfocus();
                          if (isValid) {
                            _createTeam(context);
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.confirm,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
