import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:http/http.dart' as http;
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/model/user.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_list_approval_page.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'api_url.dart';

class ReqAPI {
  // static const apiUrlGlobal = 'fmklg.klgsys.com'; // Development
  // String apiUrlGlobal = 'fmklg-backend.klgsys.com'; // Production

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
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

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
      var response =
          await http.put(url, body: bodySend, headers: requestHeader);

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
    try {
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);
      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future updateBookingAudi(Booking booking) async {
    // booking.toJson();
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/approval/edit');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    // dynamic bodySend = booking.toJson();
    var bodySend = """
  {
      "BookingID": "${booking.bookingId}",
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
    try {
      var response =
          await http.put(url, body: bodySend, headers: requestHeader);

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
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);
      var data = json.decode(response.body);
      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getBookingListRoom(String area, String date, List listEvent) async {
    // String link = 'fmklg.klgsys.com';
    // String link = 'fmklg-backend.klgsys.com';
    // _events!.appointments!.clear();
    listEvent.clear();
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/room/booking/list/$area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "StartDate" : "$date",
    "EndDate" : "$date"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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

  Future getFacilitiesList() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities');
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

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/area/list/room');
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
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);
      var box = await Hive.openBox('userLogin');
      box.put('jwtToken', data['Data']['Token'] ?? "");
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

  Future loginHCSSO(String username, String password) async {
    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/login-hcsso');
    Map<String, String> requestHeader = {
      // 'Authorization': 'Bearer $tokenDummy',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Username" : "$username",
        "Password" : "$password"
    }
  """;

    try {
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);
      var box = await Hive.openBox('userLogin');
      if (data['Status'].toString() == "200") {
        box.put('jwtToken', data['Data']['Token'] ?? "");
        jwtToken = data['Data']['Token'];
        isTokenValid = true;
        if (data['Data']['Roles']['Admin'] == 1) {
          isAdmin = true;
        }
        // print("LOGIN HCSSO RESPONSE ----> $data");
      }

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

    try {
      var response =
          await http.post(url, body: bodySend, headers: requestHeader);

      var data = json.decode(response.body);
      ;
      var box = await Hive.openBox('userLogin');
      box.put('jwtToken',
          data['Data']['Token'] != null ? data['Data']['Token'] : "");
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

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/logout-cerberus');
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

      // if (data["Status"] != "200") {
      //   isTokenValid = false;
      // }
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

  Future getGoogleRoomDetail(String googleId, String roomId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal,
        '/MRBS_Backend/public/api/user/google/rooms/detail/$googleId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "RoomID" : "$roomId"
    }
    """;

    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getGoogleCalendarUserDetail(String googleId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal,
        '/MRBS_Backend/public/api/user/google/event/detail/$googleId');
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
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAuditoriumApprovalList(ListApprovalBody body) async {
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
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getUserAdminList(SearchTerm body) async {
    // print(bookingId);
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/user/list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
  {
    "Keywords" : "${body.keyWords}",
    "MaxRecord" : "${body.max}",
    "PageNumber" : "${body.pageNumber}",
    "OrderBy" : "${body.orderBy}",
    "OrderDir" : "${body.orderDir}"
  }
  """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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

  Future getLayoutList(String roomId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/room/layout/$roomId');
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

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/admin/area/dropdown/1');
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

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room/list');
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

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/google/auth-url');
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

  Future revokeGoogleAcc() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/revoke/google');
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

    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getAmenitiesListAdmin() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities');
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

  Future getFacilitiesTableList(SearchTerm body) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities-table');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "Keywords": "${body.keyWords}",
      "MaxRecord": "${body.max}",
      "PageNumber": "${body.pageNumber}"
    }
    """;
    // print(bodySend);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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

  Future getContactList(String keyword) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/google/get-contact-list');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Keyword" : "$keyword"
    }
    """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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

  Future updateUserProfile(User user) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/update');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "FullName" : "${user.name}",
        "Email" : "${user.email}",
        "Avaya" : "${user.avaya}",
        "CountryCode" : "${user.phoneCode}",
        "PhoneNumber" : "${user.phoneNumber}"
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

  Future approveAuditorium(String bookingId, String notes) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal,
        '/MRBS_Backend/public/api/admin/approval/auditorium/accept/$bookingId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Notes" : "$notes"
    }
    """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future rejectAuditorium(String bookingId, String notes) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal,
        '/MRBS_Backend/public/api/admin/approval/auditorium/reject/$bookingId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "Notes" : "$notes"
    }
    """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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

  Future getSchedule(String time) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/dashboard/widget');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
  {
      "Date" : "$time"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getStatisticDashboard(String days) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/dashboard/statistics');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
      "Days" : "$days"
    }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

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

  Future startTimeSelector(String roomId, String date) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/start-date');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "RoomID" : "$roomId",
    "Date" : "$date"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future endTimeSelector(String roomId, String date, String startTime) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/end-date');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "RoomID" : "$roomId",
    "Date" : "$date",
    "Start" : "$startTime"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future getRoomSchedule(String roomId, String selectedDate) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/room-schedule');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "RoomID" : "$roomId",
    "Date" : "$selectedDate"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future addNewRoom(Room room) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "RoomName": "${room.roomName}",
    "RoomType": "${room.roomType}",
    "RoomAlias": "${room.roomAlias}",
    "Status": "${room.availability}",
    "AreaID": "${room.floorId}",
    "MinCapacity": ${room.minCapacity},
    "MaxCapacity": ${room.maxCapacity},
    "BookingDuration": ${room.maxBookingDuration},
    "DefaultAmenities": ${room.defaultFacilities},
    "ProhibitedFacilites": ${room.prohibitedFacilities},
    "Photos": ${room.areaPhoto},
    "CoverPhoto": "${room.coverPhoto}"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future editRoom(Room room) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "RoomID": "${room.roomId}",
    "RoomName": "${room.roomName}",
    "RoomType": "${room.roomType}",
    "RoomAlias": "${room.roomAlias}",
    "Status": "${room.availability}",
    "AreaID": "${room.floorId}",
    "MinCapacity": ${room.minCapacity},
    "MaxCapacity": ${room.maxCapacity},
    "BookingDuration": ${room.maxBookingDuration},
    "DefaultAmenities": ${room.defaultFacilities},
    "ProhibitedFacilites": ${room.prohibitedFacilities},
    "Photos": ${room.areaPhoto},
    "CoverPhoto": "${room.coverPhoto}"
  }
  """;
    try {
      var response =
          await http.put(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future adminRoomDetail(String roomId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room/$roomId');
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

  Future addFloor(String areaName, String buildingId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "AreaName" : "$areaName",
    "BuildingID" : "$buildingId"
  }
  """;
    try {
      var response =
          await http.post(url, headers: requestHeader, body: bodySend);

      var data = json.decode(response.body);

      return data;
    } on Error catch (e) {
      return e;
    }
  }

  Future deleteRoom(String roomId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room/$roomId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
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

  Future deleteFloor(String floorId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/area/$floorId');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
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

  //END CLASS REQ API
}

// String apiUrlGlobal = 'fmklg.klgsys.com'; // Development
// String apiUrlGlobal = ''; // Production


