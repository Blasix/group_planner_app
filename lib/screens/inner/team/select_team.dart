import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:group_planner_app/consts/loading_manager.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../consts/firebase_consts.dart';
import '../../../models/team_model.dart';
import '../../../providers/team_provider.dart';
import '../../../services/global_methods.dart';
import '../../../widgets/team/select_team.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({Key? key}) : super(key: key);

  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  final TextEditingController _teamCreateController =
      TextEditingController(text: "");
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
        'pictureUrl': '',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'selectedTeam': uuid});
      GlobalMethods.dialog(
        context: context,
        title: 'Succes!',
        message:
            AppLocalizations.of(context)!.creation(_teamCreateController.text),
      );
      Navigator.pop(context);
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
    }
  }

  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<TeamModel> listTeamSearch = [];

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    List<TeamModel> teams = teamProvider.getYourTeams;
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)!.selectGroup),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: InkWell(
                onTap: () {
                  _showTeamDialog();
                },
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: TextField(
                  maxLines: 1,
                  focusNode: _searchTextFocusNode,
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {
                      listTeamSearch =
                          teamProvider.findByName(_searchTextController.text);
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).cardColor,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).cardColor,
                        width: 1,
                      ),
                    ),
                    label: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    hintText: AppLocalizations.of(context)!.searchGroup,
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchTextController.clear();
                        _searchTextFocusNode.unfocus();
                        setState(() {
                          listTeamSearch.clear();
                        });
                      },
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            teams.isEmpty
                ? Center(
                    child: Text(AppLocalizations.of(context)!.noGroups),
                  )
                : _searchTextController.text.isNotEmpty &&
                        listTeamSearch.isEmpty
                    ? Center(
                        child:
                            Text(AppLocalizations.of(context)!.noGroupsFound),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _searchTextController.text.isNotEmpty
                              ? listTeamSearch.length
                              : teams.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ChangeNotifierProvider.value(
                                value: _searchTextController.text.isNotEmpty
                                    ? listTeamSearch[index]
                                    : teams[index],
                                child: const SelectTeamWidget());
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Future _showTeamDialog() async {
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
}
