import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'dart:html' as html;

class UpcomingEventContainer extends StatefulWidget {
  UpcomingEventContainer({super.key});

  @override
  State<UpcomingEventContainer> createState() => _UpcomingEventContainerState();
}

class _UpcomingEventContainerState extends State<UpcomingEventContainer> {
  ReqAPI apiReq = ReqAPI();
  List upcomingData = [];

  String emptyMessage = "";

  String bookingId = "";
  String roomName = "";
  String floor = "";
  String roomPhoto = "";
  String date = "";
  String summary = "";
  String duration = "";

  bool isEmpty = true;

  @override
  void initState() {
    super.initState();
    apiReq.getUpcomingEvent().then((value) {
      // print("Upcoming Result $value");
      if (value['Status'].toString() == "200") {
        if (value['Data'].toString() == "[]") {
          // print('if upcoming kosong');
          setState(() {
            isEmpty = true;
            emptyMessage = value['Message'];
          });
        } else {
          // print('if upcoming ada');
          setState(() {
            isEmpty = false;
            upcomingData = [value['Data']];
            bookingId = value['Data']['BookingID'];
            roomName = value['Data']['RoomName'];
            date = value['Data']['Date'];
            summary = value['Data']['Summary'];
            duration = value['Data']['Duration'];
            roomPhoto = value['Data']['RoomPhoto'];
            floor = value['Data']['AreaName'];
          });
        }
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    }).onError((error, stackTrace) {
      setState(() {
        isEmpty = true;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // constraints: const BoxConstraints(
      //   maxWidth: 780,
      //   minWidth: 780,
      //   maxHeight: 200,
      //   minHeight: 200,
      // ),
      constraints: homeLeftSideConstrains,
      child: Stack(
        children: [
          isEmpty
              ? const SizedBox()
              : bookingId == "-"
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: roomPhoto,
                          errorWidget: (context, url, error) {
                            return Text(error.toString());
                          },
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  opacity: isEmpty ? 1 : 0.5,
                                  fit: BoxFit.cover,
                                ),
                                color: isEmpty ? white : eerieBlack,
                                borderRadius: BorderRadius.circular(10),
                                border: isEmpty
                                    ? Border.all(color: platinum, width: 1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
          Container(
            height: isEmpty ? 200 : null,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22.5, horizontal: 35),
            decoration: BoxDecoration(
              color: isEmpty
                  ? white
                  : bookingId == "-"
                      ? white
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isEmpty
                  ? Border.all(color: platinum, width: 1)
                  : bookingId == "-"
                      ? Border.all(color: platinum, width: 1)
                      : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Upcoming Event',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: upcomingData.isEmpty
                        ? eerieBlack
                        : bookingId == "-"
                            ? eerieBlack
                            : white,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                isEmpty
                    ? Text(
                        "No Upcoming Event.",
                        style: helveticaText.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: eerieBlack,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    date
                                        .toString()
                                        .split(' ')
                                        .last
                                        .toUpperCase(),
                                    style: helveticaText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: bookingId == "-"
                                          ? eerieBlack
                                          : culturedWhite,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    date
                                        .toString()
                                        .split(' ')
                                        .first
                                        .toUpperCase(),
                                    style: helveticaText.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: bookingId == "-"
                                          ? eerieBlack
                                          : culturedWhite,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              SizedBox(
                                height: 50,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: bookingId == "-"
                                      ? eerieBlack
                                      : culturedWhite,
                                ),
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Expanded(
                                child: Text(
                                  summary,
                                  style: helveticaText.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: bookingId == "-"
                                        ? orangeAccent
                                        : culturedWhite,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              bookingId != "-"
                                  ? Text(
                                      bookingId == "-"
                                          ? '$duration WIB'
                                          : '$roomName at $duration WIB',
                                      style: helveticaText.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color: bookingId == "-"
                                            ? eerieBlack
                                            : culturedWhite,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookingId == "-"
                                              ? '$duration WIB'
                                              : '$roomName at $duration WIB',
                                          style: helveticaText.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                            color: bookingId == "-"
                                                ? eerieBlack
                                                : culturedWhite,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Event from Google Calendar',
                                          style: helveticaText.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            color: bookingId == "-"
                                                ? eerieBlack
                                                : culturedWhite,
                                          ),
                                        )
                                      ],
                                    ),
                              bookingId == "-"
                                  ? TransparentBorderedBlackButton(
                                      disabled: false,
                                      onTap: () {
                                        html.window.open(
                                            'http://calendar.google.com', '');
                                      },
                                      text: 'See Details',
                                      padding: ButtonSize().mediumSize(),
                                    )
                                  : TransparentBorderedWhiteButton(
                                      disabled: false,
                                      onTap: () {
                                        context.goNamed('detail_event',
                                            params: {'eventId': bookingId});
                                      },
                                      text: 'See Details',
                                      padding: ButtonSize().mediumSize(),
                                    )
                            ],
                          ),
                        ],
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
