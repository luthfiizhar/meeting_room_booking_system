import 'package:meeting_room_booking_system/model/amenities_class.dart';

class Booking {
  Booking({
    this.bookingId = "",
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
    this.foodAmenities,
    this.daysWeek,
    this.additionalNote,
    this.layoutId = "",
    this.layoutImage = "",
    this.layoutName = "",
    this.monthAbs,
    this.roomType = "MeetingRoom",
  });

  String? bookingId;
  String? roomId;
  String? summary;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  String? recursive;
  int? repeatInterval;
  int? monthAbs;
  String? repeatEndDate;
  String? meetingType;
  String? attendantsNumber;
  String? additionalNote;
  String layoutId;
  String layoutName;
  String layoutImage;
  List? amenities;
  List? attendants;
  List? foodAmenities;
  List? daysWeek;
  String? roomType;

  // Booking.fromJSon(Map<String, dynamic> json)
  //     : roomId = json['RoomID'],
  //       summary = json['Summary'],
  //       description = json['Descriptions'],
  //       startDate = json['StartDate'],
  //       endDate = json['EndDate'],
  //       recursive = json['Recursive'],
  //       repeatInterval = json['RepeatInterval'],
  //       repeatEndDate = json['RepeatEndDate'],
  //       meetingType = json['MeetingType'],
  //       attendantsNumber = json["AttendantsNumber"],
  //       amenities = json['Amenities'],
  //       attendants = json['Attendants'];

  Map<String, dynamic> toJson() => {
        '"RoomID"': '"$roomId"',
        '"Summary"': '"$summary"',
        '"Description"': '"$description"',
        '"StartDate"': '"${startDate.toString().substring(0, 19)}"',
        '"EndDate"': '"${endDate.toString().substring(0, 19)}"',
        '"Recursive"': '"$recursive"',
        '"MonthAbsolute"': monthAbs.toString(),
        '"Days"': daysWeek.toString(),
        '"RepeatInterval"': '$repeatInterval',
        '"RepeatEndDate"': '"$repeatEndDate"',
        '"MeetingType"': '"$meetingType"',
        '"AttendantsNumber"': attendantsNumber,
        '"Amenities"': amenities.toString(),
        '"Attendants"': attendants.toString(),
        '"FoodAmenities"': foodAmenities.toString(),
        '"LayoutId"': layoutId.toString(),
        '"LayoutName"': layoutName.toString(),
        '"LayoutImage"': layoutImage.toString()
      };
}
