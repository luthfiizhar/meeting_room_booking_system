import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class GreetingContainer extends StatefulWidget {
  const GreetingContainer({super.key});

  @override
  State<GreetingContainer> createState() => _GreetingContainerState();
}

class _GreetingContainerState extends State<GreetingContainer> {
  String name = "";
  checkData() async {
    var box = await Hive.openBox('userLogin');

    name = box.get('name');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 780,
        minWidth: 780,
        maxHeight: 200,
        minHeight: 200,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platinum,
            width: 1,
          ),
        ),
        // height: 200,
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Clock(),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Good Morning,',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Luthfi Izhariman',
              style: helveticaText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: eerieBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Clock extends StatefulWidget {
  Clock({
    super.key,
    this.time = "",
  });

  String time;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _timeString = "";

  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.time = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      // if (now.minute == 45 && now.second == 0) {
      //   print('menit 45');
      //   widget.checkDb!();
      // }
      widget.time = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('H:mm').format(dateTime);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.time,
      style: helveticaText.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: davysGray,
      ),
    );
  }
}
