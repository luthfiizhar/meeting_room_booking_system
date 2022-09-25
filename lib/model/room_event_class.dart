import 'package:flutter/material.dart';

class RoomEvent {
  RoomEvent(
      this.eventName,
      this.organizer,
      this.contactID,
      this.capacity,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.startTimeZone,
      this.endTimeZone,
      this.recurrenceRule,
      this.resourceIds);

  String eventName;
  String? organizer;
  String? contactID;
  int? capacity;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String? startTimeZone;
  String? endTimeZone;
  String? recurrenceRule;
  List<String>? resourceIds;

  @override
  String toString() {
    return "eventName: $eventName";
  }
}
