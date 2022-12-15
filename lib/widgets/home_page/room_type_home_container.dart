import "package:flutter/material.dart";
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class RoomTypeContainerHomePage extends StatelessWidget {
  RoomTypeContainerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: platinum,
          width: 1,
        ),
        color: white,
      ),
      child: Row(
        children: [
          choices('Meeting Room', ''),
          const SizedBox(
            width: 20,
          ),
          choices('Auditorium', ''),
          const SizedBox(
            width: 20,
          ),
          choices('Social Hub', ''),
        ],
      ),
    );
  }

  Widget choices(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }
}
