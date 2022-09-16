import 'package:flutter/cupertino.dart';

class TeamModel extends ChangeNotifier {
  final String uuid, name, leader, pictureUrl;
  final List members;

  TeamModel(
      {required this.uuid,
      required this.name,
      required this.leader,
      required this.pictureUrl,
      required this.members});
}


//'id': uuid,
//'name': _teamCreateController.text,
//'leader': uid,
//'members': [
//           uid,
//         ],
//'events': [],
//'pictureUrl': '',
//'createdAt': Timestamp.now(),