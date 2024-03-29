import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:http/http.dart' as http;
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/model/user.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_list_approval_page.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/event_menu_page/event_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/user_admin_page/user_admin_page.dart';
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
      "DisplayPhoneNumber" : ${booking.displayPhoneNumber},
      "Avaya" : "${booking.avaya}",
      "PhoneNumber" : "${booking.phoneNumber}",
      "Code" : "${booking.phoneCode}",
      "AdditionalNotes" : "${booking.additionalNote}",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "${booking.meetingType}",
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
      "DisplayPhoneNumber" : ${booking.displayPhoneNumber},
      "Avaya" : "${booking.avaya}",
      "PhoneNumber" : "${booking.phoneNumber}",
      "Code" : "${booking.phoneCode}",
      "AdditionalNotes" : "${booking.additionalNote}",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "${booking.meetingType}",
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
      "DisplayPhoneNumber" : ${booking.displayPhoneNumber},
      "Avaya" : "${booking.avaya}",
      "PhoneNumber" : "${booking.phoneNumber}",
      "Code" : "${booking.phoneCode}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "${booking.meetingType}",
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

  Future validatePhoneDialog(
      String avaya, String phoneNumber, String phoneCode) async {
    // booking.toJson();
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/validate-phone');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    // dynamic bodySend = booking.toJson();
    var bodySend = """
  {
    "Avaya" : "$avaya",
    "PhoneNumber" : "$phoneNumber",
    "Code" : "$phoneCode"
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
      "DisplayPhoneNumber" : ${booking.displayPhoneNumber},
      "Avaya" : "${booking.avaya}",
      "PhoneNumber" : "${booking.phoneNumber}",
      "Code" : "${booking.phoneCode}",
      "AdditionalNotes" : "${booking.additionalNote}",
      "Description": "${booking.description}",
      "StartDate": "${booking.startDate.toString().substring(0, 19)}",
      "EndDate": "${booking.endDate.toString().substring(0, 19)}",
      "Recursive": "${booking.recursive}",
      "MonthAbsolute": ${booking.monthAbs},
      "RepeatInterval" : ${booking.repeatInterval},
      "Days" : ${booking.daysWeek},
      "RepeatEndDate": "${booking.repeatEndDate}",
      "MeetingType": "${booking.meetingType}",
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

  Future getBookingListRoom(String area, String date) async {
    // String link = 'fmklg.klgsys.com';
    // String link = 'fmklg-backend.klgsys.com';
    // _events!.appointments!.clear();
    // listEvent.clear();
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
    // on HttpException catch (e) {
    //   return e;
    // }
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

  Future addFacilities(Amenities facilities) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "AmenitiesName" : "${facilities.amenitiesName}",
      "Type" : "${facilities.type}",
      "Category" : "${facilities.category}",
      "Option" : ${facilities.isAvailableToUser},
      "Photo" : "${facilities.photo}"
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

  Future getFacilityCategory() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities-category');
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

  Future updateFacility(Amenities facilities) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "AmenitiesID" : "${facilities.amenitiesId}",
      "AmenitiesName" : "${facilities.amenitiesName}",
      "Category" : "${facilities.category}",
      "Type" : "${facilities.type}",
      "Option" : ${facilities.isAvailableToUser},
      "Photo" : "${facilities.photo}"
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

  Future getFloorListDropdown(String buildingId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal,
        '/MRBS_Backend/public/api/admin/area/dropdown/$buildingId');
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
        "PageNumber": "${searchTerm.pageNumber}",
        "SortBy": "${searchTerm.orderBy}",
        "SortOrder": "${searchTerm.orderDir}"
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

  Future getAmenitiesType() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities-type');
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
    print(bodySend);
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
        "PhoneNumber" : "${user.phoneNumber}",
        "DisplayPhoneNumber" : ${user.phoneOptions}
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
    "PrimaryRoom" : ${room.isPrimary},
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
    "PrimaryRoom" : ${room.isPrimary},
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

  Future deleteFacilities(String facilitiesId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/admin/amenities/$facilitiesId');
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

  Future getUserRoleList() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/admin/user/role/list');
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

  Future addUserAdmin(UserAdmin userAdmin) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/user');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "NIP" : "${userAdmin.nip}",
        "Name" : "${userAdmin.name}",
        "CountryCode" : "${userAdmin.phoneCode}",
        "PhoneNumber" : "${userAdmin.phoneNumber}",
        "BuildingID" : "${userAdmin.buildingId}",
        "Role" : ${userAdmin.roleList},
        "Email" : "${userAdmin.email}"
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

  Future updateUserAdmin(UserAdmin userAdmin) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/user-edit');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
        "NIP" : "${userAdmin.nip}",
        "Name" : "${userAdmin.name}",
        "CountryCode" : "${userAdmin.phoneCode}",
        "PhoneNumber" : "${userAdmin.phoneNumber}",
        "BuildingID" : "${userAdmin.buildingId}",
        "Role" : ${userAdmin.roleList},
        "Email" : "${userAdmin.email}"
    }
    """;
    try {
      var response = await http.put(
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

  Future deleteUserAdmin(String nip) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/user/$nip');
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

  Future getEventSettings() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/settings');
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

  Future setEventSettings(SettingEvent setting) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/settings');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "StartHour": "${setting.startHour}",
      "EndHour": "${setting.endHour}",
      "BookingMinDuration": ${setting.bookingMinDuration},
      "BookingMaxDuration": ${setting.bookingMaxDuration},
      "AudiMinDuration": ${setting.audiMinDuration},
      "AudiMaxDuration": ${setting.audiMaxDuration},
      "SocHubMinDuration": ${setting.socHubMinDuration},
      "SocHubMaxDuration": ${setting.socHubMaxDuration},
      "CanteenMinDuration": ${setting.canteenMinDuration},
      "CanteenMaxDuration": ${setting.canteenMaxDuration},
      "RecurrentNumber": ${setting.reccurentNumber}
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

  Future setCapacityArea(List<Room> room) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/room/capacity');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "Rooms": $room
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

  Future sendFeedback(int rating, String comment) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/feedback');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "Rating" : $rating,
      "Comment" : "$comment"
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

  Future sendBugReport(String description, List photo) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/bug-report');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "Description" : "$description",
      "Photo" : $photo
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

  Future feedbackStatus() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/feedback/popup');
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

  Future feedbackList(SearchTerm searchTerm) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/feedback');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "Keywords": "",
      "MaxRecord": "${searchTerm.max}",
      "PageNumber": "${searchTerm.pageNumber}",
      "SortBy": "${searchTerm.orderBy}",
      "SortOrder": "${searchTerm.orderDir}",
      "Rating": ${searchTerm.rating}
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

  Future bugList(SearchTerm searchTerm) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/bug-report');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      'Content-Type': 'application/json',
    };

    var bodySend = """
    {
      "Keywords": "${searchTerm.keyWords}",
      "MaxRecord": "${searchTerm.max}",
      "PageNumber": "${searchTerm.pageNumber}",
      "SortBy": "${searchTerm.orderBy}",
      "SortOrder": "${searchTerm.orderDir}",
      "Status": "${searchTerm.status}"
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

  Future bugTabCount() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/bug-tab');
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

  Future solveBug(String reportId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/bug-solve');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
      "ReportID" : "$reportId"
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

  Future userEvents(String value) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/trigger');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
        "Value" : "$value"
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

  Future userConfirmEventContinue(String bookingId) async {
    // var box = await Hive.openBox('userLogin');
    // var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/booking/confirm');
    Map<String, String> requestHeader = {
      // 'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
        "BookingID" : "$bookingId"
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

  Future userConfirmEventCancel(String bookingId) async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/user/booking/reject');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
    {
        "BookingID" : "$bookingId"
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

  Future getRoomTypeAdmin() async {
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
    var url =
        Uri.https(apiUrlGlobal, '/MRBS_Backend/public/api/admin/type/room');
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
  //END CLASS REQ API
}

// String apiUrlGlobal = 'fmklg.klgsys.com'; // Development
// String apiUrlGlobal = ''; // Production


