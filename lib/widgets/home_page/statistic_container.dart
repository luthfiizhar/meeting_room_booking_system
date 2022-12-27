import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';

class StatPercentage {
  StatPercentage({
    this.status = "",
    this.percentage = 0.0,
    this.color,
  });
  String status;
  double percentage;
  Color? color;
}

class StatisticContainer extends StatefulWidget {
  const StatisticContainer({super.key});

  @override
  State<StatisticContainer> createState() => _StatisticContainerState();
}

class _StatisticContainerState extends State<StatisticContainer> {
  List<StatPercentage> bookingStatus = [];

  List<StatPercentage> eventCreation = [];
  List<Color> colorList = [
    greenAcent,
    orangeAccent,
    violetAccent,
  ];

  @override
  void initState() {
    super.initState();
    // getStatisticDashboard().then((value) {
    //   setState(() {
    //     dynamic listBookStat = value['Data']['BookingStatus'];
    //     dynamic eventCreationStat = value['Data']['EventCreation'];
    //     int i = 0;
    //     for (var element in listBookStat) {
    //       bookingStatus.add(
    //         StatPercentage(
    //           status: element['Status'],
    //           percentage: element['Percentage'],
    //           color: colorList[i],
    //         ),
    //       );
    //       i++;
    //     }
    //     for (var element in eventCreationStat) {
    //       bookingStatus.add(
    //         StatPercentage(
    //           status: element['Status'],
    //           percentage: element['Percentage'],
    //           color: colorList[i],
    //         ),
    //       );
    //       i++;
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // constraints: const BoxConstraints(
      //   maxWidth: 790,
      //   minWidth: 790,
      //   minHeight: 200,
      // ),
      constraints: homeLeftSideConstrains,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: platinum, width: 1),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 35,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '7 Days',
                  style: helveticaText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '30 Days',
                  style: helveticaText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                totalBookingContainer(),
                averageTimeContainer(),
                mostUsedLocation(),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            const Divider(
              color: lightGray,
              thickness: 0.5,
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bookingStatusContainer(),
                eventCreationContainer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget totalBookingContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Booking',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          '2451',
          style: helveticaText.copyWith(
            fontSize: 40,
            fontWeight: FontWeight.w300,
            color: eerieBlack,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          'You are in top 100 user',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
      ],
    );
  }

  Widget averageTimeContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Average Event Time',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
              text: '1.6 ',
              style: helveticaText.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w300,
                color: eerieBlack,
              ),
              children: [
                TextSpan(
                  text: 'Hours',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: eerieBlack,
                  ),
                )
              ]),
        ),
      ],
    );
  }

  Widget mostUsedLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Most Used Location',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          height: 80,
          width: 250,
          padding: const EdgeInsets.only(
            left: 15,
            bottom: 10,
            top: 10,
            right: 15,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/persistance_1.png'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
              opacity: 0.5,
            ),
            color: eerieBlack,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Room 103',
              style: helveticaText.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: white,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget bookingStatusContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Status',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: 400,
          child: bookingStatus.isEmpty
              ? Center(
                  child: Text(
                    'No Data Available',
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: sonicSilver,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 400,
                      height: 46,
                      child: ListView.builder(
                        itemCount: bookingStatus.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          double widthPercent =
                              400.0 * (bookingStatus[index].percentage / 100);
                          return SizedBox(
                            width: widthPercent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: index == 0
                                          ? Radius.circular(5)
                                          : Radius.zero,
                                      topLeft: index == 0
                                          ? Radius.circular(5)
                                          : Radius.zero,
                                      bottomRight:
                                          index == bookingStatus.length - 1
                                              ? Radius.circular(5)
                                              : Radius.zero,
                                      topRight:
                                          index == bookingStatus.length - 1
                                              ? Radius.circular(5)
                                              : Radius.zero,
                                    ),
                                    color: bookingStatus[index].color,
                                  ),
                                  width: widthPercent,
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${bookingStatus[index].percentage} %",
                                  style: helveticaText.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: bookingStatus[index].color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: bookingStatus.map((e) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: e.color,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  e.status,
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget eventCreationContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Creation',
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          width: 250,
          child: eventCreation.isEmpty
              ? Center(
                  child: Text(
                    'No Data Available',
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: sonicSilver,
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 250,
                      height: 46,
                      child: ListView.builder(
                        itemCount: eventCreation.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          double widthPercent =
                              250.0 * (eventCreation[index].percentage / 100);
                          return SizedBox(
                            width: widthPercent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: index == 0
                                          ? Radius.circular(5)
                                          : Radius.zero,
                                      topLeft: index == 0
                                          ? Radius.circular(5)
                                          : Radius.zero,
                                      bottomRight:
                                          index == eventCreation.length - 1
                                              ? Radius.circular(5)
                                              : Radius.zero,
                                      topRight:
                                          index == eventCreation.length - 1
                                              ? Radius.circular(5)
                                              : Radius.zero,
                                    ),
                                    color: eventCreation[index].color,
                                  ),
                                  width: widthPercent,
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${eventCreation[index].percentage} %",
                                  style: helveticaText.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: eventCreation[index].color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: eventCreation.map((e) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: e.color,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  e.status,
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
              ],
            );
          }).toList(),
        )
      ],
    );
  }
}
