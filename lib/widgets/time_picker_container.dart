import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';

class TimePickerContainer extends StatefulWidget {
  TimePickerContainer({
    super.key,
    this.startTimeStatus,
    this.endTimeStatus,
    this.setTime,
    this.startTime,
    this.endTime,
    this.setTimePickerStatus,
    this.setListStartTime,
    this.setStartTimeStatus,
    this.setListEndTime,
    this.setEndTimeStatus,
    this.initialEndTime,
  });

  bool? startTimeStatus;
  bool? endTimeStatus;
  Function? setTime;
  Function? setTimePickerStatus;
  String? startTime;
  String? endTime;
  String? initialEndTime;
  Function? setListStartTime;
  Function? setStartTimeStatus;
  Function? setListEndTime;
  Function? setEndTimeStatus;

  @override
  State<TimePickerContainer> createState() => _TimePickerContainerState();
}

class _TimePickerContainerState extends State<TimePickerContainer> {
  // String startTime = "";
  // String endTime = "";
  TimeOfDay timeNow = TimeOfDay.now();

  List times = [];
  List endTimes = [];

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

    times = getTimes(startTime, endTime, step).map((tod) => tod).toList();

    print(times);
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
        minute:
            int.parse(start.split(":")[1])); //TimeOfDay(hour: 9, minute: 0);
    final endTime = TimeOfDay(hour: 19, minute: 0);
    final step = Duration(minutes: 15);

    endTimes = getTimes(startTime, endTime, step).map((tod) => tod).toList();

    // print(times);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 200,
        maxWidth: 240,
        maxHeight: 100,
        minHeight: 100,
      ),
      child: GestureDetector(
        onTap: () {
          widget.setStartTimeStatus!(false);
          widget.setEndTimeStatus!(false);
        },
        child: Container(
          decoration: BoxDecoration(
            color: culturedWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: lightGray,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text('Time Picker'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            // selectStartTime().then((value) {
                            //   widget.setTime!(widget.startTime, widget.endTime);
                            // });
                            if (widget.startTimeStatus!) {
                              widget.setStartTimeStatus!(false);
                            } else {
                              await setStartTime();

                              widget.setListStartTime!(times);
                              widget.setStartTimeStatus!(true);
                              widget.setEndTimeStatus!(false);
                            }
                          },
                          child: Container(
                            // padding: const EdgeInsets.symmetric(
                            //   vertical: 5,
                            //   horizontal: 5,
                            // ),
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     color: eerieBlack,
                            //     width: 0.5,
                            //   ),
                            //   borderRadius: BorderRadius.circular(15),
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'From',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    // height: 1.2,
                                    color: eerieBlack,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Wrap(
                                  children: [
                                    Text(
                                      widget.startTime != ""
                                          ? widget.startTime!
                                          : '00:00',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        // height: 1.2,
                                        color: davysGray,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 24,
                                      color: eerieBlack,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   child: widget.startTime != ""
                        //       ? InkWell(
                        //           onTap: () {
                        //             selectStartTime();
                        //           },
                        //           child: Text(
                        //             widget.startTime!,
                        //             style: const TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.w300,
                        //               height: 1.3,
                        //               color: davysGray,
                        //             ),
                        //           ),
                        //         )
                        //       : InkWell(
                        //           onTap: () {
                        //             selectStartTime();
                        //           },
                        //           child: const Text(
                        //             'Set start time',
                        //             style: TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.w300,
                        //               height: 1.3,
                        //               color: davysGray,
                        //             ),
                        //           ),
                        //         ),
                        // ),
                        InkWell(
                          onTap: () async {
                            // selectEndTime().then((value) {
                            //   widget.setTime!(widget.startTime, widget.endTime);
                            // });
                            print(widget.initialEndTime);

                            if (widget.endTimeStatus!) {
                              widget.setEndTimeStatus!(false);
                            } else {
                              await setEndTime(widget.initialEndTime!);
                              widget.setStartTimeStatus!(false);
                              widget.setListEndTime!(endTimes);
                              widget.setEndTimeStatus!(true);
                            }
                          },
                          child: Container(
                            // padding: const EdgeInsets.symmetric(
                            //   vertical: 5,
                            //   horizontal: 5,
                            // ),
                            // decoration: BoxDecoration(
                            //   border: Border.all(
                            //     color: eerieBlack,
                            //     width: 0.5,
                            //   ),
                            //   borderRadius: BorderRadius.circular(15),
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'To',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    // height: 1.3,
                                    color: eerieBlack,
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Wrap(
                                  children: [
                                    Text(
                                      widget.endTime != ""
                                          ? widget.endTime!
                                          : '00:00',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        // height: 1.3,
                                        color: davysGray,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 24,
                                      color: eerieBlack,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   child: widget.endTime != ""
                        //       ? InkWell(
                        //           onTap: () {
                        //             selectEndTime();
                        //           },
                        //           child: Text(
                        //             widget.endTime!,
                        //             style: const TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.w300,
                        //               height: 1.3,
                        //               color: davysGray,
                        //             ),
                        //           ),
                        //         )
                        //       : InkWell(
                        //           onTap: () {
                        //             selectEndTime();
                        //           },
                        //           child: const Text(
                        //             'Set end time',
                        //             style: TextStyle(
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.w300,
                        //               height: 1.3,
                        //               color: davysGray,
                        //             ),
                        //           ),
                        //         ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   right: 15,
              //   bottom: 15,
              //   child: TransparentButtonBlack(
              //     text: 'OK',
              //     disabled: widget.startTime! == "" || widget.endTime! == ""
              //         ? true
              //         : false,
              //     onTap: () {
              //       widget.setTime!(widget.startTime, widget.endTime);
              //       widget.setTimePickerStatus!(false);
              //     },
              //     padding: ButtonSize().smallSize(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future selectStartTime() async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: timeNow.replacing(
          hour: timeNow.hour + 1,
          minute: 0,
        ),
        helpText: 'START TIME',
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: eerieBlack,
                onPrimary: silver,
                onSurface: eerieBlack,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: eerieBlack,
                ),
              ),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        });
    if (picked_s != null) {
      final hour = picked_s.hour.toString().padLeft(2, '0');
      final minute = picked_s.minute.toString().padLeft(2, '0');
      setState(() {
        // startTime = picked_s;
        widget.startTime = "$hour:$minute";
      });
    }
  }

  Future selectEndTime() async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: timeNow.replacing(
          hour: timeNow.hour + 2,
          minute: 0,
        ),
        helpText: 'END TIME',
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: eerieBlack,
                onPrimary: silver,
                onSurface: eerieBlack,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: eerieBlack,
                ),
              ),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        });
    if (picked_s != null) {
      final hour = picked_s.hour.toString().padLeft(2, '0');
      final minute = picked_s.minute.toString().padLeft(2, '0');
      setState(() {
        // startTime = picked_s;
        widget.endTime = "$hour:$minute";
      });
    }
  }
}
