import 'package:flutter/cupertino.dart';

class TeamModel extends ChangeNotifier {
  final String uuid, name, leader;
  final List members;

  TeamModel({
    required this.uuid,
    required this.name,
    required this.leader,
    required this.members,
  });
}
