import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';

class GreetingContainer extends StatefulWidget {
  const GreetingContainer({super.key});

  @override
  State<GreetingContainer> createState() => _GreetingContainerState();
}

class _GreetingContainerState extends State<GreetingContainer> {
  ReqAPI apiReq = ReqAPI();
  String name = "";
  String greeting = "";
  List imageWelcome = [
    "assets/Welcome Image/Asset 3@2x.png",
    "assets/Welcome Image/Asset 4@2x.png",
    "assets/Welcome Image/Asset 5@2x.png"
  ];
  int indexImage = 0;
  final _random = Random();
  checkData() async {
    // var box = await Hive.openBox('userLogin');

    // name = box.get('name');
    // setState(() {});
    apiReq.getUserProfile().then((value) {
      if (value["Status"].toString() == "200") {
        setState(() {
          name = value['Data']['EmpName'];
        });
      }
    });
  }

  setGreeting(String value) {
    if (mounted) {
      setState(() {
        greeting = value;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkData();
    initGreeting();
    updateGreeting();
  }

  initGreeting() {
    final DateTime now = DateTime.now();
    print(now.hour);
    if (now.hour >= 5 && now.hour < 12) {
      setGreeting('Good Morning');
      indexImage = 2;
    } else if (now.hour >= 12 && now.hour < 17) {
      setGreeting('Good Afternoon');
      indexImage = 1;
    } else if (now.hour >= 17 && now.hour < 21) {
      setGreeting('Good Evening');
      indexImage = 0;
    } else if (now.hour >= 21 || now.hour < 5) {
      setGreeting('Good Night');
      indexImage = 0;
    }
  }

  updateGreeting() {
    const oneMin = const Duration(hours: 1);
    Timer.periodic(oneMin, (Timer t) {
      final DateTime now = DateTime.now();
      if (now.hour >= 5 && now.hour < 12) {
        setGreeting('Good Morning');
      } else if (now.hour >= 12 && now.hour < 17) {
        setGreeting('Good Afternoon');
      } else if (now.hour >= 17 && now.hour < 21) {
        setGreeting('Good Evening');
      } else if (now.hour >= 21 && now.hour < 5) {
        setGreeting('Good Night');
      }
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
      constraints: homeLeftSideConstrains.copyWith(maxHeight: 200),
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

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 35,
                top: 30,
                bottom: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Clock(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        '$greeting,',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: helveticaText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: eerieBlack,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // color: violetAccent,
              height: 200,
              child: Image.asset(
                imageWelcome[indexImage],
                isAntiAlias: true,
                scale: 1,
                fit: BoxFit.contain,
              ),
            )
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
    this.setGreeting,
  });

  String time;
  Function? setGreeting;

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
    // if (now.hour >= 5 && now.hour < 12) {
    //   widget.setGreeting!('Good Morning');
    // } else if (now.hour >= 12 && now.hour < 17) {
    //   widget.setGreeting!('Good Afternoon');
    // } else if (now.hour >= 17 && now.hour < 21) {
    //   widget.setGreeting!('Good Evening');
    // } else if (now.hour >= 21 && now.hour < 5) {
    //   widget.setGreeting!('Good Night');
    // }
    setState(() {
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
