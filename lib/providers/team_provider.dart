import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import 'member_provider.dart';

class TeamProvider with ChangeNotifier {
  static final Map<String, TeamModel> _teamMap = {};
  static final List<TeamMemberModel> _members = [];

  // static String selectedTeam = '';

  List<TeamModel> get getYourTeams {
    return _teamMap.values.toList();
  }

  List<TeamMemberModel> get getSelectedTeamMembers {
    return _members;
  }

  TeamModel? getSelectedTeam(context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    return _teamMap[memberProvider.getCurrentMember.currentTeam];
  }

  Future<TeamModel?> findGroupByID(String groupId) async {
    TeamModel? team;

    await FirebaseFirestore.instance
        .collection('teams')
        .doc(groupId)
        .get()
        .then((value) {
      team = TeamModel(
        uuid: value.id,
        name: value.get('name'),
        leader: value.get('leader'),
        pictureUrl: value.get('pictureUrl'),
        members: value.get('members'),
        events: value.get('events'),
      );
    });

    return team;
  }

  void listenToYourTeams() {
    final uid = authInstance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('teams')
        .where('members', arrayContains: uid)
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        final team = TeamModel(
          uuid: element.doc.id,
          name: element.doc.get('name'),
          leader: element.doc.get('leader'),
          pictureUrl: element.doc.get('pictureUrl'),
          members: element.doc.get('members'),
          events: element.doc.get('events'),
        );
        if (element.type == DocumentChangeType.added) {
          _teamMap[team.uuid] = team;
        } else if (element.type == DocumentChangeType.modified) {
          _teamMap[team.uuid] = team;
        } else if (element.type == DocumentChangeType.removed) {
          _teamMap.remove(team.uuid);
        }
      }
      notifyListeners();
    });
  }

  void listenToSelectedTeam() {
    final uid = authInstance.currentUser!.uid;
    TeamModel? team;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      final selectedTeam = event.get('selectedTeam');
      team = _teamMap[selectedTeam];
      notifyListeners();
      if (team != null) {
        team!.members.remove(uid);
        _members.clear();
        for (final member in team!.members) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(member)
              .snapshots()
              .listen(
            (value) {
              _members.add(
                TeamMemberModel(
                  name: value.get('username'),
                  pictureURL: value.get('profilePictureUrl'),
                ),
              );
            },
          );
          notifyListeners();
        }
      }
    });

    notifyListeners();
  }

  List<TeamModel> findByName(String teamName) {
    List<TeamModel> nameList = _teamMap.values
        .toList()
        .where((element) =>
            element.name.toLowerCase().contains(teamName.toLowerCase()))
        .toList();
    return nameList;
  }
}
