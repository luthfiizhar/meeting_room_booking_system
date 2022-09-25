import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/key.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
// import 'package:meeting_room_booking_system/constant/key.dart';
import 'package:meeting_room_booking_system/routes/routes.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/logout_button.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar_item.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NavigationBarWeb extends StatefulWidget {
  NavigationBarWeb({this.index});

  int? index;

  @override
  State<NavigationBarWeb> createState() => _NavigationBarWebState();
}

class _NavigationBarWebState extends State<NavigationBarWeb> {
  int? index;

  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();

  List<TargetFocus> targets = [];
  late TutorialCoachMark tutorialCoachMark;

  Future showTutorial() async {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets, // List<TargetFocus>
      // colorShadow: Colors.red, // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        Provider.of<LoginInfoModel>(context, listen: false).onBoardDone();
        print("skip");
      },
      onFinish: () {
        print("finish");
      },
    );
    // TutorialCoachMark().show(context: context);
    if (Provider.of<LoginInfoModel>(context, listen: false).firstLogin) {
      tutorialCoachMark.show(context: context);
    }
    // return "";
  }

  addTarget() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton,
        shape: ShapeLightFocus.RRect,
        radius: 7,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              // customPosition: CustomTargetContentPosition(top: 100, right: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Home",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Halaman utama user.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            tutorialCoachMark.next();
                          },
                          child: Text('Next')))
                ],
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Search Room",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Untuk mencari ruang meeting yang tersedia.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: keyButton3,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "My Bookings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "List booking user.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: keyButton4,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Calendar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Calendar user (sync with Google Calendar).",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 5",
        keyTarget: keyButton5,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Logout mengakhiri sesi user.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

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
    print(Provider.of<LoginInfoModel>(context, listen: false).firstLogin);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ShowCaseWidget.of(context).startShowCase([keyButton]);
    // });

    // addTarget();
    // Future.delayed(
    //   Duration(milliseconds: 500),
    //   () {
    //     showTutorial().then((value) {
    //       Provider.of<LoginInfoModel>(context, listen: false).onBoardDone();
    //     });
    //   },
    // );
  }

  void onHighlight(String route) {
    switch (route) {
      case homePageRoute:
        changeHighlight(0);
        break;
      case searchinPageRoute:
        changeHighlight(1);
        break;
      case roomPageRoute:
        changeHighlight(2);
        break;
      case myBookingPageRoute:
        changeHighlight(3);
        break;
      case calendarViewPageRoute:
        changeHighlight(4);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: scaffoldBg,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // color: Colors.amber,
                width: 175,
                height: 60,
                child: SvgPicture.asset(
                  'assets/klg_logo_tagline_black.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  // color: Colors.amber,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NavigationItem(
                        title: 'Home',
                        routeName: homePageRoute,
                        selected: index == 0,
                        onHighlight: onHighlight,
                        key: keyButton,
                      ),
                      const Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      NavigationItem(
                        title: 'Search',
                        routeName: searchinPageRoute,
                        selected: index == 1,
                        onHighlight: onHighlight,
                        key: keyButton2,
                      ),
                      const Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      NavigationItem(
                        title: 'Rooms',
                        routeName: roomPageRoute,
                        selected: index == 2,
                        onHighlight: onHighlight,
                        // key: keyButton2,
                      ),
                      const Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      NavigationItem(
                        title: 'My Bookings',
                        routeName: myBookingPageRoute,
                        selected: index == 3,
                        onHighlight: onHighlight,
                        key: keyButton3,
                      ),
                      const Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      NavigationItem(
                        title: 'Calendar',
                        routeName: calendarViewPageRoute,
                        selected: index == 4,
                        onHighlight: onHighlight,
                        key: keyButton4,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 175,
                // color: Colors.green,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // NavigationItem(
                    //   title: 'Logout',
                    //   routeName: loginPageRoute,
                    //   selected: index == 5,
                    //   onHighlight: onHighlight,
                    //   key: keyButton5,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: LogoutButton(
                        label: 'Logout',
                        onPressed: () {
                          jwtToken = "";
                        },
                      ),
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
