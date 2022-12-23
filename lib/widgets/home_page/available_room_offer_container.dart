import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';

class AvailableRoomContainer extends StatelessWidget {
  AvailableRoomContainer({
    super.key,
    this.roomName = "",
    this.floor = "",
    this.startTime = "",
    this.endTime = "",
  });

  String roomName;
  String floor;
  String startTime;
  String endTime;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
          image: DecorationImage(
            image: AssetImage(
              'assets/103.jpg',
            ),
            filterQuality: FilterQuality.none,
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
          color: eerieBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
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
                'Amphiteatre',
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
                '2nd Floor, 14:00 - 15:15 WIB',
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
                onTap: () {},
                padding: ButtonSize().smallSize(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
