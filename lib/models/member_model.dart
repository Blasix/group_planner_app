import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MemberModel extends ChangeNotifier {
  final String id, name, email, currentTeam, pictureURL;
  final Timestamp createdAt;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
    required this.currentTeam,
    required this.pictureURL,
    required this.createdAt,
  });
}

class TeamMemberModel extends ChangeNotifier {
  final String name, pictureURL;

  TeamMemberModel({
    required this.name,
    required this.pictureURL,
  });
}
