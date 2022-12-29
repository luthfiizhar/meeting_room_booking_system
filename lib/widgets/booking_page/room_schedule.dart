import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RoomSchedule extends StatefulWidget {
  RoomSchedule({
    super.key,
    this.selectedDate,
    this.roomId = "",
    this.roomName = "",
  });

  DateTime? selectedDate;
  String? roomId;
  String? roomName;

  @override
  State<RoomSchedule> createState() => _RoomScheduleState();
}

class _RoomScheduleState extends State<RoomSchedule> {
  CalendarController _calendar = CalendarController();

  String today = "";
  bool isDark = true;

  List timeList = [];
  List colors = [
    eerieBlack,
    davysGray,
    sonicSilver,
    spanishGray,
    grayx11,
    lightGray,
    platinum
  ];

  List contoh = ['1', '2', '3', '4', '5', '6', '7', '8'];
  int indexWarna = 0;

  RoomEventDataSource? events =
      RoomEventDataSource(<RoomEvent>[], <CalendarResource>[]);

  initGetSchedule() {
    getRoomSchedule(widget.roomId!,
            DateFormat('yyyy-MM-dd').format(widget.selectedDate!))
        .then((value) async {
      print("RoomSchedule $value");
      dynamic result = value['Data'];
      await setDataToCalendar(result);
      events!.notifyListeners(
          CalendarDataSourceAction.reset, events!.appointments!);
    });
  }

  setDataToCalendar(dynamic result) {
    events!.appointments!.clear();
    setState(() {
      int i = 0;
      for (var element in result) {
        print('loop');
        if (i % 7 == 0) {
          indexWarna = 0;
        }
        if (indexWarna > 3) {
          isDark = false;
        }
        events!.appointments!.add(
          RoomEvent(
            from: DateTime.parse(element['StartDateTime']),
            to: DateTime.parse(element['EndDateTime']),
            background: colors[indexWarna],
            isDark: isDark,
            bookingID: element['BookingID'],
            eventName: element['Summary'],
            resourceIds: [],
          ),
        );
        i++;
        indexWarna++;
      }

      print(events!.appointments!.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    var todayDateTime = DateTime.now();
    today = DateFormat('EEEE, d MMMM y').format(todayDateTime);
    initGetSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 20,
        bottom: 20,
      ),
      height: 500,
      width: 300,
      decoration: BoxDecoration(
        color: culturedWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.roomName} Schedule',
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: eerieBlack,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            today,
            style: helveticaText.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              // color: Colors.blue,
              height: 380,
              child: SfCalendar(
                controller: _calendar,
                onTap: (calendarTapDetails) {
                  if (calendarTapDetails.targetElement ==
                      CalendarElement.calendarCell) {
                    // print(calendarTapDetails.date);
                    // var hour = calendarTapDetails.date!.hour
                    //     .toString()
                    //     .padLeft(2, '0');
                    // var minute = calendarTapDetails.date!.minute
                    //     .toString()
                    //     .padLeft(2, '0');
                    // var startTime = "$hour:$minute";
                    // widget.setStartTime!(startTime);
                    // Navigator.pop(context);
                  }
                },
                appointmentBuilder: appointmentBuilder,
                view: CalendarView.day,
                initialDisplayDate: widget.selectedDate,
                dataSource: events,
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeFormat: 'H:mm',
                  timeInterval: const Duration(minutes: 30),
                  startHour: 5.5,
                  endHour: 19.5,
                  timeIntervalHeight: 75,
                  timeTextStyle: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                headerDateFormat: 'yMMMMd',
                todayHighlightColor: orangeAccent,
                viewNavigationMode: ViewNavigationMode.none,
                headerHeight: 0,
                viewHeaderHeight: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final RoomEvent appointment = calendarAppointmentDetails.appointments.first;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        width: 175,
        decoration: BoxDecoration(
          color: appointment.background,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              appointment.eventName!,
              style: helveticaText.copyWith(
                fontSize: 14,
                color: appointment.isDark ? culturedWhite : eerieBlack,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
