import 'package:cached_network_image/cached_network_image.dart';
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

  String totalBooking = "";
  String averageTime = "";
  String mostUsedName = "";
  String mostUsedPhoto = "";

  onFilterChange(String value) {
    bookingStatus.clear();
    eventCreation.clear();
    initStatistic(value);
  }

  initStatistic(String day) {
    getStatisticDashboard(day).then((value) {
      dynamic result = value['Data'];
      dynamic listBookStat = result['BookingStatus'];
      dynamic eventCreationStat = result['EventCreation'];
      setState(() {
        totalBooking = result['TotalBooking'].toString();
        averageTime = result['AverageHours'].toString();
        mostUsedName = result['MostUsedRoom']['RoomName'];
        mostUsedPhoto = result['MostUsedRoom']['ImageURL'];
      });
      int i = 0;
      for (var element in listBookStat) {
        setState(() {
          bookingStatus.add(
            StatPercentage(
              status: element['Status'],
              percentage: element['Percentage'],
              color: colorList[i],
            ),
          );
        });

        i++;
      }
      int j = 0;
      for (var element in eventCreationStat) {
        setState(() {
          eventCreation.add(
            StatPercentage(
              status: element['Status'],
              percentage: element['Percentage'],
              color: colorList[j],
            ),
          );
        });
        j++;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initStatistic("30");
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // constraints: const BoxConstraints(
      //   maxWidth: 790,
      //   minWidth: 790,
      //   minHeight: 200,
      // ),
      constraints: homeLeftSideConstrains.copyWith(maxHeight: 380),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterTextStatistic(changeFilterDay: onFilterChange),
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
          totalBooking,
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
          '',
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
              text: '$averageTime ',
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
          child: mostUsedPhoto == ""
              ? SizedBox()
              : CachedNetworkImage(
                  imageUrl: mostUsedPhoto,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                        top: 10,
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                          opacity: 0.6,
                        ),
                        color: eerieBlack,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          mostUsedName,
                          style: helveticaText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: white,
                          ),
                        ),
                      ),
                    );
                  },
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
                                      bottomLeft:
                                          index == 0 || widthPercent == 400
                                              ? const Radius.circular(5)
                                              : Radius.zero,
                                      topLeft: index == 0 || widthPercent == 400
                                          ? const Radius.circular(5)
                                          : Radius.zero,
                                      bottomRight:
                                          index == bookingStatus.length - 1 ||
                                                  widthPercent == 400
                                              ? const Radius.circular(5)
                                              : Radius.zero,
                                      topRight:
                                          index == bookingStatus.length - 1 ||
                                                  widthPercent == 400
                                              ? const Radius.circular(5)
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
                                SizedBox(
                                  width: widthPercent,
                                  child: Text(
                                    "${bookingStatus[index].percentage} %",
                                    style: helveticaText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: bookingStatus[index].color,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft:
                                            index == 0 || widthPercent == 250
                                                ? const Radius.circular(5)
                                                : Radius.zero,
                                        topLeft:
                                            index == 0 || widthPercent == 250
                                                ? const Radius.circular(5)
                                                : Radius.zero,
                                        bottomRight:
                                            index == eventCreation.length - 1 ||
                                                    widthPercent == 250
                                                ? const Radius.circular(5)
                                                : Radius.zero,
                                        topRight:
                                            index == eventCreation.length - 1 ||
                                                    widthPercent == 250
                                                ? const Radius.circular(5)
                                                : Radius.zero,
                                      ),
                                      color: eventCreation[index].color,
                                    ),
                                    width: widthPercent,
                                    height: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${eventCreation[index].percentage} %",
                                  overflow: TextOverflow.ellipsis,
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

class FilterTextStatistic extends StatefulWidget {
  FilterTextStatistic({
    super.key,
    this.changeFilterDay,
  });
  Function? changeFilterDay;
  String? filterName;

  @override
  State<FilterTextStatistic> createState() => _FilterTextStatisticState();
}

class _FilterTextStatisticState extends State<FilterTextStatistic> {
  String selectedFilter = "30 Days";

  onHighlight(String value) {
    switch (value) {
      case "7 Days":
        changeHighlight("7 Days");
        widget.changeFilterDay!("7");
        break;
      case "30 Days":
        changeHighlight("30 Days");
        widget.changeFilterDay!("30");
        break;
      default:
    }
  }

  void changeHighlight(String value) {
    setState(() {
      selectedFilter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          FilterTextStatisticItem(
            title: "7 Days",
            selected: selectedFilter == "7 Days",
            onHighlight: onHighlight,
          ),
          const SizedBox(
            width: 10,
          ),
          FilterTextStatisticItem(
            title: "30 Days",
            selected: selectedFilter == "30 Days",
            onHighlight: onHighlight,
          )
        ],
      ),
    );
  }
}

class FilterTextStatisticItem extends StatelessWidget {
  FilterTextStatisticItem({
    super.key,
    this.title,
    this.selected,
    this.onHighlight,
  });

  final String? title;
  final bool? selected;
  final Function? onHighlight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onHighlight!(title!);
      },
      child: FilterStatisticItemText(
        name: title,
        selected: selected,
      ),
    );
  }
}

class FilterStatisticItemText extends StatefulWidget {
  FilterStatisticItemText({
    super.key,
    this.name,
    this.selected,
  });
  String? name;
  bool? selected;

  @override
  State<FilterStatisticItemText> createState() =>
      _FilterStatisticItemTextState();
}

class _FilterStatisticItemTextState extends State<FilterStatisticItemText> {
  bool _hovering = false;

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Text(
        widget.name!,
        style: helveticaText.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: widget.selected! ? davysGray : spanishGray),
      ),
    );
  }
}
