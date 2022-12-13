import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class StartTimeContainer extends StatelessWidget {
  StartTimeContainer({
    this.setStartTimeStatus,
    this.setStartTime,
    this.items,
    this.setInitialEndTime,
    this.isDark = true,
    this.selectedDate,
  });

  // Function? setTime;
  List? items;
  Function? setStartTimeStatus;
  Function? setStartTime;
  Function? setInitialEndTime;
  bool isDark;
  DateTime? selectedDate;
  // String? startTime;
  // String? endTime;

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

  // setStartTime() {
  //   int minute = TimeOfDay.now().minute;
  //   if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
  //     minute = TimeOfDay.now().replacing(minute: 15).minute;
  //   } else if (TimeOfDay.now().minute >= 15 && TimeOfDay.now().minute < 30) {
  //     minute = TimeOfDay.now().replacing(minute: 30).minute;
  //   } else if (TimeOfDay.now().minute >= 30 && TimeOfDay.now().minute < 45) {
  //     minute = TimeOfDay.now().replacing(minute: 45).minute;
  //   } else if (TimeOfDay.now().minute >= 45 && TimeOfDay.now().minute < 60) {
  //     minute = TimeOfDay.now()
  //         .replacing(hour: TimeOfDay.now().hour + 1, minute: 0)
  //         .minute;
  //   }
  //   // else if (TimeOfDay.now().minute > 52) {
  //   //   minute = TimeOfDay.now().replacing(minute: 0).minute;
  //   // }
  //   final startTime = TimeOfDay.now()
  //       .replacing(minute: minute); //TimeOfDay(hour: 9, minute: 0);
  //   final endTime = TimeOfDay(hour: 19, minute: 0);
  //   final step = Duration(minutes: 15);

  //   final times = getTimes(startTime, endTime, step).map((tod) => tod).toList();

  //   print(times);
  // }

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

    final times = getTimes(startTime, endTime, step).map((tod) => tod).toList();

    print(times);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 85,
        maxWidth: 150,
        maxHeight: 300,
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: double.minPositive,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: isDark ? eerieBlack : culturedWhite,
            borderRadius: BorderRadius.circular(10),
            border: isDark
                ? null
                : Border.all(
                    color: lightGray,
                    width: 1,
                  ),
          ),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              itemCount: items!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // onChangeParticipant!(items![index]);
                    // setParticipantStatus!(false);
                    setStartTimeStatus!(false);
                    setStartTime!(items![index]);
                    setInitialEndTime!(items![index + 1]);
                    print(items![index + 1]);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      index == 0 || index == items!.length
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Divider(
                                color: isDark ? platinum : davysGray,
                              ),
                            ),
                      Text(
                        items![index],
                        style: TextStyle(
                          color: isDark ? platinum : davysGray,
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
