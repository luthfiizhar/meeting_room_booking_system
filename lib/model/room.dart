import 'package:flutter/material.dart';

class Room {
  Room({
    this.id,
    this.displayName,
    this.color,
    this.roomId,
    this.areaId,
    this.roomName,
    this.roomType,
    this.capacity,
    this.bookingDuration,
    this.availability,
  });

  String? id;
  String? displayName;
  Color? color;
  String? roomId;
  String? areaId;
  String? roomName;
  String? roomType;
  String? capacity;
  String? bookingDuration;
  bool? availability;
}
