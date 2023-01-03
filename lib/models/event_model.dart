import 'package:flutter/cupertino.dart';

class EventModel extends ChangeNotifier {
  final List votes;
  final String name;
  final DateTime eventTime;

  EventModel({
    required this.votes,
    required this.name,
    required this.eventTime,
  });
}
