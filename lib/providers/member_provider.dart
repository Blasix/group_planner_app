import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/models/member_model.dart';

import '../consts/firebase_consts.dart';

class MemberProvider with ChangeNotifier {
  static MemberModel? _currentMember;

  void listenToCurrentUser() {
    final uid = authInstance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      _currentMember = MemberModel(
        hasPremium: event.get('hasPremium'),
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

  MemberModel? get getCurrentMember {
    return _currentMember;
  }
}
