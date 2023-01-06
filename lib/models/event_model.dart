import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class EventModel extends ChangeNotifier {
  final List votes;
  final String name, uuid;
  final Timestamp eventTime;

  EventModel({
    required this.uuid,
    required this.votes,
    required this.name,
    required this.eventTime,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      name: map['name'],
      eventTime: map['eventTime'],
      votes: map['votes'],
      uuid: map['uuid'],
    );
  }
}
