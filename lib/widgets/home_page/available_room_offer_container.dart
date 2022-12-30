import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:shimmer/shimmer.dart';

class AvailableRoomContainer extends StatefulWidget {
  AvailableRoomContainer({
    super.key,
  });

  @override
  State<AvailableRoomContainer> createState() => _AvailableRoomContainerState();
}

class _AvailableRoomContainerState extends State<AvailableRoomContainer> {
  String roomName = "";
  String roomId = "";
  String floor = "";
  String startTime = "";
  String endTime = "";
  String photoUrl = "";
  String roomType = "";
  bool isEmpty = true;

  String startTimeBook = "";
  String endTimeBook = "";

  // List availableList = [];

  initTime() {
    dynamic hour = TimeOfDay.now().hour;
    dynamic minute = TimeOfDay.now().minute;
    dynamic endMinute;
    dynamic endHour;
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
    endMinute = minute;
    endHour = hour + 1;
    if (endMinute == 60) {
      endHour = hour;
      endMinute = 0;
    }
    hour = hour.toString().padLeft(2, '0');
    minute = minute.toString().padLeft(2, '0');

    endHour = endHour.toString().padLeft(2, '0');
    endMinute = endMinute.toString().padLeft(2, '0');
    setState(() {
      startTimeBook = "$hour:$minute";
      endTimeBook = "$endHour:$endMinute";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuggestAvailableRoom().then((value) {
      // print(value);
      setState(() {
        if (value['Data'] != []) {
          isEmpty = false;
          roomId = value['Data']['RoomID'];
          roomName = value['Data']['RoomName'];
          floor = value['Data']['AreaName'];
          startTime = value['Data']['Start'];
          endTime = value['Data']['End'];
          photoUrl = value['Data']['RoomImage'];
          roomType = value['Data']['RoomType'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        photoUrl == ""
            ? const Shimmer(
                gradient: LinearGradient(
                  colors: [platinum, grayx11, davysGray],
                ),
                direction: ShimmerDirection.rtl,
                child: SizedBox(
                  width: double.infinity,
                  height: 375,
                ),
              )
            : SizedBox(
                width: double.infinity,
                height: 375,
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: double.infinity,
                      height: 375,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover,
                          // opacity: 0.5,
                        ),
                        // color: eerieBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  },
                ),
              ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 375,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 30,
              left: 25,
              right: 25,
              top: 25,
            ),
            decoration: BoxDecoration(
              color: eerieBlack.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: isEmpty
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Currently Available',
                          style: helveticaText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          roomName,
                          style: helveticaText.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$floor, $startTime - $endTime WIB',
                          style: helveticaText.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TransparentBorderedWhiteButton(
                          text: 'Book Now',
                          onTap: () {
                            String today =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            initTime();
                            context.goNamed(
                              'booking_rooms',
                              params: {
                                'roomId': roomId,
                                'date': today,
                                'startTime': startTimeBook,
                                'endTime': endTimeBook,
                                'participant': '2',
                                'facilities': '[]',
                                'roomType': roomType,
                                'isEdit': 'false',
                              },
                              queryParams: {},
                            );
                          },
                          padding: ButtonSize().smallSize(),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
