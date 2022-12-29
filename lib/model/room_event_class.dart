import 'package:flutter/material.dart';

class RoomEvent {
  RoomEvent({
    this.eventName = "",
    this.organizer = "",
    this.contactID = "",
    this.capacity = 2,
    this.from,
    this.to,
    this.background = Colors.black,
    this.isAllDay = false,
    this.startTimeZone = "",
    this.endTimeZone = "",
    this.recurrenceRule = "",
    this.resourceIds,
    this.isDark = true,
    this.bookingID = "",
  });

  String? eventName;
  String? organizer;
  String? contactID;
  int? capacity;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
  String? startTimeZone;
  String? endTimeZone;
  String? recurrenceRule;
  List<String>? resourceIds;
  bool isDark;
  String? bookingID;

  @override
  String toString() {
    return "eventName: $eventName, organizer: $organizer, contactID : $contactID, capacity: $capacity, from: ${from.toString()}, to: ${to.toString()} ";
  }
}
