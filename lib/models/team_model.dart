import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TeamModel extends ChangeNotifier {
  final String uuid, name, leader, pictureUrl;
  final List members, events;
  final Timestamp createdAt;

  TeamModel({
    required this.uuid,
    required this.name,
    required this.leader,
    required this.pictureUrl,
    required this.members,
    required this.events,
    required this.createdAt,
  });
}
