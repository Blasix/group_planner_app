import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/models/team_model.dart';

import '../consts/firebase_consts.dart';

class TeamProvider with ChangeNotifier {
  static final List<TeamModel> _teamList = [];
  static final List<MemberModel> _memberList = [];
  static TeamModel? _selectedTeam;
  static String? _selectedTeamID;

  List<TeamModel> get getYourTeams {
    return _teamList;
  }

  TeamModel? get getSelectedTeam {
    _selectedTeam ??= TeamModel(
      uuid: '',
      name: 'Select a team ->',
      leader: '',
      pictureUrl: '',
      members: [],
      events: [],
    );
    return _selectedTeam;
  }

  List<MemberModel> get getSelectedTeamMembers {
    return _memberList;
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
              members: element.get('members'),
              events: element.get('events'),
            ));
      }
    });
  }

  Future<void> fetchSelectedTeam() async {
    final uid = authInstance.currentUser!.uid;

    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    _selectedTeamID = userDoc.get('selectedTeam');

    _memberList.clear();
    Future.delayed(const Duration(microseconds: 6), () async {
      _selectedTeam = _teamList
          .where((element) => element.uuid.contains(_selectedTeamID!))
          .toList()[0];

      _selectedTeam!.members.remove(uid);

      for (var element in _selectedTeam!.members) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(element)
            .get()
            .then(
              (value) => _memberList.insert(
                0,
                MemberModel(
                  id: value.get('id'),
                  name: value.get('username'),
                  // currentTeam: value.get('selectedTeam'),
                  email: value.get('email'),
                  pictureURL: value.get('profilePictureUrl'),
                  createdAt: value.get('createdAt'),
                ),
              ),
            );
      }
      notifyListeners();
    });

    notifyListeners();
  }

  List<TeamModel> findByName(String teamName) {
    List<TeamModel> nameList = _teamList
        .where((element) =>
            element.name.toLowerCase().contains(teamName.toLowerCase()))
        .toList();
    return nameList;
  }
}
