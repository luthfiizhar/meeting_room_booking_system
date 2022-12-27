import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:http/http.dart' as http;
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_list_approval_page.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

String apiUrlGlobal = 'fmklg.klgsys.com';
const String tokenDummy =
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJmbWtsZy5rbGdzeXMuY29tIiwiYXVkIjoiZm1rbGcua2xnc3lzLmNvbSIsImlhdCI6MTY2Njc1MzA2MywibmJmIjoxNjY2NzUzMDYzLCJleHAiOjE2NjY3NTY2NjMsImRhdGEiOnsiTklQIjoiMTY0MzY5IiwiTmFtZSI6Ik5JQ08ifX0.e-1g1-DeCEaIO5tro5KaLOfsD8BPgFmrPDVmN_lIa9o';

Future bookingRoom(Booking booking) async {
  // booking.toJson();
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/booking');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  // dynamic bodySend = booking.toJson();
  var bodySend = """
  {
     
      "RoomID": "${booking.roomId}",
      "Summary": "${booking.summary}",
      "AdditionalNotes" : "${booking.additionalNote}",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "Internal",
      "AttendantsNumber": ${booking.attendantsNumber},
      "Amenities": ${booking.amenities},
      "Attendants": ${booking.attendants},
      "FoodAmenities": ${booking.foodAmenities}
  }
  """;

  try {
    print('booking');
    var response = await http.post(url, body: bodySend, headers: requestHeader);

    var data = json.decode(response.body);
    return data;
  } on Error catch (e) {
    return e;
  }
}

Future updateBooking(Booking booking) async {
  // booking.toJson();
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/edit');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  // dynamic bodySend = booking.toJson();
  var bodySend = """
  {
      "BookingID" : "${booking.bookingId}",
      "RoomID": "${booking.roomId}",
      "Summary": "${booking.summary}",
      "AdditionalNotes" : "${booking.additionalNote}",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "Internal",
      "AttendantsNumber": ${booking.attendantsNumber},
      "Amenities": ${booking.amenities},
      "Attendants": ${booking.attendants},
      "FoodAmenities": ${booking.foodAmenities}
  }
  """;

  try {
    var response = await http.put(url, body: bodySend, headers: requestHeader);

    var data = json.decode(response.body);
    return data;
  } on Error catch (e) {
    return e;
  }
}

Future bookingAudi(Booking booking) async {
  // booking.toJson();
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/user/auditorium/booking');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  // dynamic bodySend = booking.toJson();
  var bodySend = """
  {
      "RoomID": "${booking.roomId}",
      "Summary": "${booking.summary}",
      "AdditionalNotes" : "${booking.additionalNote}",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "Internal",
      "AttendantsNumber": ${booking.attendantsNumber},
      "LayoutID" : "${booking.layoutId}",
      "LayoutName" : "${booking.layoutName}",
      "LayoutImage" : "${booking.layoutImage}",
      "Amenities": ${booking.amenities},
      "Attendants": ${booking.attendants},
      "FoodAmenities": ${booking.foodAmenities}
  }
  """;
  print(bodySend);
  try {
    var response = await http.post(url, body: bodySend, headers: requestHeader);

    var data = json.decode(response.body);
    return data;
  } on Error catch (e) {
    return e;
  }
}

Future searchRoomApi(
    String date,
    String startTime,
    String endTime,
    String capacity,
    List amenities,
    String roomType,
    List floor,
    String sort) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/room/search');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
    {
      "RoomType" : "$roomType",
      "StartTime" : "$startTime",
      "EndTime" : "$endTime",
      "Date" : "$date",
      "Capacity" : "$capacity",
      "Sort" : "$sort",
      "Amenities" : $amenities,
      "Area" : $floor
    }
  """;
  print(bodySend);

  try {
    var response = await http.post(url, body: bodySend, headers: requestHeader);
    var data = json.decode(response.body);
    return data;
  } on Error catch (e) {
    return e;
  }
}

// Future getBookingListRoom(
//     String area, String date, RoomEventDataSource events) async {
//   var url =
//       Uri.https(apiUrl, '/MRBS_Backend/public/api/room/booking/list/$area');
//   Map<String, String> requestHeader = {
//     'Authorization': 'Bearer $tokenDummy',
//     // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
//     'Content-Type': 'application/json',
//   };
//   var bodySend = """
//   {
//     "StartDate" : "$date",
//     "EndDate" : "$date"
//   }
//   """;
//   try {
//     var response = await http.post(
//       url,
//       headers: requestHeader,
//       body: bodySend,
//     );

