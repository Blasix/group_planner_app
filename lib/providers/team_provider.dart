import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:group_planner_app/models/event_model.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import 'member_provider.dart';

class TeamProvider with ChangeNotifier {
  var sub = FirebaseFirestore.instance;
  static final Map<String, TeamModel> _teamMap = {};
  static final List<TeamMemberModel> _members = [];
  static List<EventModel> _events = [];

  List<TeamModel> get getYourTeams {
    return _teamMap.values.toList();
  }

  List<TeamMemberModel> get getSelectedTeamMembers {
    return _members;
  }

  List<EventModel> get getSelectedTeamEvents {
    return _events;
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
      if (!value.exists) return;
      team = TeamModel(
        uuid: value.id,
        name: value.get('name'),
        leader: value.get('leader'),
        pictureUrl: value.get('pictureUrl'),
        members: value.get('members'),
      );
    });

    return team;
  }

  void listenToYourTeams() {
    final uid = authInstance.currentUser!.uid;
    sub
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
    sub.collection('users').doc(uid).snapshots().listen((event) {
      if (!event.exists) return;
      final selectedTeam = event.get('selectedTeam');
      team = _teamMap[selectedTeam];
      if (team != null) {
        team!.members.remove(uid);
        _members.clear();
        for (final member in team!.members) {
          sub.collection('users').doc(member).snapshots().listen(
            (value) {
              _members.add(
                TeamMemberModel(
                  name: value.get('username'),
                  pictureURL: value.get('profilePictureUrl'),
                  id: value.get('id'),
                ),
              );
            },
          );
          notifyListeners();
        }
        sub
            .collection('teams')
            .doc(selectedTeam)
            .collection('events')
            .snapshots()
            .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final events = snapshot.docs
                .map((document) => EventModel.fromMap(document.data()))
                .toList();
            if (_events != events) {
              _events = events;
              notifyListeners();
            }
          } else {
            _events.clear();
            notifyListeners();
          }
        });
      }
    });
  }

  void stop() {
    sub.terminate();
    _teamMap.clear();
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
