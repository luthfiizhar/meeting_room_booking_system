import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListRoomContainer extends StatelessWidget {
  ListRoomContainer({
    super.key,
    this.roomName,
    this.startTime,
    this.selectedStartTime,
    this.amenities,
    this.duration,
    this.endTime,
    this.selectedEndTime,
    this.maxCapacity,
    this.minCapacity,
    this.photo,
    this.date,
    this.roomID,
    this.roomType,
    this.floor = "",
  });

  String? roomID;
  String? roomName;
  String? startTime;
  String? selectedStartTime;
  String? endTime;
  String? selectedEndTime;
  String? minCapacity;
  String? maxCapacity;
  String? photo;
  List? amenities;
  String? duration;
  String? date;
  String? roomType;
  String? floor;

  @override
  Widget build(BuildContext context) {
    var amen = "";
    if (amenities!.isEmpty) {
      amen = "None";
    } else {
      if (amenities!.length > 1) {
        amen =
            "${amenities![0]['AmenitiesName']} & ${amenities![1]['AmenitiesName']}";
      } else {
        amen = amenities!.first['AmenitiesName'].toString();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Container(
        width: 730,
        height: 210,
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
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 210,
                    maxWidth: 225,
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      // image: DecorationImage(
                      //   // image: NetworkImage(photo!,
                      //   //     headers: {'Content-Type': 'image/jpg'}),
                      //   image:
                      //       Image(image: CachedNetworkImage(imageUrl: photo!))
                      //           .image,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                    child: CachedNetworkImage(
                      width: 225,
                      filterQuality: FilterQuality.none,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      maxHeightDiskCache: 210,
                      maxWidthDiskCache: 225,
                      imageUrl: photo!,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 210,
                          width: 225,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: Image(
                                image: imageProvider,
                              ).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          roomName!,
                          style: const TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 20,
                            height: 1.3,
                            color: eerieBlack,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              MdiIcons.alarm,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$startTime - $endTime',
                                    style: const TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      height: 1.3,
                                      color: davysGray,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Available for $duration',
                                    style: const TextStyle(
                                      fontFamily: 'Helvetica',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      height: 1.3,
                                      color: spanishGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          children: [
                            const Icon(
                              MdiIcons.accountMultipleOutline,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              '$minCapacity - $maxCapacity Person',
                              style: const TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                                color: davysGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            const Icon(
                              MdiIcons.officeBuilding,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              floor!,
                              style: helveticaText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                                color: davysGray,
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            const Icon(
                              MdiIcons.television,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              amen,
                              style: helveticaText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                                color: davysGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: RegularButton(
                text: 'Book',
                disabled: false,
                onTap: () {
                  // context.go('/home/booking');
                  context.pushNamed(
                    'booking_search',
                    params: {
                      "roomId": '$roomID',
                      'date': '$date',
                      'startTime': '$selectedStartTime',
                      'endTime': '$selectedEndTime',
                      'participant': '$maxCapacity',
                      'facilities': '$amenities',
                      'roomType': '$roomType',
                      'isEdit': 'false'
                    },
                    queryParams: {
                      // "roomId": roomID,
                      // "date":date,
                      // "startTime": startTime,
                      // "endTime": endTime,
                    },
                  );
                },
                padding: ButtonSize().smallSize(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
