import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/room_booking_dialog.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  CalendarController? calendarControl = CalendarController();
  int? selectedRoom = 1;
  List dataRoom = [];
  List eventRoom = [];

  // String urlApi = apiUrlGlobal;

  Booking bookingDetail = Booking();
  List<Appointment> roomEvents = <Appointment>[];
  List<CalendarResource> resourceCol = <CalendarResource>[];

  RoomEventDataSource? _events;

  setDatePickerStatus(bool value) {}

  resetState() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _events.addListener((p0, p1) {});
    _events = RoomEventDataSource(<Appointment>[], <CalendarResource>[]);
    print('ini init state');
    addResourceRoom().then((_) {
      getBookingListRoom('AR-1', DateTime.now().toString()).then((value) {
        // print(value);
        print('getbooking');
        dataRoom = value['Data'];
        int length = dataRoom.length;
        // print(dataRoom);
        for (var i = 0; i < length; i++) {
          eventRoom = dataRoom[i]['Bookings'];

          for (var j = 0; j < eventRoom.length; j++) {
            _events!.appointments!.add(
              Appointment(
                // subject: ,
                resourceIds: [dataRoom[i]['RoomID']],
                startTime: DateTime.parse(eventRoom[j]['StartDateTime']),
                endTime: DateTime.parse(eventRoom[j]['EndDateTime']),
              ),
            );
          }
        }
        _events!.notifyListeners(
            CalendarDataSourceAction.reset, _events!.appointments!);
        setState(() {});
      });
    });
  }

  // Future<dynamic> getBookingListRoom() async {

  // }
  Future addResourceRoom() async {
    _events!.resources!.add(CalendarResource(
      displayName: 'R. 101',
      id: 'RM-1',
      color: Colors.black54,
    ));
    _events!.resources!.add(CalendarResource(
      displayName: 'R. 102',
      id: 'RM-2',
      color: Colors.black87,
    ));
  }

  Future getBookingListRoom(String area, String date) async {
    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/room/booking/list/$area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $tokenDummy',
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
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);
      // print(data);

      // List dataRoom = data['Data'];
      // int length = dataRoom.length;
      // print(dataRoom);
      // roomEvents.clear();
      // for (var i = 0; i < length; i++) {
      //   List eventRoom = dataRoom[i]['Bookings'];
      //   if (eventRoom.isEmpty) {
      //     break;
      //   }
      //   for (var j = 0; j < eventRoom.length; j++) {
      //     roomEvents.add(
      //       Appointment(
      //         // subject: ,
      //         resourceIds: [dataRoom[i]['RoomID']],
      //         startTime: DateTime.parse(eventRoom[j]['StartDateTime']),
      //         endTime: DateTime.parse(eventRoom[j]['EndDateTime']),
      //       ),
      //     );
      //   }
      // }
      return data;
    } on Error catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 2,
      setDatePickerStatus: setDatePickerStatus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // color: Colors.amber,
            width: 100,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(7),
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                focusColor: eerieBlack,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: eerieBlack, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Color(0xFF929AAB), width: 2)),
                fillColor: graySand,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Color(0xFF929AAB), width: 2)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Lantai 1'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Lantai 2'),
                )
              ],
              onChanged: (value) {
                selectedRoom = int.parse(value.toString());
                setState(() {});
              },
              value: selectedRoom,
            ),
          ),
          calendarRoomPage(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  RoomEventDataSource _getRoomDataSource(
      int selectedRoom, Function resetState) {
    switch (selectedRoom) {
      case 1:
        resourceCol.clear();
        resourceCol.add(CalendarResource(
          displayName: 'R. 101',
          id: 'RM-1',
          color: Colors.black54,
        ));
        resourceCol.add(CalendarResource(
          displayName: 'R. 102',
          id: 'RM-2',
          color: Colors.black87,
        ));
        break;

      case 2:
        resourceCol.clear();
        resourceCol.add(CalendarResource(
          displayName: 'R. 201',
          id: 'RM-3',
          color: Colors.black54,
        ));
        resourceCol.add(CalendarResource(
          displayName: 'R. 202',
          id: 'RM-4',
          color: Colors.black87,
        ));
        resourceCol.add(CalendarResource(
          displayName: 'R. 203',
          id: 'RM-5',
          color: Colors.black54,
        ));
        break;
      default:
    }
    getBookingListRoom('AR-1', DateTime.now().toString()).then((value) {
      resetState;
    });
    // resourceCol.add(CalendarResource(
    //   displayName: 'R. 101',
    //   id: '0001',
    //   color: Colors.transparent,
    // ));
    // resourceCol.add(CalendarResource(
    //   displayName: 'R. 102',
    //   id: '0002',
    //   color: Colors.transparent,
    // ));
    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime.now().add(Duration(hours: 6)),
    //     endTime: DateTime.now().add(Duration(hours: 8)),
    //     subject: 'General Meeting',
    //     color: Colors.red,
    //     resourceIds: ['RM-1'],
    //   ),
    // );

    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime.now().add(Duration(hours: 1)),
    //     endTime: DateTime.now().add(Duration(hours: 5)),
    //     subject: 'General Meeting 2',
    //     color: Colors.blue,
    //     resourceIds: ['RM-2'],
    //   ),
    // );

    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime.now().add(Duration(hours: 3)),
    //     endTime: DateTime.now().add(Duration(hours: 5)),
    //     subject: 'General Meeting 3',
    //     color: Colors.amber,
    //     resourceIds: ['RM-3'],
    //   ),
    // );

    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime.now().add(Duration(hours: 2)),
    //     endTime: DateTime.now().add(Duration(hours: 4)),
    //     subject: 'MRBS',
    //     color: Colors.green,
    //     resourceIds: ['RM-4'],
    //   ),
    // );

    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime.now(),
    //     endTime: DateTime.now(),
    //     subject: 'Weekly Meeting',
    //     color: Colors.amber,
    //     resourceIds: ['RM-5'],
    //   ),
    // );
    return RoomEventDataSource(roomEvents, resourceCol);
  }

  Widget calendarRoomPage() {
    return Container(
      // color: Colors.amber,
      // height: MediaQuery.of(context).size.height - 60,
      // height: 500,
      child: SfCalendar(
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.targetElement == CalendarElement.appointment) {
            // print('Kosong gan');
            Appointment list = calendarTapDetails.appointments![0];
            print(list);
          }
          if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell) {
            print(calendarTapDetails.resource!.id.toString());
            print(calendarTapDetails.date.toString().substring(0, 19));
            bookingDetail.startDate = calendarTapDetails.date;
            bookingDetail.roomId = calendarTapDetails.resource!.id.toString();
            bookingDetail.endDate =
                calendarTapDetails.date!.add(Duration(hours: 2));
            bookingDetail.attendantsNumber = '3';
            bookingDetail.recursive = '';
            bookingDetail.description = 'Test Book !!!!!!!!!!';
            bookingDetail.summary = 'Masih Tes';
            bookingDetail.meetingType = 'Internal';
            bookingDetail.recursive = 'DAILY';
            showDialog(
              context: context,
              builder: (context) => BookingRoomDialog(
                roomId: calendarTapDetails.resource!.id.toString(),
                startDate: calendarTapDetails.date,
                nip: 'HAHAHA',
                bookingDetail: bookingDetail,
              ),
            );
          }
        },
        dataSource: _events, //_getRoomDataSource(selectedRoom!, resetState),
        showDatePickerButton: true,
        showNavigationArrow: true,
        appointmentBuilder: appointmentBuilder,
        view: CalendarView.timelineDay,
        controller: calendarControl,
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: -1,
          timeIntervalWidth: -1,
          // dateFormat: 'd',
          // dayFormat: 'EEE',
          // timeFormat: 'hh:mm',
          startHour: 6,
          // endHour: 24,
        ),
        todayHighlightColor: Colors.black,
        resourceViewSettings: const ResourceViewSettings(
          displayNameTextStyle: TextStyle(color: Colors.white),
          showAvatar: false,
        ),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Appointment appointment =
        calendarAppointmentDetails.appointments.first;

    return Container(
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.subject),
          Text(appointment.resourceIds![0].toString())
        ],
      ),
    );
  }
}
