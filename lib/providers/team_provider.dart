import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:group_planner_app/models/member_model.dart';
import 'package:group_planner_app/models/team_model.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import 'member_provider.dart';

//TODO dynamicly update teamlist when something changes in Firestore
//TODO change fetchseletedteam so that it uses memberlist and that it dynamicly updates

class TeamProvider with ChangeNotifier {
  static final List<TeamModel> _teamList = [];
  static final Map<String, TeamModel> _teamMap = {};
  static final List<TeamMemberModel> _members = [];
  static TeamModel? team;
  static String selectedTeam = '';

  List<TeamModel> get getYourTeams {
    return _teamList;
  }

  Map<String, TeamModel> get getYourTeamsMap {
    return _teamMap;
  }

  List<TeamMemberModel> get getSelectedTeamMembers {
    return _members;
  }

  TeamModel? getSelectedTeam(context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    return _teamMap[memberProvider.getCurrentMember!.currentTeam];
  }

  //dynamicly listen to teams where user is in from firestore and put them in map
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
          _teamList.add(team);
          _teamMap[team.uuid] = team;
        } else if (element.type == DocumentChangeType.modified) {
          _teamList.removeWhere((element) => element.uuid == team.uuid);
          _teamList.add(team);
          _teamMap[team.uuid] = team;
        } else if (element.type == DocumentChangeType.removed) {
          _teamList.removeWhere((element) => element.uuid == team.uuid);
          _teamMap.remove(team.uuid);
        }
      }
      notifyListeners();
    });
  }

  //TODO make listenToSelectedTeamMembers fully dynamic
  // void listenToSelectedTeamMembers(context) {
  //   final memberProvider = Provider.of<MemberProvider>(context, listen: false);
  //   FirebaseFirestore.instance
  //       .collection('teams')
  //       .doc(memberProvider.getCurrentMember!.currentTeam)
  //       .collection('members')
  //       .snapshots()
  //       .listen((event) {
  //     for (var element in event.docChanges) {
  //       final member = TeamMemberModel(
  //         id: element.doc.id,
  //         name: element.doc.get('username'),
  //         email: element.doc.get('email'),
  //         pictureURL: element.doc.get('profilePictureUrl'),
  //         createdAt: element.doc.get('createdAt'),
  //       );
  //       if (element.type == DocumentChangeType.added) {
  //         _members.add(member);
  //       } else if (element.type == DocumentChangeType.modified) {
  //         _members.removeWhere((element) => element.id == member.id);
  //         _members.add(member);
  //       } else if (element.type == DocumentChangeType.removed) {
  //         _members.removeWhere((element) => element.id == member.id);
  //       }
  //     }
  //     notifyListeners();
  //   });
  // }

  Future<void> listenToSelectedTeamMembers() async {
    final uid = authInstance.currentUser!.uid;

    // The problem with this is that with .get the data is no longer updated live
    // So you have to make the data from firestore listen live
    // But then you get an error

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      selectedTeam = value.get('selectedTeam');
      team = _teamMap[selectedTeam];
      notifyListeners();
    });

    team!.members.remove(uid);
    for (final member in team!.members) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(member)
          .snapshots()
          .listen(
        (value) {
          _members.add(
            TeamMemberModel(
              id: value.get('id'),
              name: value.get('username'),
              email: value.get('email'),
              pictureURL: value.get('profilePictureUrl'),
              createdAt: value.get('createdAt'),
            ),
          );
        },
      );
      notifyListeners();
    }
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
