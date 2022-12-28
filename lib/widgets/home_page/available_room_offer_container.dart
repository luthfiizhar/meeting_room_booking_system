import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';

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

  // List availableList = [];

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
            ? const SizedBox()
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
              color: eerieBlack.withOpacity(0.6),
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
                            DateTime today = DateTime.now();
                            context.goNamed(
                              'booking_room',
                              params: {
                                'eventId': roomId,
                              },
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
