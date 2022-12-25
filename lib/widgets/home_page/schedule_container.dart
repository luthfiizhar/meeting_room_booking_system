import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

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
  DateTime date = DateTime.now();

  nextDay() {
    setState(() {
      date = date.add(const Duration(days: 1));
    });
  }

  prevDay() {
    setState(() {
      date = date.subtract(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
        minWidth: 350,
        maxHeight: 2000,
      ),
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
        child: SingleChildScrollView(
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
              schedule.isEmpty
                  ? SizedBox(
                      height: 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'You don\'t have schedule for today.',
                          style: helveticaText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: schedule.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 0 : 20,
                                bottom: index != schedule.length - 1 ? 20 : 0,
                              ),
                              child: ScheduleListContainer(
                                index: index,
                                eventName: schedule[index]['eventName'],
                                eventTime: schedule[index]['eventTime'],
                                location: schedule[index]['location'],
                                floor: schedule[index]['floor'],
                                bookingId: schedule[index]['bookingId'],
                                totalParticipant: schedule[index]
                                    ['totalParticipant'],
                              ),
                            ),
                            index != schedule.length - 1
                                ? const Divider(
                                    color: davysGray,
                                    thickness: 0.5,
                                  )
                                : const SizedBox()
                          ],
                        );
                      },
                    ),
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
    this.eventTime = "",
    this.totalParticipant = "",
    this.floor = "",
    this.location = "",
  });

  int? index;
  String bookingId;
  String eventName;
  String totalParticipant;
  String eventTime;
  String location;
  String floor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$eventName ($totalParticipant Person)',
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
                eventTime,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                '$location, $floor',
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
            ],
          ),
          const Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.info_outline,
              color: orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
