import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:http/http.dart' as http;
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
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
    // 'Content-Type': 'application/json',
  };

  dynamic bodySend = booking.toJson();
  // var bodySend = """
  // {
  //     "RoomID": "${booking.roomId}",
  //     "Summary": "${booking.summary}",
  //     "Description": "${booking.description}",
  //     "StartDate": "${booking.startDate.toString().substring(0, 19)}",
  //     "EndDate": "${booking.endDate.toString().substring(0, 19)}",
  //     "Recursive": "NONE",
  //     "RepeatInterval" : 1,
  //     "Days" : ["0", "6"],
  //     "RepeatEndDate": "2022-10-29",
  //     "MeetingType": "Internal",
  //     "AttendantsNumber": ${booking.attendantsNumber},
  //     "Amenities": [],
  //     "Attendants": []
  // }
  // """;

  print(bodySend);

  try {
    var response = await http.post(url, body: bodySend, headers: requestHeader);

    var data = response.body;
    // print(response.body);
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

Future loginDummy() async {
  var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/login-dummy');
  Map<String, String> requestHeader = {
    // 'Authorization': 'Bearer $tokenDummy',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend = """
    {
        "Username" : "164369",
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

Future loginCerberus() async {
  var url =
      Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/login-mrbs-cerberus');
  Map<String, String> requestHeader = {
    // 'Authorization': 'Bearer $tokenDummy',
    // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
    'Content-Type': 'application/json',
  };

  var bodySend =
      '{"Username" : "KLGROUP\\\\169742.luthfi","Password" : "Greedisgood2."}';
  print(bodySend);

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