//     var data = json.decode(response.body);
//     print(data);

//     List dataRoom = data['Data'];
//     int length = dataRoom.length;
//     print(dataRoom);
//     for (var i = 0; i < length; i++) {
//       List eventRoom = dataRoom[i]['Bookings'];
//       if (eventRoom.isEmpty) {
//         break;
//       }
//       for (var j = 0; j < eventRoom.length; j++) {
//         events.appointments!.add(
//           Appointment(
//             // subject: ,
//             resourceIds: [dataRoom[i]['RoomID']],
//             startTime: DateTime.parse(eventRoom[j]['StartDateTime']),
//             endTime: DateTime.parse(eventRoom[j]['EndDateTime']),
//           ),
//         );
//       }
//     }
//     return data;
//   } on Error catch (e) {
//     return e;
//   }
// }

Future getAreaList() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/area/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getAreaListWithRooms() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/area/list/room');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getMeetingType() async {
  // var box = await Hive.openBox('userLogin');
  // var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/meeting-type');
  Map<String, String> requestHeader = {
    // 'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future loginDummy(String username, String password) async {
  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/login-dummy');
  Map<String, String> requestHeader = {
    // 'Authorization': 'Bearer $tokenDummy',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
    {
        "Username" : "$username",
        "Password" : "dummy"
    }
  """;

  try {
    var response = await http.post(url, body: bodySend, headers: requestHeader);

    var data = json.decode(response.body);
    var box = await Hive.openBox('userLogin');
    box.put(
        'jwtToken', data['Data']['Token'] != null ? data['Data']['Token'] : "");
    print(response.body);
    return data;
  } on Error catch (e) {
    return e;
  }
}

Future loginCerberus(
    String username, String password, String selectedUser) async {
  String tempUsername;
  String tempPassword;
  var bodySend;
  switch (selectedUser) {
    case "Luthfi":
      tempUsername = "169742.luthfi";
      tempPassword = "Greedisgood2,";
      bodySend = """
  {
        "Username" : "KLGROUP\\\\169742.luthfi",
        "Password" : "GreedisGood2,"
  }
  """;
      break;
    case "Edward":
      tempUsername = "151839.edward";
      tempPassword = "Userhci8*,";
      bodySend = """
  {
        "Username" : "KLGROUP\\\\151839.edward",
        "Password" : "Userhci8*,"
  }
  """;
      break;
    case "Nico":
      tempUsername = "164369.nico";
      tempPassword = "nico123";
      bodySend = """
  {
        "Username" : "KLGROUP\\\\164369.nico",
        "Password" : "164369.nico"
  }
  """;
      break;
    default:
      tempUsername = "169742.luthfi";
      tempPassword = "Greedisgood2,";
  }
  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/login-mrbs-cerberus');
  Map<String, String> requestHeader = {
    'Content-Type': 'application/json',
  };

  // bodySend = """
  // {
  //       "Username" : "KLGROUP\\\\169742.luthfi",
  //       "Password" : "GreedisGood2,"
  // }
  // """;
  print(bodySend);

  try {
    print('try');
    var response = await http.post(url, body: bodySend, headers: requestHeader);

    var data = json.decode(response.body);
    print(data);
    var box = await Hive.openBox('userLogin');
    box.put(
        'jwtToken', data['Data']['Token'] != null ? data['Data']['Token'] : "");
    jwtToken = data['Data']['Token'];
    isTokenValid = true;
    if (data['Data']['Roles']['Admin'] == 1) {
      isAdmin = true;
    }

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future logout() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/logout-cerberus');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.post(url, headers: requestHeader);

    var data = json.decode(response.body);
    if (data['Status'] == "200") {
      jwtToken = "";
      box.put('jwtToken', "");
    }

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future checkToken() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/token');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getAmenitiesList(String roomId) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/user/rooms/amenities/$roomId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getRoomDetail(String roomId) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/room/user/detail/$roomId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getBookingDetail(String bookingId) async {
  print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/$bookingId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future deleteBooking(String bookingId) async {
  print('delete this');
  print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/$bookingId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.delete(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future deleteBookingRecurrent(String bookingId) async {
  print('delete this');
  print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal,
      '/MRBS_Backend/public/api/user/booking/recurrents/$bookingId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.delete(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getMyBookingList(MyListBody body) async {
  print('delete this');
  // print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
  {
    "RoomType" : "${body.roomType}",
    "Keywords" : "${body.keyWords}",
    "MaxRecord" : "${body.max}",
    "PageNumber" : "${body.pageNumber}",
    "OrderBy" : "${body.orderBy}",
    "OrderDir" : "${body.orderDir}"
  }
  """;
  print(bodySend);
  try {
    var response = await http.post(url, headers: requestHeader, body: bodySend);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getAuditoriumApprovalList(ListApprovalBody body) async {
  print('delete this');
  // print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/approval/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
  {
    "RoomType" : "${body.roomType}",
    "Status" : "${body.statusRoom}",
    "Keywords" : "${body.keyWords}",
    "MaxRecord" : "${body.max}",
    "PageNumber" : "${body.pageNumber}",
    "OrderBy" : "${body.orderBy}",
    "OrderDir" : "${body.orderDir}"
  }
  """;
  print(bodySend);
  try {
    var response = await http.post(url, headers: requestHeader, body: bodySend);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getFloorList(SearchTerm body) async {
  // print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/area/table');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
  {
    "Search" : "${body.keyWords}",
    "MaxRecord" : "${body.max}",
    "PageNumber" : "${body.pageNumber}",
    "SortBy" : "${body.orderBy}",
    "SortOrder" : "${body.orderDir}"
  }
  """;
  // print(bodySend);
  try {
    var response = await http.post(url, headers: requestHeader, body: bodySend);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getUserCalendar(String startDate, String endDate) async {
  // print(bookingId);
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/calendar/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
  {
    "StartDate" : "$startDate",
    "EndDate" : "$endDate"
  }
  """;
  // print(bodySend);
  try {
    var response = await http.post(url, headers: requestHeader, body: bodySend);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getRoomType() async {
  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/room/type');
  Map<String, String> requestHeader = {
    'Content-Type': 'application/json',
  };

  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getLayoutList() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/room/layout/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    'Content-Type': 'application/json',
  };

  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getBuildingList() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/building/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getFloorListDropdown() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/area/dropdown/1');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getRoomList(SearchTerm searchTerm) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room/list');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
    {
        "Keywords": "${searchTerm.keyWords}",
        "MaxRecord": "${searchTerm.max}",
        "PageNumber": "${searchTerm.pageNumber}"
    }
  """;
  try {
    var response = await http.post(
      url,
      headers: requestHeader,
      body: bodySend,
    );

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getLinkGoogleAuth() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/google/auth-url');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.post(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future saveTokenGoogle(String token) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/google/save-token');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
    {
        "AuthCode" : "$token"
    }
  """;

  print(bodySend);
  try {
    var response = await http.post(url, headers: requestHeader, body: bodySend);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getAmenitiesListAdmin() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future myBookBookingCount() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/room/type/bookingcount');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future approvalListBookingCount() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/admin/approval/tab-count');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getUserProfile() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/detail');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future approveAuditorium(String bookingId) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal,
      '/MRBS_Backend/public/api/admin/approval/auditorium/accept/$bookingId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.post(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future rejectAuditorium(String bookingId) async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(apiUrlGlobal,
      '/MRBS_Backend/public/api/admin/approval/auditorium/reject/$bookingId');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.post(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getUpcomingEvent() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/dashboard/upcoming-event');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getSchedule() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/dashboard/upcoming-event');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getStatisticDashboard() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/dashboard/statistics');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.post(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}

Future getSuggestAvailableRoom() async {
  var box = await Hive.openBox('userLogin');
  var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  var url = Uri.https(
      apiUrlGlobal, '/MRBS_Backend/public/api/dashboard/available-room');
  Map<String, String> requestHeader = {
    'Authorization': 'Bearer $jwt',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };
  try {
    var response = await http.get(url, headers: requestHeader);

    var data = json.decode(response.body);

    return data;
  } on Error catch (e) {
    return e;
  }
}
