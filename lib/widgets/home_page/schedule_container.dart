import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'dart:html' as html;

class ScheduleContainer extends StatefulWidget {
  ScheduleContainer({super.key});

  @override
  State<ScheduleContainer> createState() => _ScheduleContainerState();
}

class _ScheduleContainerState extends State<ScheduleContainer> {
  List schedule = [
    // {
    //   'eventName': 'RAKER FBI',
    //   'totalParticipant': '90',
    //   'eventTime': '08:00 - 11:30 WIB',
    //   'location': 'Auditorium 3',
    //   'floor': '3rd Floor',
    //   'bookingId': '',
    // },
    // {
    //   'eventName': 'Creative Meeting Marketing ACE',
    //   'totalParticipant': '',
    //   'eventTime': '10:00 - 12:00 WIB',
    //   'location': 'Amphiteatre',
    //   'floor': '3rd Floor',
    //   'bookingId': '',
    // },
  ];
  bool isLoading = true;
  DateTime date = DateTime.now();

  nextDay() {
    setState(() {
      isLoading = true;
      date = date.add(const Duration(days: 1));
      initGetSchedule();
    });
  }

  prevDay() {
    setState(() {
      isLoading = true;
      date = date.subtract(const Duration(days: 1));
      initGetSchedule();
    });
  }

  initGetSchedule() {
    // setState(() {
    //   isLoading = true;
    // });
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    getSchedule(formattedDate).then((value) {
      print("Schedule Result $value");
      if (value['Status'].toString() == "200") {
        setState(() {
          isLoading = false;
          schedule = value['Data'];
        });
      } else {}
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error fetching schedule data!',
            maxLines: 1,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initGetSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
        minWidth: 350,
        maxHeight: 2000,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: platinum,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Schedule',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy').format(date),
                        style: helveticaText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: eerieBlack,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          nextDay();
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_up_sharp,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          prevDay();
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    )
                  : schedule.isEmpty
                      ? SizedBox(
                          height: 200,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'You don\'t have schedule for this Day.',
                              textAlign: TextAlign.center,
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                                height: 1.3,
                              ),
                            ),
                          ),
                        )
                      : Builder(builder: (context) {
                          return Column(
                            children: schedule
                                .asMap()
                                .map((index, element) {
                                  return MapEntry(
                                    index,
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: index == 0 ? 0 : 20,
                                            bottom: index != schedule.length - 1
                                                ? 20
                                                : 0,
                                          ),
                                          child: ScheduleListContainer(
                                            index: index,
                                            eventName: element['Summary'],
                                            duration: element['Duration'],
                                            location: element['RoomName'],
                                            floor: element['AreaName'],
                                            bookingId: element['BookingID'],
                                          ),
                                        ),
                                        index != schedule.length - 1
                                            ? const Divider(
                                                color: davysGray,
                                                thickness: 0.5,
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                            // children: schedule.map((element) {
                            //   return Column(
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.only(
                            //           top: index == 0 ? 0 : 20,
                            //           bottom:
                            //               index != schedule.length - 1 ? 20 : 0,
                            //         ),
                            //         child: ScheduleListContainer(
                            //           index: index,
                            //           eventName: element['Summary'],
                            //           duration: element['Duration'],
                            //           location: element['RoomName'],
                            //           floor: element['AreaName'],
                            //           bookingId: element['BookingID'],
                            //         ),
                            //       ),
                            //       index != schedule.length - 1
                            //           ? const Divider(
                            //               color: davysGray,
                            //               thickness: 0.5,
                            //             )
                            //           : const SizedBox()
                            //     ],
                            //   );
                            // }).toList(),
                          );
                        }),
              // ListView.builder(
              //     physics: AlwaysScrollableScrollPhysics(),
              //     itemCount: schedule.length,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       return Column(
              //         children: [
              //           Padding(
              //             padding: EdgeInsets.only(
              //               top: index == 0 ? 0 : 20,
              //               bottom:
              //                   index != schedule.length - 1 ? 20 : 0,
              //             ),
              //             child: ScheduleListContainer(
              //               index: index,
              //               eventName: schedule[index]['Summary'],
              //               duration: schedule[index]['Duration'],
              //               location: schedule[index]['RoomName'],
              //               floor: schedule[index]['AreaName'],
              //               bookingId: schedule[index]['BookingID'],
              //             ),
              //           ),
              //           index != schedule.length - 1
              //               ? const Divider(
              //                   color: davysGray,
              //                   thickness: 0.5,
              //                 )
              //               : const SizedBox()
              //         ],
              //       );
              //     },
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleListContainer extends StatelessWidget {
  ScheduleListContainer({
    super.key,
    this.index,
    this.bookingId = "",
    this.eventName = "",
    this.startTime = "",
    this.endTime = "",
    this.floor = "",
    this.location = "",
    this.duration = "",
  });

  int? index;
  String bookingId;
  String eventName;
  String startTime;
  String endTime;
  String location;
  String floor;
  String duration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (bookingId != "-") {
          context.goNamed(
            'detail_event',
            params: {
              "eventId": bookingId,
            },
          );
        } else {
          html.window.open('http://calendar.google.com', '');
        }
      },
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: orangeAccent,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '$duration WIB',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                bookingId == "-"
                    ? const SizedBox()
                    : Text(
                        '$location, $floor',
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: bookingId == "-"
                  ? InkWell(
                      onTap: () {
                        html.window.open('http://calendar.google.com', '');
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_right_sharp,
                        color: orangeAccent,
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        if (bookingId != "-") {
                          context.goNamed(
                            'detail_event',
                            params: {
                              "eventId": bookingId,
                            },
                          );
                        }
                      },
                      child: const Icon(
                        Icons.info_outline,
                        color: orangeAccent,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
