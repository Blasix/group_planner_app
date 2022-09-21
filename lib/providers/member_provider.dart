import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_planner_app/models/member_model.dart';

import '../consts/firebase_consts.dart';

class MemberProvider with ChangeNotifier {
  static MemberModel? _currentMember;

  Future<void> fetchCurrentUser() async {
    final uid = authInstance.currentUser!.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    _currentMember = MemberModel(
      id: userDoc.get('id'),
      name: userDoc.get('username'),
      currentTeam: userDoc.get('selectedTeam'),
      email: userDoc.get('email'),
      pictureURL: userDoc.get('profilePictureUrl'),
      createdAt: userDoc.get('createdAt'),
    );
  }

  MemberModel? get getCurrentMember {
    return _currentMember;
  }
}
