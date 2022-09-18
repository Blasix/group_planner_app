import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:group_planner_app/models/team_model.dart';

import '../consts/firebase_consts.dart';

class TeamProvider with ChangeNotifier {
  static final List<TeamModel> _teamList = [];
  static TeamModel? _selectedTeam;
  static String? _selectedTeamID;

  List<TeamModel> get getYourTeams {
    return _teamList;
  }

  TeamModel? get getSelectedTeam {
    return _selectedTeam;
  }

  Future<void> fetchTeams() async {
    final uid = authInstance.currentUser!.uid;
    _teamList.clear();
    await FirebaseFirestore.instance
        .collection('teams')
        .where('members', arrayContains: uid)
        .get()
        .then((QuerySnapshot productSnapshot) {
      for (var element in productSnapshot.docs) {
        _teamList.insert(
            0,
            TeamModel(
              uuid: element.get('id'),
              name: element.get('name'),
              leader: element.get('leader'),
              pictureUrl: element.get('pictureUrl'),
              createdAt: element.get('createdAt'),
              members: element.get('members'),
              events: element.get('events'),
            ));
      }
    });
  }

  Future<void> fetchSelectedTeam() async {
    try {
      final uid = authInstance.currentUser!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _selectedTeamID = userDoc.get('selectedTeam');

      _selectedTeam = _teamList
          .where((element) => element.uuid.contains(_selectedTeamID!))
          .toList()[0];
      notifyListeners();
    } catch (e) {
      _selectedTeam ??= TeamModel(
          uuid: '',
          name: '',
          leader: '',
          pictureUrl: '',
          members: [],
          events: [],
          createdAt: Timestamp.now());
    }
  }

  List<TeamModel> findByName(String teamName) {
    List<TeamModel> nameList = _teamList
        .where((element) =>
            element.name.toLowerCase().contains(teamName.toLowerCase()))
        .toList();
    return nameList;
  }
}
