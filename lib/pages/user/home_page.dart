import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/key.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showOnBoard = false;
  // final loginInfo = LoginInfoModel();

  List<TargetFocus> targets = [];
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  GlobalKey key6 = GlobalKey();

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
        keyTarget: key1,
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
        keyTarget: key2,
        shape: ShapeLightFocus.RRect,
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
        keyTarget: key3,
        shape: ShapeLightFocus.RRect,
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
        keyTarget: key4,
        shape: ShapeLightFocus.RRect,
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
        keyTarget: key5,
        shape: ShapeLightFocus.RRect,
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
    targets.add(
      TargetFocus(
        identify: "Target 6",
        keyTarget: key6,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Konten",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Konten.",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // addTarget();
    // Future.delayed(
    //   Duration(milliseconds: 500),
    //   () {
    //     showTutorial().then((value) {
    //       Provider.of<LoginInfoModel>(context, listen: false).onBoardDone();
    //     });
    //   },
    // );
    // showBoardingPage();
    // checkOnBoardingPage();
    // showBoardingPage();
  }

  checkOnBoardingPage() async {
    var box = await Hive.openBox('userLogin');

    var firstLogin = box.get('firstLogin') != "" ? false : true;

    showOnBoard = firstLogin;
    setState(() {});
  }

  showBoardingPage() {
    print(Provider.of<LoginInfoModel>(context, listen: false).firstLogin);
    if (Provider.of<LoginInfoModel>(context, listen: false).firstLogin) {
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          showDialog(
            context: context,
            builder: (context) {
              return OnBoardPage();
            },
          );
        },
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  NavigationBarWeb(
                    index: 0,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              key: key1,
                              height: 100,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              key: key2,
                              height: 100,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              key: key3,
                              height: 100,
                              color: Colors.blue,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              key: key4,
                              height: 100,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(
                            key: key5,
                            child: Container(
                              height: 100,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          key: key6,
                          height: 300,
                          width: 400,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/gapps.png'),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0, 0),
                                    end: Alignment(0, 0.7),
                                    colors: [
                                      Color.fromARGB(0, 255, 255, 255),
                                      eerieBlack,
                                    ],
                                    // stops: [0, 200],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 400,
                                  color: eerieBlack,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Link your Google Account',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Link your Google Account',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Link your Google Account',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
