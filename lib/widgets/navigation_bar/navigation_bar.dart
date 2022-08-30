import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/routes/routes.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar_item.dart';

class NavigationBarWeb extends StatefulWidget {
  NavigationBarWeb({this.index});

  int? index;

  @override
  State<NavigationBarWeb> createState() => _NavigationBarWebState();
}

class _NavigationBarWebState extends State<NavigationBarWeb> {
  int? index;
  void changeHighlight(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
  }

  void onHighlight(String route) {
    switch (route) {
      case homePageRoute:
        changeHighlight(0);
        break;
      case searchinPageRoute:
        changeHighlight(1);
        break;
      case myBookingPageRoute:
        changeHighlight(2);
        break;
      case calendarViewPageRoute:
        changeHighlight(3);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: eerieBlack,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                // color: Colors.amber,
                width: 150,
                height: 75,
                child: SvgPicture.asset(
                  'assets/klg_main_logo_white.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NavigationItem(
                      title: 'Home',
                      routeName: homePageRoute,
                      selected: index == 0,
                      onHighlight: onHighlight,
                    ),
                    NavigationItem(
                      title: 'Search Room',
                      routeName: searchinPageRoute,
                      selected: index == 1,
                      onHighlight: onHighlight,
                    ),
                    NavigationItem(
                      title: 'My Bookings',
                      routeName: myBookingPageRoute,
                      selected: index == 2,
                      onHighlight: onHighlight,
                    ),
                    NavigationItem(
                      title: 'Calendar',
                      routeName: calendarViewPageRoute,
                      selected: index == 3,
                      onHighlight: onHighlight,
                    ),
                    // LogoutButton(
                    //   title: 'Logout',
                    //   selected: index == 4,
                    //   onHighlight: onHighlight,
                    //   onTap: () {
                    //     logout().then((value) {
                    //       // jwtToken = "";
                    //       Navigator.pushReplacementNamed(
                    //           navKey.currentState!.context, routeLogin);
                    //     });
                    //   },
                    // )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
