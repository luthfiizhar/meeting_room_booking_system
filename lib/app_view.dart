import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:meeting_room_booking_system/widgets/footer.dart';
// import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';

class AppView extends StatelessWidget {
  final Widget? child;
  AppView({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: child!,
    );
  }
}
