import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        'events': [],
        'pictureUrl': '',
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'selectedTeam': uuid});
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
