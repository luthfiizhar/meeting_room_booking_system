import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';

class DetailEventPage extends StatefulWidget {
  const DetailEventPage({super.key});

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {
  resetStatus(bool value) {}
  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 0,
      setDatePickerStatus: resetStatus,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 1400,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 1100,
                height: 400,
                decoration: BoxDecoration(
                  color: graySand,
                  borderRadius: BorderRadius.circular(10),
                  // image: DecorationImage(
                  //   image:
                  //       AssetImage('assets/social_hub.jpg'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              right: 183,
              // alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.blue,
                width: 1000,
                // height: 1000,
                child: Column(
                  children: const [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
