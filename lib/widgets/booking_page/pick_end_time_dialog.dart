import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PickEndTimeDialog extends StatefulWidget {
  PickEndTimeDialog({
    super.key,
    this.selectedTime,
    this.selectedDate,
    this.startTime,
    this.setEndTime,
  });

  String? selectedTime;
  String? startTime;
  DateTime? selectedDate;
  Function? setEndTime;

  @override
  State<PickEndTimeDialog> createState() => _PickEndTimeDialogState();
}

class _PickEndTimeDialogState extends State<PickEndTimeDialog> {
  CalendarController _calendar = CalendarController();

  String today = "";

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

  Iterable<String> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      // yield TimeOfDay(hour: hour, minute: minute);
      final hourString =
          TimeOfDay(hour: hour, minute: minute).hour.toString().padLeft(2, '0');
      var minuteString = TimeOfDay(hour: hour, minute: minute)
          .minute
          .toString()
          .padLeft(2, '0');

      // if (TimeOfDay(hour: hour, minute: minute)
      //         .minute
      //         .toString()
      //         .padLeft(2, '0') ==
      //     '0') {
      //   minuteString = "00";
      // }
      yield "$hourString:$minuteString";
      minute += step.inMinutes;
      while (minute >= 60) {
        if (minuteString == 60) {
          minute = 0;
        }
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  setStartTime() {
    int minute = TimeOfDay.now().minute;
    int hour = TimeOfDay.now().hour;
    if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
      minute = TimeOfDay.now().replacing(minute: 15).minute;
    } else if (TimeOfDay.now().minute > 15 && TimeOfDay.now().minute <= 30) {
      minute = TimeOfDay.now().replacing(minute: 30).minute;
    } else if (TimeOfDay.now().minute > 30 && TimeOfDay.now().minute <= 45) {
      minute = TimeOfDay.now().replacing(minute: 45).minute;
    } else if (TimeOfDay.now().minute > 45 && TimeOfDay.now().minute <= 60) {
      minute = TimeOfDay.now().replacing(minute: 0).minute;
      hour = hour + 1;
    }
    // else if (TimeOfDay.now().minute > 52) {
    //   minute = TimeOfDay.now().replacing(minute: 0).minute;
    // }
    final startTime = TimeOfDay.now()
        .replacing(hour: hour, minute: minute); //TimeOfDay(hour: 9, minute: 0);
    final endTime = TimeOfDay(hour: 19, minute: 0);
    final step = Duration(minutes: 15);

    timeList = getTimes(startTime, endTime, step).map((tod) => tod).toList();
  }

  var jam = 6;
  bool isDark = true;
  addAppointmen() {
    for (var i = 0; i < contoh.length; i++) {
      if (i % 7 == 0) {
        indexWarna = 0;
      }
      if (indexWarna > 3) {
        isDark = false;
      }
      var start = DateTime(2022, 11, 01, jam, 0);
      var end = start.add(
        Duration(
          minutes: 120,
        ),
      );
      events!.appointments!.add(
        RoomEvent(
          to: end,
          from: start,
          background: colors[indexWarna],
          capacity: 6,
          contactID: 'haha',
          endTimeZone: '',
          eventName: 'meeting ${i + 1}',
          isAllDay: false,
          organizer: 'nip ${i + 1}',
          recurrenceRule: '',
          resourceIds: [''],
          startTimeZone: '',
          isDark: isDark,
        ),
      );
      indexWarna++;
      jam = jam + 2;
    }
    ;
  }

  setEndTime(String start) {
    // int minute = TimeOfDay.now().minute;
    // if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
    //   minute = TimeOfDay.now().replacing(minute: 15).minute;
    // } else if (TimeOfDay.now().minute >= 15 && TimeOfDay.now().minute < 30) {
    //   minute = TimeOfDay.now().replacing(minute: 30).minute;
    // } else if (TimeOfDay.now().minute >= 30 && TimeOfDay.now().minute < 45) {
    //   minute = TimeOfDay.now().replacing(minute: 45).minute;
    // } else if (TimeOfDay.now().minute >= 45 && TimeOfDay.now().minute < 60) {
    //   minute = TimeOfDay.now().replacing(minute: 0).minute;
    // }
    // else if (TimeOfDay.now().minute > 52) {
    //   minute = TimeOfDay.now().replacing(minute: 0).minute;
    // }
    final startTime = TimeOfDay(
        hour: int.parse(start.split(":")[0]),
        minute: int.parse(start.split(":")[1]) +
            15); //TimeOfDay(hour: 9, minute: 0);
    final endTime = TimeOfDay(hour: 19, minute: 0);
    final step = Duration(minutes: 15);

    timeList = getTimes(startTime, endTime, step).map((tod) => tod).toList();

    // print(times);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var todayDateTime = DateTime.now();
    today = DateFormat('EEEE, d MMMM y').format(todayDateTime);
    addAppointmen();
    setEndTime(widget.startTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      backgroundColor: Color.fromARGB(1, 0, 0, 0),
      elevation: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: Stack(
            children: [
              Opacity(
                opacity: 0,
                child: Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 410,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 300,
                          width: 80,
                          decoration: BoxDecoration(
                            color: culturedWhite,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(15),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: ListView.builder(
                              itemCount: timeList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    index == 0 || index == timeList.length
                                        ? const SizedBox()
                                        : const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Divider(
                                              color: davysGray,
                                            ),
                                          ),
                                    InkWell(
                                      onTap: () {
                                        // widget.selectedTime = timeList[index];
                                        widget.setEndTime!(timeList[index]);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        timeList[index],
                                        style: const TextStyle(
                                          color: davysGray,
                                          fontSize: 16,
                                          height: 1.3,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
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
                              const Text(
                                'Room Schedule',
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
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
                                style: const TextStyle(
                                  fontFamily: 'Helvetica',
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
                                    timeSlotViewSettings:
                                        const TimeSlotViewSettings(
                                      timeFormat: 'H:mm',
                                      startHour: 5,
                                      endHour: 20,
                                      timeIntervalHeight: 26,
                                      timeTextStyle: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: davysGray,
                                      ),
                                    ),
                                    headerDateFormat: 'yMMMMd',
                                    todayHighlightColor: eerieBlack,
                                    viewNavigationMode: ViewNavigationMode.none,
                                    headerHeight: 0,
                                    viewHeaderHeight: 0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final RoomEvent appointment = calendarAppointmentDetails.appointments.first;

    return Align(
      alignment: Alignment.centerRight,
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
              style: TextStyle(
                fontFamily: 'Helvetica',
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
