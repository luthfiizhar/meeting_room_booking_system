import 'package:flutter/material.dart';

class Event {
  Event({
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
  });

  //required for calendar -> from & to
  DateTime? from;
  DateTime? to;

  String? eventName;
  String? organizer;
  String? contactID;
  int? capacity;

  Color? background;
  bool? isAllDay;
  String? startTimeZone;
  String? endTimeZone;
  String? recurrenceRule;

  String? MeetingID;
  String? roomID;
  String? icalUID;
  String? employeeNip;
  String? employeeName;
  String? summary;
  String? description;
  String? bookingType;
  String? meetingType;

  //audi
  int? attendantsNumber;
  bool? foodAmenities;
  String? layoutName;
  String? layoutImg;

  @override
  String toString() {
    return "eventName: $eventName";
  }
}
