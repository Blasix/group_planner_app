import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/team_model.dart';
import '../../../providers/team_provider.dart';
import '../../../widgets/team/select_team.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({Key? key}) : super(key: key);

  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(AppLocalizations.of(context)!.selectGroup),
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
                  hintText: 'Search Product',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchTextController.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          teams.isEmpty
              ? const Center(
                  child: Text('You have no teams, please create one!'),
                )
              : _searchTextController.text.isNotEmpty && listTeamSearch.isEmpty
                  ? const Center(
                      child: Text('No Teams found, please try another keyword'),
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
    );
  }
}
