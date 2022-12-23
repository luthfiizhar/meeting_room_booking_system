import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/constant/key.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/local_storage.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/widgets/amenities_container.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/end_time_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/feature_container.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/meeting_type_container.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:meeting_room_booking_system/widgets/participant_container.dart';
import 'package:meeting_room_booking_system/widgets/pop_up_profile.dart';
import 'package:meeting_room_booking_system/widgets/search_container.dart';
import 'package:meeting_room_booking_system/widgets/search_page/filter_container.dart';
import 'package:meeting_room_booking_system/widgets/search_page/list_card.dart';
import 'package:meeting_room_booking_system/widgets/search_page/sorting_container.dart';
import 'package:meeting_room_booking_system/widgets/start_time_container.dart';
import 'package:meeting_room_booking_system/widgets/time_picker_container.dart';
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
  bool isLoadingSync = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _facilityController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _participantController = TextEditingController();
  DateRangePickerController datePickerControl = DateRangePickerController();

  bool showOnBoard = false;
  bool opacityOn = false;

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
          'Yes, you can still use MRBS as a standalone application. Link to Google Workspace is an additional features to help you get into Google Workspace ecosystem easily. It is your choice to link it or not.',
      'isCollapse': false,
    },
    {
      'Question':
          'Can I connect my personal Google or Google Workspace account?',
      'Answer':
          'Yes, you can still use MRBS as a standalone application. Link to Google Workspace is an additional features to help you get into Google Workspace ecosystem easily. It is your choice to link it or not.',
      'isCollapse': false,
    },
    {
      'Question':
          'Can I connect my personal Google or Google Workspace account?',
      'Answer':
          'Yes, you can still use MRBS as a standalone application. Link to Google Workspace is an additional features to help you get into Google Workspace ecosystem easily. It is your choice to link it or not.',
      'isCollapse': false,
    },
    {
      'Question':
          'Can I connect my personal Google or Google Workspace account?',
      'Answer':
          'Yes, you can still use MRBS as a standalone application. Link to Google Workspace is an additional features to help you get into Google Workspace ecosystem easily. It is your choice to link it or not.',
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
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final AnimationController _controller2 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final AnimationController _controller3 = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );
  late final AnimationController _controller4 = AnimationController(
    duration: const Duration(seconds: 2),
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
        print('if false');
        faqList[index]['isCollapse'] = true;
      } else if (faqList[index]['isCollapse']) {
        print('if true');
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
  }

  Future animateIntroSection() async {
    _controller.forward(from: 0);
    Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
      () {
        _controller2.forward(from: 0);
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 750,
      ),
      () {
        _controller3.forward(from: 0);
      },
    );
    Future.delayed(
      const Duration(
        milliseconds: 1000,
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
    print("param-> ${widget.param}");
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
        Provider.of<MainModel>(context, listen: false).onBoardDone();
        print("skip");
      },
      onFinish: () {
        print("finish");
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

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      scrollController: scrollController,
      index: 0,
      setDatePickerStatus: resetAllVisibleStatus,
      resetState: resetState,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              introSection(),
              const SizedBox(
                height: 100,
              ),
              featureSection(),
              const SizedBox(
                height: 100,
              ),
              howToSection(),
              faqSection(),
              endSection(),
            ],
          ),
          Positioned(
            top: 160,
            right: -75,
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width <= 1366 ? 827 : 1193,
                height: MediaQuery.of(context).size.width <= 1366 ? 552 : 796,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset('assets/mrbs_home_page_ilus.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget introSection() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: 750,
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
                    : TransparentBorderedBlackButton(
                        text: 'Link My Account',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () async {
                          setState(() {
                            isLoadingSync = true;
                          });
                          getLinkGoogleAuth().then((value) async {
                            // html.window.open(
                            //   "get_data.html?link=${value['Data']['Link']}",
                            //   'GoogleAuth',
                            // );
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
                                print(code);
                                await Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  popUpWindow.close();
                                  setState(() {
                                    isLoadingSync = false;
                                  });
                                  saveTokenGoogle(code).then((value) {
                                    print(value);

                                    if (value['Status'] == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                          title: value['Title'],
                                          contentText: value['Message'],
                                          isSuccess: true,
                                        ),
                                      );
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
                          });
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxHeight: 850,
      ),
      child: Container(
        key: featureSectionKey,
        // color: Colors.amber,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 1100,
                child: Column(
                  children: [
                    LeftFeatureContainer(
                      icon: Image.asset('assets/google_calendar_icon.png'),
                      title: 'Google Calendar',
                      content:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ac viverra nisi, et ullamcorper neque. Proin nec rutrum magna. Etiam nec consectetur leo, eu fringilla diam.',
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RightFeatureContainer(
                      icon: Image.asset('assets/google_meet_icon.png'),
                      title: 'Google Meet',
                      content:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ac viverra nisi, et ullamcorper neque. Proin nec rutrum magna. Etiam nec consectetur leo, eu fringilla diam.',
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    LeftFeatureContainer(
                      icon: Image.asset('assets/google_contact_icon.png'),
                      title: 'Google Contact',
                      content:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ac viverra nisi, et ullamcorper neque. Proin nec rutrum magna. Etiam nec consectetur leo, eu fringilla diam.',
                      backgroundColor: eerieBlack,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
        maxHeight: 500,
      ),
      child: Container(
        // key: faqSectionKey,
        // color: Colors.purple,
        child: Center(
          child: Container(
            // color: Colors.green,
            width: 1210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How To Connect?',
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: 100,
                    fontWeight: FontWeight.w800,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 0.5
                      ..color = davysGray,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 363,
                      height: 383,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 325,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: platinumLight,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 30,
                            child: Column(
                              children: [
                                Image.asset('assets/gws_vector_1.png'),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    'Enter your Google Workspace email address',
                                    style: helveticaText.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 0,
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 100,
                                fontWeight: FontWeight.w800,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = orangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Container(
                      width: 363,
                      height: 383,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 325,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: platinumLight,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 30,
                            child: Column(
                              children: [
                                Image.asset('assets/gws_vector_2.png'),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    'Accept Google account permissions',
                                    style: helveticaText.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 0,
                            child: Text(
                              '2',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 100,
                                fontWeight: FontWeight.w800,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = orangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    ),
                    Container(
                      width: 363,
                      height: 383,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 325,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: platinumLight,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 30,
                            child: Column(
                              children: [
                                Image.asset('assets/gws_vector_3.png'),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    'Your account is linked!',
                                    style: helveticaText.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 0,
                            child: Text(
                              '3',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 100,
                                fontWeight: FontWeight.w800,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = orangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
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
        color: davysGray,
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
                  TransparentBorderedWhiteButton(
                    text: 'Link My Account',
                    disabled: false,
                    padding: ButtonSize().mediumSize(),
                    onTap: () async {
                      getLinkGoogleAuth().then((value) {
                        html.window.open(value['Data']['Link'], 'GoogleAuth',
                            'width=600,height=600, top=300, left=600');
                      });
                      // html.window.open('https://flutter.dev', 'Google SignIn',
                      //     'width=600,height=600');
                      // js.context.callMethod('open', ['https://stackoverflow.com/questions/ask']);
                      // Uri _url = Uri.parse('https://flutter.dev');
                      // // Uri _url = Uri(
                      // //   host: 'https://flutter.dev',
                      // // );
                      // if (!await launchUrl(
                      //   _url,
                      //   webOnlyWindowName: '_blank',
                      //   // webViewConfiguration:
                      //   //     const WebViewConfiguration(headers: {'': ''}),
                      // )) {
                      //   throw 'Could not launch $_url';
                      // }
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
