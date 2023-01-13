import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/home_page/feature_container.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class GoogleWorkspacePage extends StatefulWidget {
  GoogleWorkspacePage({Key? key, this.param = ""}) : super(key: key);

  dynamic param;

  @override
  State<GoogleWorkspacePage> createState() => _GoogleWorkspacePageState();
}

class _GoogleWorkspacePageState extends State<GoogleWorkspacePage>
    with TickerProviderStateMixin {
  ReqAPI apiReq = ReqAPI();
  bool isLoadingSync = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _facilityController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _participantController = TextEditingController();
  DateRangePickerController datePickerControl = DateRangePickerController();

  bool showOnBoard = false;
  bool opacityOn = false;

  bool isAccLinked = false;

  bool profileVisible = false;
  // final loginInfo = MainModel();

  bool checkBoxTv = false;
  bool checkBoxCamera = false;
  List facilitySelected = [];
  List startTimeList = [];
  List endTimeList = [];
  String participantSelected = "";
  String startTime = "";
  String endTime = "";
  String initialEndTime = "";
  String meetingTypeSelected = "Meeting Room";

  List faqList = [
    {
      'Question':
          'Can I connect my personal Google or Google Workspace account?',
      'Answer':
          'Only Google Workspace account from Kawan Lama is acceptable in the system. You cannot submit your personal Google account.',
      'isCollapse': false,
    },
    {
      'Question':
          'If I book an event from my Google Calendar, will it synchronize with Meeting Room Booking System?',
      'Answer':
          'Yes, if you linked your Google Workspace account, your Google Calendar event will be shown on Meeting Room Booking System and vice-versa.',
      'isCollapse': false,
    },
    {
      'Question':
          'Can I use Meeting Room Booking System without linking my Google Workspace account?',
      'Answer':
          'Yes, you can still use Meeting Room Booking System as a standalone application. Link to Google Workspace is an additional features to help you onboard into Google Workspace ecosystem at ease. It is your choice to link it or not.',
      'isCollapse': false,
    },
    {
      'Question':
          'Can I login to Meeting Room Booking System using Google Workspace account after I linked it?',
      'Answer':
          'No, even when you had linked your Google Workspace account, you have to login using Cerberus / Windows login to this system.',
      'isCollapse': false,
    }
  ];

  List<RadioModel> listSorting = [
    RadioModel(isSelected: false, text: 'Lowest Floor'),
    RadioModel(isSelected: false, text: 'Highest Floor'),
    RadioModel(isSelected: false, text: 'Lowest Capacity'),
    RadioModel(isSelected: false, text: 'Highest Capacity'),
    RadioModel(isSelected: false, text: 'Alphabetical'),
  ];
  String selectedSorting = "Lowest Floor";

  List<CheckBoxModel>? listFilter = [
    CheckBoxModel(selected: true, value: '1st Floor'),
    CheckBoxModel(selected: true, value: '2nd Floor'),
    CheckBoxModel(selected: true, value: '3rd Floor'),
    CheckBoxModel(selected: true, value: '4th Floor'),
    CheckBoxModel(selected: true, value: '5th Floor'),
    CheckBoxModel(selected: true, value: '1st Floor'),
    CheckBoxModel(selected: true, value: '1st Floor'),
    CheckBoxModel(selected: true, value: '1st Floor'),
    CheckBoxModel(selected: true, value: '1st Floor'),
    CheckBoxModel(selected: true, value: '1st Floor'),
  ];
  List selectedFilter = ['1', '2', '3', '4'];

  DateTime selectedDate = DateTime.now();

  List<TargetFocus> targets = [];
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  GlobalKey key6 = GlobalKey();

  GlobalKey introSectionKey = GlobalKey();
  GlobalKey featureSectionKey = GlobalKey();
  GlobalKey faqSectionKey = GlobalKey();

  ScrollController scrollController = ScrollController();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final AnimationController _controller3 = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final AnimationController _controller4 = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<double> _animation1 = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animation2 = CurvedAnimation(
    parent: _controller2,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animation3 = CurvedAnimation(
    parent: _controller3,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animation4 = CurvedAnimation(
    parent: _controller4,
    curve: Curves.easeIn,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    end: Offset.zero,
    begin: const Offset(1.5, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ),
  );

  scrollListener(ScrollController scrollInfo) {
    RenderBox box =
        introSectionKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    double y = position.dy;
    // print('Container -> $y');
    // print('Controller -> ${scrollInfo.position.pixels.toString()}');
    if (scrollInfo.position.pixels == 0) {
      // setState(() {});
      // _controller.forward(from: 0);
      animateIntroSection();
    }
  }

  closeFaq(int index) {
    setState(() {
      faqList[index]['isCollapse'] = false;
    });
  }

  onTapFaq(int index) {
    setState(() {
      // closeDetail();
      for (var element in faqList) {
        element['isCollapse'] = false;
      }
      if (!faqList[index]['isCollapse']) {
        // print('if false');
        faqList[index]['isCollapse'] = true;
      } else if (faqList[index]['isCollapse']) {
        // print('if true');
        faqList[index]['isCollapse'] = false;
      }
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    // _controller2.dispose();
    // _controller3.dispose();
    // _controller4.dispose();
    // scrollController.dispose();
    super.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
  }

  Future animateIntroSection() async {
    _controller.forward(from: 0);
    Future.delayed(
      const Duration(
        milliseconds: 100,
      ),
      () {
        _controller2.forward(from: 0);
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
      () {
        _controller3.forward(from: 0);
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 400,
      ),
      () {
        _controller4.forward(from: 0);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("param-> ${widget.param}");
    apiReq.getUserProfile().then((value) {
      print(value);
      if (value['Status'].toString() == "200") {
        if (value['Data']['GoogleAccountSync'] == 1) {
          setState(() {
            isAccLinked = true;
          });
        }
      }
    });
    animateIntroSection();
    scrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        scrollListener(scrollController);
        // print(Provider.of<MainModel>(context).toString());
      });
    });
  }

  Future showTutorial() async {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets, // List<TargetFocus>
      // colorShadow: Colors.red, // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        // print(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        // print("target: $target");
        // print(
        //     "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        // print(target);
      },
      onSkip: () {
        Provider.of<MainModel>(context, listen: false).onBoardDone();
        // print("skip");
      },
      onFinish: () {
        // print("finish");
      },
    );
    // TutorialCoachMark().show(context: context);
    if (Provider.of<MainModel>(context, listen: false).firstLogin) {
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  resetAllVisibleStatus(bool value) {
    // datePickerVisible = value;
    // amenitiesContainerVisible = value;
    // participantContainerVisible = value;
    // timePickerContainerVisible = value;
    // startTimeContainerVisible = value;
    // endTimeContainerVisible = value;
    // meetingTypeContainerVisible = value;
    // opacityOn = value;
    // setState(() {});
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future testGoogle(String link) async {
    html.window.open(
      link,
      'GoogleAuth',
    );
  }

  resetState() {
    setState(() {});
  }

  googleLink() {
    apiReq.getLinkGoogleAuth().then((value) async {
      if (value['Status'].toString() == "200") {
        html.WindowBase popUpWindow;
        popUpWindow = html.window.open(
          value['Data']['Link'],
          'GWS',
          'width=400, height=500, scrollbars=yes',
        );

        String code = "";
        html.window.onMessage.listen((event) async {
          if (event.data.toString().contains('token=')) {
            code = event.data.toString().split('token=')[1];
            setState(() {
              isLoadingSync = true;
            });
            await Future.delayed(const Duration(seconds: 2), () async {
              popUpWindow.close();
              html.window.removeEventListener("", (event) {
                return "";
              });
              // html.window.close();
              setState(() {
                isLoadingSync = false;
              });
              apiReq.saveTokenGoogle(code).then((value) {
                if (value['Status'] == "200") {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialogBlack(
                      title: value['Title'],
                      contentText: value['Message'],
                      isSuccess: true,
                    ),
                  ).then((value) {
                    context.goNamed('home');
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialogBlack(
                      title: value['Title'],
                      contentText: value['Message'],
                      isSuccess: false,
                    ),
                  );
                }
              }).onError((error, stackTrace) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialogBlack(
                    title: 'Failed',
                    contentText: error.toString(),
                    isSuccess: false,
                  ),
                );
              });
            });
          }
        });

        if (code != "") {}
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      scrollController: scrollController,
      index: 0,
      setDatePickerStatus: resetAllVisibleStatus,
      resetState: resetState,
      child: Stack(
        children: [
          Positioned(
            top: 160,
            right: -75,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width <= 1366 ? 827 : 1193,
                height: MediaQuery.of(context).size.width <= 1366 ? 552 : 796,
                child: FittedBox(
                  fit: BoxFit.contain,
                  // child: Image.asset('assets/mrbs_home_page_ilus.png'),
                  child: SvgPicture.asset('assets/mrbs_ilustration.svg'),
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              introSection(),
              const SizedBox(
                height: 140,
              ),
              featureSection(),
              howToSection(),
              faqSection(),
              endSection(),
            ],
          ),
        ],
      ),
    );
  }

  Widget introSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: 800,
      ),
      child: Container(
        key: introSectionKey,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 180,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _animation1,
                child: Text(
                  'MRBS works with',
                  style: helveticaText.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                    color: eerieBlack,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FadeTransition(
                  opacity: _animation2,
                  child: Image.asset('assets/mrbs_gws_logo.png')),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 600,
                child: FadeTransition(
                  opacity: _animation3,
                  child: Text(
                    'Experience more collaboration features by linking your MRBS account to your Google Workspace.',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              FadeTransition(
                opacity: _animation4,
                child: isLoadingSync
                    ? const CircularProgressIndicator(
                        color: eerieBlack,
                      )
                    : isAccLinked
                        ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              const ImageIcon(
                                AssetImage(
                                  'assets/icons/check_icon.png',
                                ),
                                color: greenAcent,
                              ),
                              Text(
                                'Your account already linked.',
                                style: helveticaText.copyWith(
                                  fontSize: 18,
                                  color: davysGray,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          )
                        : TransparentBorderedBlackButton(
                            text: 'Link My Account',
                            disabled: false,
                            padding: ButtonSize().mediumSize(),
                            onTap: () {
                              googleLink();
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget featureSection() {
    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: 200,
              maxHeight: 540,
            ),
            child: Container(
              key: featureSectionKey,
              // color: Colors.amber,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 1100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LeftFeatureContainer(
                        icon: Image.asset('assets/google_calendar_icon.png'),
                        title: 'Google Calendar',
                        content:
                            'You can create, edit & delete event from your Google Calendar to Meeting Room Booking System (vice-versa). Every event will be synchronize in real-time & shown on Home & Calendar page.',
                        backgroundImage: Image.asset('assets/calendar.jpg'),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RightFeatureContainer(
                        icon: Image.asset('assets/google_meet_icon.png'),
                        title: 'Google Meet',
                        content:
                            'Generate Google Meet URL when you create an event, so you can attend while offline or online. Also synced with Google Meet Hardware in several rooms, to give you a brand new experience in attending a meeting.',
                        backgroundImage: Image.asset('assets/man.jpg'),
                      ),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      // LeftFeatureContainer(
                      //   icon: Image.asset('assets/google_contact_icon.png'),
                      //   title: 'Google Contact',
                      //   content:
                      //       'Get your email & contact list straight from your Google account. You can invite people to your event at ease. Just type the email & it will be listed for you.',
                      //   backgroundColor: eerieBlack,
                      //   backgroundImage: Image.asset('assets/phone.jpg'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 30,
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              'Features',
              style: helveticaBlackText.copyWith(
                fontSize: 100,
                // backgroundColor: violetAccent,
                fontWeight: FontWeight.w400,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 0.5
                  ..color = davysGray,
              ),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 30,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              'Features',
              style: helveticaBlackText.copyWith(
                fontSize: 100,
                // backgroundColor: violetAccent,
                fontWeight: FontWeight.w400,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 0.5
                  ..color = davysGray,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget faqSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 1100,
        maxWidth: 1100,
        minHeight: 500,
      ),
      child: Container(
        width: 1100,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Frequently Asked Question',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Have question? We\'re here to help.',
                style: helveticaText.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ListView.builder(
                itemCount: faqList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      FaqContainer(
                        index: index,
                        answer: faqList[index]['Answer'],
                        question: faqList[index]['Question'],
                        isCollapse: faqList[index]['isCollapse'],
                        changeCollapse: closeFaq,
                        tap: onTapFaq,
                      ),
                      index == faqList.length - 1
                          ? const SizedBox()
                          : const Divider(
                              color: davysGray,
                              thickness: 0.5,
                            )
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget howToSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: 700,
        maxHeight: 1000,
      ),
      child: Container(
        // key: faqSectionKey,
        // color: Colors.purple,
        child: Center(
          child: Container(
            // color: Colors.green,
            width: 1210,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How To Connect?',
                  style: helveticaBlackText.copyWith(
                    fontSize: 100,
                    fontWeight: FontWeight.w400,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 0.5
                      ..color = davysGray,
                    // backgroundColor: violetAccent,
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Row(
                  children: [
                    howToConnectContainer('assets/gws_vector_1.png',
                        'Enter your Google Workspace email address', '1'),
                    const SizedBox(
                      width: 60,
                    ),
                    howToConnectContainer('assets/gws_vector_2.png',
                        'Accept Google account permissions', '2'),
                    const SizedBox(
                      width: 60,
                    ),
                    howToConnectContainer('assets/gws_vector_3.png',
                        'Your account is linked!', '3')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget howToConnectContainer(String image, String message, String number) {
    return Container(
      width: 363,
      height: 383,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 15,
              ),
              child: Container(
                width: 325,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: platinumLight,
                ),
              ),
            ),
          ),
          Positioned(
            top: 45,
            right: 30,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 190,
                    height: 180,
                    child: FittedBox(
                      child: Image.asset(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 250,
                    child: Text(
                      message,
                      style: helveticaText.copyWith(
                        wordSpacing: 2,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: davysGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -3,
            child: Text(
              number,
              style: helveticaBlackText.copyWith(
                fontSize: 100,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = orangeAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget endSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 400,
        maxHeight: 400,
      ),
      child: Container(
        // color: davysGray,
        decoration: const BoxDecoration(
          color: eerieBlack,
          image: DecorationImage(
            image: AssetImage('assets/kursi_meja.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Link your Google Workspace account now & start collaborate!',
                    style: helveticaText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: culturedWhite,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  isAccLinked
                      ? Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            const ImageIcon(
                              AssetImage(
                                'assets/icons/check_icon.png',
                              ),
                              color: greenAcent,
                            ),
                            Text(
                              'Your account already linked.',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                color: culturedWhite,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        )
                      : TransparentBorderedWhiteButton(
                          text: 'Link My Account',
                          disabled: false,
                          padding: ButtonSize().mediumSize(),
                          onTap: () async {
                            googleLink();
                          },
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

class FaqContainer extends StatefulWidget {
  FaqContainer({
    super.key,
    this.index,
    this.question = "",
    this.answer = "",
    this.isCollapse = false,
    this.tap,
    this.changeCollapse,
  });

  int? index;
  String question;
  String answer;
  bool isCollapse;
  Function? tap;
  Function? changeCollapse;
  @override
  State<FaqContainer> createState() => _FaqContainerState();
}

class _FaqContainerState extends State<FaqContainer> {
  String question = "";
  String answer = "";
  bool isCollapse = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    question = widget.question;
    answer = widget.answer;
    isCollapse = widget.isCollapse;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isCollapse) {
          widget.changeCollapse!(widget.index);
        } else {
          widget.tap!(widget.index!);
        }
      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: 15,
                left: 15,
                top: 25,
                bottom: isCollapse ? 0 : 25,
              ),
              child: questionContainer(),
            ),
            Visibility(
              visible: widget.isCollapse,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  right: 150,
                  top: 20,
                  bottom: 20,
                ),
                child: answerContainer(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget questionContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          question,
          style: helveticaText.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: eerieBlack,
          ),
        ),
        widget.isCollapse
            ? const Icon(Icons.keyboard_arrow_down_sharp)
            : const Icon(Icons.keyboard_arrow_right_sharp)
      ],
    );
  }

  Widget answerContainer() {
    return Text(
      answer,
      style: helveticaText.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: davysGray,
        height: 1.38,
      ),
    );
  }
}

class Faq {
  Faq({
    this.question = "",
    this.answer = "",
    this.isCollapse = false,
  });
  String question;
  String answer;
  bool isCollapse;
}
