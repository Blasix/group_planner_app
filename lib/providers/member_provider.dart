import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/models/member_model.dart';

import '../consts/firebase_consts.dart';

class MemberProvider with ChangeNotifier {
  var sub = FirebaseFirestore.instance;
  static MemberModel _currentMember = MemberModel(
    id: '',
    name: '',
    currentTeam: '',
    email: '',
    pictureURL: '',
    createdAt: Timestamp.now(),
  );

  void listenToCurrentUser() {
    final uid = authInstance.currentUser!.uid;

    sub.collection('users').doc(uid).snapshots().listen((event) {
      _currentMember = MemberModel(
        id: event.get('id'),
        name: event.get('username'),
        currentTeam: event.get('selectedTeam'),
        email: event.get('email'),
        pictureURL: event.get('profilePictureUrl'),
        createdAt: event.get('createdAt'),
      );
      notifyListeners();
    });
  }

  void stop() {
    sub.terminate();
  }

  MemberModel get getCurrentMember {
    return _currentMember;
  }
}
