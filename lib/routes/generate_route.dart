import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/pages/login_page.dart';
import 'package:meeting_room_booking_system/routes/routes.dart';

class RouterGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (isLoggedIn) {
      switch (settings.name) {
        case homePageRoute:
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoginPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        default:
      }
    } else {
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    }
  }
}
