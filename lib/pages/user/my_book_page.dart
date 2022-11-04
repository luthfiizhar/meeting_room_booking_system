import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/banner/black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:html' as html;

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  setDatePickerStatus(bool value) {}

  final Uri url = Uri.parse('https://flutter.dev');

  Future<void> _launchUrl() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

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
            RegularButton(
              text: 'Open Window',
              disabled: false,
              onTap: () async {
                // html.window.open(
                //     'https://stackoverflow.com/questions/ask', 'new window');
                if (await launchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                    webOnlyWindowName: '_blank',
                  );
                } else {
                  throw 'Could not launch $url';
                }
              },
            )
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
