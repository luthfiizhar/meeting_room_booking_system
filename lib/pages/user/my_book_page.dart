import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/banner/black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  setDatePickerStatus(bool value) {}
  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 3,
      setDatePickerStatus: setDatePickerStatus,
      child: Container(
        // color: Colors.grey,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // BlackBanner(
            //   title: 'Link your Google account',
            //   subtitle: '& enjoy your benefits.',
            //   imagePath: 'assets/banner_pict_google.png',
            // ),
            SizedBox(
              height: 20,
            ),
            BlackBannerLandscape(
              title: 'Link your Google account',
              subtitle: '& enjoy your benefits.',
              imagePath: 'assets/banner_pict_google.png',
            ),
            SizedBox(
              height: 20,
            ),
            WhiteBannerLandscape(
              title: 'Link your Google account',
              subtitle: '& enjoy your benefits.',
              imagePath: 'assets/banner_pict_google.png',
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      NavigationBarWeb(
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
