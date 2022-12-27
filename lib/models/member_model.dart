import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MemberModel extends ChangeNotifier {
  final String id, name, email, currentTeam, pictureURL;
  final Timestamp createdAt;
  final bool hasPremium;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.currentTeam,
    required this.pictureURL,
    required this.createdAt,
    required this.hasPremium,
  });
}

class TeamMemberModel extends ChangeNotifier {
  final String id, name, email, pictureURL;
  final Timestamp createdAt;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.pictureURL,
    required this.createdAt,
  });
}
