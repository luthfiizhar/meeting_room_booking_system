import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';

class UpcomingEventContainer extends StatefulWidget {
  UpcomingEventContainer({super.key});

  @override
  State<UpcomingEventContainer> createState() => _UpcomingEventContainerState();
}

class _UpcomingEventContainerState extends State<UpcomingEventContainer> {
  List upcomingData = [];

  String emptyMessage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingEvent().then((value) {
      print(value);
      setState(() {
        if (value['Data'] == []) {
          upcomingData = [];
        } else {
          upcomingData = [value['Data']];
        }

        emptyMessage = value['Message'];
      });
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
          upcomingData.isEmpty
              ? SizedBox()
              : Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: upcomingData.first['RoomPhoto'],
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              opacity: upcomingData.isEmpty ? 1 : 0.5,
                              fit: BoxFit.cover,
                            ),
                            color: upcomingData == [] ? white : eerieBlack,
                            borderRadius: BorderRadius.circular(10),
                            border: upcomingData.isEmpty
                                ? Border.all(color: platinum, width: 1)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
          Container(
            height: upcomingData.isEmpty ? 200 : null,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22.5, horizontal: 35),
            decoration: BoxDecoration(
              color: upcomingData == [] ? white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: upcomingData.isEmpty
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
                    color: upcomingData.isEmpty ? eerieBlack : white,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                upcomingData.isEmpty
                    ? Text(
                        'You don\'t have upcoming event.',
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
                                    upcomingData.first['Date']
                                        .toString()
                                        .split(' ')
                                        .last
                                        .toUpperCase(),
                                    style: helveticaText.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: culturedWhite,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    upcomingData.first['Date']
                                        .toString()
                                        .split(' ')
                                        .first
                                        .toUpperCase(),
                                    style: helveticaText.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: culturedWhite,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              const SizedBox(
                                height: 50,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: culturedWhite,
                                ),
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Text(
                                upcomingData.first['Summary'],
                                style: helveticaText.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: culturedWhite,
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
                              Text(
                                '${upcomingData.first['Summary']} at ${upcomingData.first['Duration']} WIB',
                                style: helveticaText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: culturedWhite,
                                ),
                              ),
                              TransparentBorderedWhiteButton(
                                disabled: false,
                                onTap: () {
                                  context.goNamed('detail_event', params: {
                                    'eventId': upcomingData.first['BookingID']
                                  });
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
