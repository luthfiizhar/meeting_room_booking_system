import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';

class RoomFacilityItemDetail extends StatefulWidget {
  RoomFacilityItemDetail({
    super.key,
    this.result,
  });

  dynamic result;

  @override
  State<RoomFacilityItemDetail> createState() => _RoomFacilityItemDetailState();
}

class _RoomFacilityItemDetailState extends State<RoomFacilityItemDetail> {
  bool isHovered = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 15,
        bottom: 5,
      ),
      child: Container(
        height: 165,
        width: 125,
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.network(widget.result!['ImageURL']).image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.result!['AmenitiesName'],
                          style: helveticaText.copyWith(
                            fontSize: 14,
                            color: eerieBlack,
                            fontWeight: FontWeight.w300,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Text(
                        "${widget.result!['Amount']!} Unit",
                        style: helveticaText.copyWith(
                          fontSize: 14,
                          color: davysGray,
                          fontWeight: FontWeight.w300,
                          height: 1.3,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
