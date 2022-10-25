class Booking {
  Booking({
    this.roomId,
    this.summary,
    this.description,
    this.startDate,
    this.endDate,
    this.recursive,
    this.repeatInterval,
    this.repeatEndDate,
    this.meetingType,
    this.attendantsNumber,
    this.amenities,
    this.attendants,
  });

  String? roomId;
  String? summary;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? recursive;
  String? repeatInterval;
  String? repeatEndDate;
  String? meetingType;
  String? attendantsNumber;
  List? amenities;
  List? attendants;

  Booking.fromJSon(Map<String, dynamic> json)
      : roomId = json['RoomID'],
        summary = json['Summary'],
        description = json['Descriptions'],
        startDate = json['StartDate'],
        endDate = json['EndDate'],
        recursive = json['Recursive'],
        repeatInterval = json['RepeatInterval'],
        repeatEndDate = json['RepeatEndDate'],
        meetingType = json['MeetingType'],
        attendantsNumber = json["AttendantsNumber"],
        amenities = json['Amenities'],
        attendants = json['Attendants'];

  Map<String, dynamic> toJson() => {
        'RoomID': roomId ?? "",
        'Summary': summary ?? "",
        'Description': description ?? "",
        'StartDate': startDate.toString().substring(0, 19),
        'EndDate': endDate.toString().substring(0, 19),
        'Recursive': recursive,
        'RepeatInterval': repeatInterval ?? "",
        'RepeatEndDate': repeatEndDate ?? "",
        'MeetingType': meetingType ?? "",
        'AttendantsNumber': attendantsNumber ?? "",
        'Amenities': amenities ?? [],
        'Attendants': attendants ?? [],
      };
}
