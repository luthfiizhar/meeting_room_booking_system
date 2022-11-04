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
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/widgets/amenities_container.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/end_time_container.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _datePickerOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: 485,
        left: 183,
        child: CustomDatePicker(
          controller: datePickerControl,
          changeDate: onDateChanged,
          setPickerStatus: setDatePickerVisible,
          currentDate: selectedDate,
        ),
      );
    });

    overlayState!.insert(overlayEntry);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
    _facilityController.dispose();
    _timeController.dispose();
    _participantController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
    _dateController.text = formattedDate;
    _facilityController.text = 'None';
    _timeController.text = 'Choose Time';
    _participantController.text = 'Total Participant';
    participantSelected = "0";

    int minute = TimeOfDay.now().minute;
    int hour = TimeOfDay.now().hour;
    int minuteEndInit = 0;
    if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
      minute = TimeOfDay.now().replacing(minute: 15).minute;
    } else if (TimeOfDay.now().minute > 15 && TimeOfDay.now().minute <= 30) {
      minute = TimeOfDay.now().replacing(minute: 30).minute;
    } else if (TimeOfDay.now().minute > 30 && TimeOfDay.now().minute <= 45) {
      minute = TimeOfDay.now().replacing(minute: 45).minute;
    } else if (TimeOfDay.now().minute > 45 && TimeOfDay.now().minute <= 60) {
      minute = TimeOfDay.now().replacing(minute: 0).minute;
      hour = TimeOfDay.now().hour + 1;
    }
    var hourString =
        TimeOfDay(hour: hour, minute: minute).hour.toString().padLeft(2, '0');
    var minuteString =
        TimeOfDay(hour: hour, minute: minute).minute.toString().padLeft(2, '0');
    minuteEndInit = minute + 15;
    var minuteEndString =
        TimeOfDay(hour: hour, minute: minute).minute.toString().padLeft(2, '0');
    if (minuteEndInit == 60) {
      minuteEndString =
          TimeOfDay(hour: hour, minute: 0).minute.toString().padLeft(2, '0');
    }
    startTime = "$hourString:$minuteString";
    initialEndTime = "$hourString:${minuteEndInit.toString()}";
    endTime = initialEndTime;

    // addTarget();
    // Future.delayed(
    //   Duration(milliseconds: 500),
    //   () {
    //     showTutorial().then((value) {
    //       Provider.of<MainModel>(context, listen: false).onBoardDone();
    //     });
    //   },
    // );
    // showBoardingPage();
    // checkOnBoardingPage();
    // showBoardingPage();
    dateNode.addListener(() {
      setState(() {
        // getPosition();
      });
    });
  }

  popUpProfile(bool value) {
    if (profileVisible) {
      profileVisible = value;
    } else {
      profileVisible = value;
    }
    setState(() {});
  }

  checkOnBoardingPage() async {
    var box = await Hive.openBox('userLogin');

    var firstLogin = box.get('firstLogin') != "" ? false : true;

    showOnBoard = firstLogin;
    setState(() {});
  }

  showBoardingPage() {
    print(Provider.of<MainModel>(context, listen: false).firstLogin);
    if (Provider.of<MainModel>(context, listen: false).firstLogin) {
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

  FocusNode dateNode = FocusNode();

  String datePicked = "";

  double mouseX = 0;
  double mouseY = 0;

  GlobalKey searchContainerKey = GlobalKey();
  GlobalKey dateKey = GlobalKey();
  GlobalKey timeKey = GlobalKey();
  GlobalKey participantKey = GlobalKey();
  GlobalKey amenitiesKey = GlobalKey();
  GlobalKey meetingTypeKey = GlobalKey();

  bool datePickerVisible = false;
  bool amenitiesContainerVisible = false;
  bool participantContainerVisible = false;
  bool timePickerContainerVisible = false;
  bool startTimeContainerVisible = false;
  bool endTimeContainerVisible = false;
  bool meetingTypeContainerVisible = false;

  void _updateLocation(PointerHoverEvent event) {
    setState(() {
      mouseX = event.localPosition.dx;
      mouseY = event.localPosition.dy;
    });
  }

  void getPositionDatePicker() {
    RenderBox box =
        searchContainerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;
    mouseX = x;
    mouseY = y;
    // if (datePickerVisible) {
    //   datePickerVisible = false;
    // } else {
    //   datePickerVisible = true;
    // }
    datePickerVisible = true;

    // print(y);
    setState(() {});
  }

  void getPositionAmenities() {
    RenderBox box =
        searchContainerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;
    mouseX = x;
    mouseY = y;
    // if (datePickerVisible) {
    //   datePickerVisible = false;
    // } else {
    //   datePickerVisible = true;
    // }
    amenitiesContainerVisible = true;

    // print(y);
    setState(() {});
  }

  void getPositionParticipant() {
    RenderBox box =
        searchContainerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;
    mouseX = x;
    mouseY = y;

    // if (datePickerVisible) {
    //   datePickerVisible = false;
    // } else {
    //   datePickerVisible = true;
    // }
    participantContainerVisible = true;

    // print(y);
    setState(() {});
  }

  setStartTimeList(List value) {
    startTimeList = value;
    setState(() {});
  }

  setEndTimeList(List value) {
    endTimeList = value;
    setState(() {});
  }

  onDateChanged(String value, DateTime date) {
    datePicked = value;
    selectedDate = date;
    _dateController.text = datePicked;
    setState(() {});
  }

  onParticipanSelected(String value) {
    participantSelected = value;
    _participantController.text = "$participantSelected Person";
    setState(() {});
  }

  onMeetingTypeSelected(String value) {
    meetingTypeSelected = value;
    setState(() {});
  }

  setStartTime(String start) {
    startTime = start;
    setState(() {});
  }

  setEndTime(String end) {
    endTime = end;
    setState(() {});
  }

  setInitialEndTime(String value) {
    initialEndTime = value;
    setState(() {});
  }

  setTime(String start, String end) {
    startTime = start;
    endTime = end;
    _timeController.text = "$startTime - $endTime";
    setState(() {});
  }

  setStartTimeStatus(bool value) {
    startTimeContainerVisible = value;
    setState(() {});
  }

  setEndTimeStatus(bool value) {
    endTimeContainerVisible = value;
    setState(() {});
  }

  setMeetingTypeContainerStatus(bool value) {
    meetingTypeContainerVisible = value;
    setState(() {});
  }

  setAmenitiesStatus(bool value) {
    amenitiesContainerVisible = value;
    setState(() {});
  }

  setOpacityOn(bool value) {
    opacityOn = value;
    setState(() {});
  }

  setDatePickerVisible(bool value) {
    // RenderBox box = dateKey.currentContext!.findRenderObject() as RenderBox;
    // Offset position = box.localToGlobal(Offset.zero);
    // double y = position.dy;
    // double x = position.dx;
    // mouseX = x;
    // mouseY = y;
    // print(mouseX);
    // print(mouseY);
    datePickerVisible = value;
    // _datePickerOverlay(context);
    setState(() {});
  }

  setParticipantStatus(bool value) {
    participantContainerVisible = value;
    setState(() {});
  }

  setTimePickerStatus(bool value) {
    timePickerContainerVisible = value;
    setState(() {});
  }

  resetAllVisibleStatus(bool value) {
    datePickerVisible = value;
    amenitiesContainerVisible = value;
    participantContainerVisible = value;
    timePickerContainerVisible = value;
    startTimeContainerVisible = value;
    endTimeContainerVisible = value;
    meetingTypeContainerVisible = value;
    opacityOn = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 0,
      setDatePickerStatus: resetAllVisibleStatus,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 1100,
          // maxWidth: 1100,
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                // color: Colors.blue,
                width: 1100,
                child: Stack(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Container(
                          // color: Colors.amber,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxHeight: 475,
                                maxWidth: 1100,
                              ),
                              child: Container(
                                // color: Colors.greenAccent,
                                height: 475,
                                width: 1100,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        width: 1100,
                                        height: 400,
                                        decoration: BoxDecoration(
                                          color: graySand,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // image: DecorationImage(
                                          //   image:
                                          //       AssetImage('assets/social_hub.jpg'),
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 185,
                                      right: 0,
                                      child: Container(
                                        // color: Colors.black,
                                        decoration: BoxDecoration(
                                          color: eerieBlack,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                          right: 15,
                                          left: 25,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        // height: 30,
                                        // width: 30,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Social Hub',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: culturedWhite,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '- Head Office',
                                              style: TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: culturedWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          resetAllVisibleStatus(false);
                                          // setDatePickerVisible(false);
                                          // setAmenitiesStatus(false);
                                        },
                                        child: SearchContainer(
                                          key: searchContainerKey,
                                          dateNode: dateNode,
                                          getPositionDatePicker:
                                              getPositionDatePicker,
                                          getPositionAmenities:
                                              getPositionAmenities,
                                          getPositionparticipant:
                                              getPositionParticipant,
                                          setPickerStatus: setDatePickerVisible,
                                          setAmenitiesStatus:
                                              setAmenitiesStatus,
                                          setParticipantStatus:
                                              setParticipantStatus,
                                          setTimeStatus: setTimePickerStatus,
                                          setStartTimeStatus:
                                              setStartTimeStatus,
                                          setEndTimeStatus: setEndTimeStatus,
                                          setOpacityOn: setOpacityOn,
                                          pickerStatus: datePickerVisible,
                                          amenitiesStatus:
                                              amenitiesContainerVisible,
                                          participantStatus:
                                              participantContainerVisible,
                                          timePickerStatus:
                                              timePickerContainerVisible,
                                          dateController: _dateController,
                                          facilityController:
                                              _facilityController,
                                          timeController: _timeController,
                                          participantController:
                                              _participantController,
                                          meetingTypeSelected:
                                              meetingTypeSelected,
                                          meetingTypeStatus:
                                              meetingTypeContainerVisible,
                                          setMeetingTypeStatus:
                                              setMeetingTypeContainerStatus,
                                          dateKey: dateKey,
                                          timeKey: timeKey,
                                          amenitiesKey: amenitiesKey,
                                          meetingTypeKey: meetingTypeKey,
                                          participantKey: participantKey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // color: Colors.green,
                          child: Stack(
                            children: [
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 600,
                                    // maxHeight: MediaQuery.of(context).size.width,
                                    minWidth: 1000,
                                    // maxWidth: 1000,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      top: 35,
                                    ),
                                    width: 1000,
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(
                                    //     color: eerieBlack,
                                    //   ),
                                    // ),
                                    // height: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // color: Colors.amber,
                                              width: 235,
                                              // height: 1000,
                                              // child: Text('Filter'),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SortingContainer(
                                                    listSorting: listSorting,
                                                    selectedSorting:
                                                        selectedSorting,
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  FilterContainer(
                                                    listFilter: listFilter,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 35,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: ListView.builder(
                                                  // physics: NeverScrollableScrollPhysics,
                                                  shrinkWrap: true,
                                                  itemCount: 2,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListRoomContainer();
                                                  },
                                                ),
                                              ),
                                            ),

                                            // RegularButton(
                                            //   text: 'Start Time',
                                            //   disabled: false,
                                            //   onTap: () {
                                            //     setStartTime();
                                            //   },
                                            // ),
                                            // SizedBox(
                                            //   height: 10,
                                            // ),
                                            // RegularButton(
                                            //   text: 'End Time',
                                            //   disabled: false,
                                            //   onTap: () {
                                            //     setEndTime("09:45");
                                            //   },
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 35,
                                        ),
                                        WhiteBannerLandscape(
                                          title: 'Link your Google account',
                                          subtitle: '& enjoy your benefits.',
                                          imagePath:
                                              'assets/banner_pict_google.png',
                                        ),
                                        const SizedBox(
                                          height: 100,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              opacityOn
                                  ? Center(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: 1000,
                                          minWidth: 1366,
                                          // minWidth: 1000,
                                          // maxWidth: 1366,
                                        ),
                                        child: Container(
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),

                        // Center(
                        //   child: Text(
                        //     datePicked,
                        //   ),
                        // ),
                        // Container(
                        //   height: 1000,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: meetingTypeContainerVisible,
              child: Positioned(
                top: 360,
                left: 330,
                child: MeetingTypeContainer(
                  meetingTypeStatus: meetingTypeContainerVisible,
                  setMeetingType: onMeetingTypeSelected,
                  selectedMeetingType: meetingTypeSelected,
                  setMeetingTypeStatus: setMeetingTypeContainerStatus,
                ),
              ),
            ),
            Visibility(
              visible: datePickerVisible,
              child: Positioned(
                // bottom: 0,
                top: 485,
                left: 183,
                child: CustomDatePicker(
                  controller: datePickerControl,
                  changeDate: onDateChanged,
                  setPickerStatus: setDatePickerVisible,
                  currentDate: selectedDate,
                ),
              ),
            ),
            Visibility(
              visible: amenitiesContainerVisible,
              child: Positioned(
                // bottom: 0,
                top: 485,
                right: 370,
                child: AmenitiesContainer(
                  tvOnChange: (value) {
                    if (checkBoxTv) {
                      checkBoxTv = false;
                      facilitySelected
                          .removeWhere((element) => element == 'TV');
                    } else {
                      checkBoxTv = true;
                      facilitySelected.add('TV');
                    }
                    if (facilitySelected.isNotEmpty) {
                      if (facilitySelected.length > 1) {
                        _facilityController.text = "TV & Camera";
                      } else if (facilitySelected.length == 1) {
                        _facilityController.text =
                            facilitySelected[0].toString();
                      }
                    } else {
                      _facilityController.text = "None";
                    }
                    print(facilitySelected);
                    setState(() {});
                  },
                  cameraOnChange: (value) {
                    if (checkBoxCamera) {
                      checkBoxCamera = false;
                      facilitySelected
                          .removeWhere((element) => element == 'Camera');
                    } else {
                      checkBoxCamera = true;
                      facilitySelected.add('Camera');
                    }
                    if (facilitySelected.isNotEmpty) {
                      if (facilitySelected.length > 1) {
                        _facilityController.text = "TV & Camera";
                      } else if (facilitySelected.length == 1) {
                        _facilityController.text =
                            facilitySelected[0].toString();
                      }
                    } else {
                      _facilityController.text = "None";
                    }
                    print(facilitySelected);

                    setState(() {});
                  },
                  cameraValue: checkBoxCamera,
                  tvValue: checkBoxTv,
                ),
              ),
            ),
            Visibility(
              visible: participantContainerVisible,
              child: Positioned(
                top: 485,
                right: 575,
                child: ParticipantContainer(
                  setParticipantStatus: setParticipantStatus,
                  onChangeParticipant: onParticipanSelected,
                ),
              ),
            ),
            Visibility(
              visible: timePickerContainerVisible,
              child: Positioned(
                top: 485,
                left: 408,
                child: TimePickerContainer(
                  startTimeStatus: startTimeContainerVisible,
                  endTimeStatus: endTimeContainerVisible,
                  setTime: setTime,
                  startTime: startTime,
                  endTime: endTime,
                  setTimePickerStatus: setTimePickerStatus,
                  setListStartTime: setStartTimeList,
                  setEndTimeStatus: setEndTimeStatus,
                  setListEndTime: setEndTimeList,
                  setStartTimeStatus: setStartTimeStatus,
                  initialEndTime: initialEndTime,
                ),
              ),
            ),
            Visibility(
              visible: startTimeContainerVisible,
              child: Positioned(
                top: 595,
                left: 425,
                child: StartTimeContainer(
                  items: startTimeList,
                  setStartTime: setStartTime,
                  setStartTimeStatus: setStartTimeStatus,
                  setInitialEndTime: setInitialEndTime,
                ),
              ),
            ),
            Visibility(
              visible: endTimeContainerVisible,
              child: Positioned(
                top: 595,
                left: 545,
                child: EndTimeContainer(
                  items: endTimeList,
                  setEndTime: setEndTime,
                  setEndTimeStatus: setEndTimeStatus,
                  startTime: startTime,
                  setTime: setTime,
                ),
              ),
            )
          ],
        ),
      ),
    );
    return Consumer<MainModel>(builder: (context, model, child) {
      return Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: pageConstraints,
            child: Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            // model.navbarShadow
                            BoxShadow(
                              blurRadius: !model.shadowActive ? 0 : 40,
                              offset: !model.shadowActive
                                  ? Offset(0, 0)
                                  : Offset(0, 0),
                              color: Color.fromRGBO(29, 29, 29, 0.1),
                            )
                          ],
                        ),
                        child: NavigationBarWeb(
                          index: 0,
                          popUpProfile: popUpProfile,
                        ),
                      ),
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
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
                                              image: AssetImage(
                                                  'assets/gapps.png'),
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
                                                      Color.fromARGB(
                                                          0, 255, 255, 255),
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
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        'Link your Google Account',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        'Link your Google Account',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                    ],
                  ),
                  Positioned(
                    right: 20,
                    top: 65,
                    child: Visibility(
                      visible: profileVisible,
                      child: Container(
                        // color: Colors.amber,
                        child: PopUpProfile(
                          name: 'Luthfi',
                          email: 'luthfiizhar@gmail.com',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
