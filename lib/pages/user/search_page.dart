import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/widgets/amenities_container.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/end_time_container.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/meeting_type_container.dart';
import 'package:meeting_room_booking_system/widgets/participant_container.dart';
import 'package:meeting_room_booking_system/widgets/search_container.dart';
import 'package:meeting_room_booking_system/widgets/search_page/filter_container.dart';
import 'package:meeting_room_booking_system/widgets/search_page/list_card.dart';
import 'package:meeting_room_booking_system/widgets/search_page/sorting_container.dart';
import 'package:meeting_room_booking_system/widgets/start_time_container.dart';
import 'package:meeting_room_booking_system/widgets/time_picker_container.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    Key? key,
    this.queryParam = "",
  }) : super(key: key);

  dynamic queryParam;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ReqAPI apiReq = ReqAPI();
  ScrollController scrollController = ScrollController();
  MainModel mainModel = MainModel();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _facilityController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _participantController = TextEditingController();
  DateRangePickerController datePickerControl = DateRangePickerController();

  bool isAccSyncToGoogle = false;

  bool showOnBoard = false;
  bool opacityOn = false;

  bool profileVisible = false;
  // final loginInfo = MainModel();

  bool checkBoxTv = false;
  bool checkBoxCamera = false;
  bool isSearching = false;
  List facilitySelected = [];
  List startTimeList = [];
  List endTimeList = [];
  List searchResult = [];
  String participantSelected = "";
  String startTime = "";
  String endTime = "";
  String initialEndTime = "";
  String meetingTypeName = "Meeting Room";
  String meetingTypeValue = "MeetingRoom";
  String coverPhotoRoomType = "";
  String roomName = "";
  String buildingName = "";
  List roomType = [];
  String sort = "floor_lowest";
  dynamic resultArea;

  List<RadioModel> listSorting = [
    RadioModel(isSelected: false, text: 'Lowest Floor', value: 'floor_lowest'),
    RadioModel(
        isSelected: false, text: 'Highest Floor', value: 'floor_highest'),
    RadioModel(
        isSelected: false, text: 'Lowest Capacity', value: 'capacity_lowest'),
    RadioModel(
        isSelected: false, text: 'Highest Capacity', value: 'capacity_highest'),
    RadioModel(isSelected: false, text: 'Alphabetical', value: 'alphabetical'),
  ];
  String selectedSorting = "Lowest Floor";

  List<CheckBoxModel>? listFilter = [];
  List submitFilter = [];
  List selectedFilter = ['1', '2', '3', '4'];

  DateTime selectedDate = DateTime.now();
  String selectedDateFormatted = "";

  List<TargetFocus> targets = [];
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  GlobalKey key6 = GlobalKey();

  Future autoScroll(BuildContext context, MainModel model) async {
    model.setAutoScrollSearch(true);
    // Scrollable.ensureVisible(
    //   datakey!.currentContext!,
    //   duration: Duration(seconds: 1),
    //   curve: Curves.easeInOut,
    // );
  }

  // Future showTutorial() async {
  //   tutorialCoachMark = TutorialCoachMark(
  //     targets: targets, // List<TargetFocus>
  //     // colorShadow: Colors.red, // DEFAULT Colors.black
  //     // alignSkip: Alignment.bottomRight,
  //     // textSkip: "SKIP",
  //     // paddingFocus: 10,
  //     // opacityShadow: 0.8,
  //     onClickTarget: (target) {},
  //     onClickTargetWithTapPosition: (target, tapDetails) {
  //       print("target: $target");
  //       print(
  //           "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
  //     },
  //     onClickOverlay: (target) {},
  //     onSkip: () {
  //       Provider.of<MainModel>(context, listen: false).onBoardDone();
  //     },
  //     onFinish: () {},
  //   );
  //   // TutorialCoachMark().show(context: context);
  //   if (Provider.of<MainModel>(context, listen: false).firstLogin) {
  //     tutorialCoachMark.show(context: context);
  //   }
  //   // return "";
  // }

  addTarget() {
    targets.add(
      TargetFocus(
        identify: "Area Type",
        keyTarget: meetingTypeKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
              align: ContentAlign.right,
              // customPosition: CustomTargetContentPosition(top: 100, right: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Area Type",
                    style: helveticaText.copyWith(
                      color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Choose between Meeting Room, Auditorium, and Social Hub.",
                      style: helveticaText.copyWith(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: WhiteRegularButton(
                      disabled: false,
                      onTap: () {
                        tutorialCoachMark.next();
                      },
                      text: 'Next',
                      padding: ButtonSize().smallSize(),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Seaerch Setting",
        keyTarget: searchContainerKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              // customPosition: CustomTargetContentPosition(top: 100, right: 200),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                    minWidth: 1000,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search Settings",
                        style: helveticaText.copyWith(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Search a room by Date, Time, Total Participant, and Room Facilities you need.",
                          style: helveticaText.copyWith(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: WhiteRegularButton(
                          disabled: false,
                          onTap: () {
                            tutorialCoachMark.next();
                          },
                          text: 'Next',
                          padding: ButtonSize().smallSize(),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Search Button",
        keyTarget: buttonSearchKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              // customPosition: CustomTargetContentPosition(top: 100, right: 200),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                    minWidth: 1000,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Search Button",
                              style: helveticaText.copyWith(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Click button and choose the area you want.",
                                style: helveticaText.copyWith(
                                  color: white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: WhiteRegularButton(
                            disabled: false,
                            onTap: () {
                              tutorialCoachMark.finish();
                            },
                            text: 'Done',
                            padding: ButtonSize().smallSize(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))
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

  initTime() {
    dynamic hour = TimeOfDay.now().hour;
    dynamic minute = TimeOfDay.now().minute;
    dynamic endMinute;
    dynamic endHour;
    if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
      minute = TimeOfDay.now().replacing(minute: 15).minute;
    } else if (TimeOfDay.now().minute > 15 && TimeOfDay.now().minute <= 30) {
      minute = TimeOfDay.now().replacing(minute: 30).minute;
    } else if (TimeOfDay.now().minute > 30 && TimeOfDay.now().minute <= 45) {
      minute = TimeOfDay.now().replacing(minute: 45).minute;
    } else if (TimeOfDay.now().minute > 45 && TimeOfDay.now().minute <= 60) {
      minute = TimeOfDay.now().replacing(minute: 0).minute;
      hour = hour + 1;
    }
    endMinute = minute;
    endHour = hour + 1;
    if (endMinute == 60) {
      endHour = hour;
      endMinute = 0;
    }
    hour = hour.toString().padLeft(2, '0');
    minute = minute.toString().padLeft(2, '0');

    endHour = endHour.toString().padLeft(2, '0');
    endMinute = endMinute.toString().padLeft(2, '0');
    setState(() {
      startTime = "$hour:$minute";
      endTime = "$endHour:$endMinute";
      _timeController.text = "$startTime - $endTime";
    });
  }

  initUserProfile() {
    apiReq.getUserProfile().then((value) {
      if (value['Status'].toString() == "200") {
        // if (value['Data']['Admin'].toString() == "1") {
        //   setState(() {
        //     isUserAdmin = true;
        //   });
        // }
        if (value['Data']['GoogleAccountSync'].toString() == "1") {
          setState(() {
            isAccSyncToGoogle = true;
          });
        }
        if (value['Data']['GoogleAccountSync'].toString() == "0") {
          setState(() {
            isAccSyncToGoogle = false;
          });
        }
      } else {
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialogBlack(
        //     title: value['Title'],
        //     contentText: value['Message'],
        //     isSuccess: false,
        //   ),
        // );
      }
    }).onError((error, stackTrace) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
    _facilityController.dispose();
    _timeController.dispose();
    _participantController.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initUserProfile();
    apiReq.getAreaList().then((value) {
      if (value['Status'].toString() == "200") {
        setState(() {
          resultArea = value['Data'];
          for (var element in resultArea) {
            listFilter!.add(CheckBoxModel(
              name: element['AreaName'],
              value: element['AreaID'].toString(),
              selected: true,
            ));
            // submitFilter.add("\"${element['AreaID']}\"");
          }
        });
        // print(submitFilter);
        // print(listFilter);
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
    }).then((value) {
      // print(widget.queryParam);
      if (widget.queryParam.isNotEmpty) {
        // print('dr Home');

        searchFromHome(mainModel);
      } else {
        // print('bukan dari home');
        String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
        _dateController.text = formattedDate;
        _facilityController.text = 'None';
        _participantController.text = 'Total Participant';
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
    apiReq.getRoomType().then((value) {
      // print(value);
      if (value['Status'] == "200") {
        roomType = value['Data'];
        for (var element in roomType) {
          if (element['Value'] == meetingTypeValue) {
            setState(() {
              coverPhotoRoomType = element['Image'];
              roomName = element['RoomName'];
              buildingName = element['BuildingName'] ?? "Head Office";
            });
          }
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
    initTime();
    checkOnBoardingPage();

    scrollController.addListener(() {});
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
    var box = await Hive.openBox('onBoarding');

    var firstLogin = box.get('firstLogin') ?? true;

    showOnBoard = firstLogin;
    if (showOnBoard) {
      tutorialCoachMark = TutorialCoachMark(
          targets: targets,
          onFinish: () async {
            print('finish tutorial');
            var box = await Hive.openBox('onBoarding');
            box.put("firstLogin", false);
            showOnBoard = false;
          },
          skipWidget: WhiteRegularButton(
            text: 'Skip',
            disabled: false,
            onTap: () {
              tutorialCoachMark.skip();
            },
            padding: ButtonSize().smallSize(),
          ));
      addTarget();
      tutorialCoachMark.show(context: context);
    }

    setState(() {});
  }

  showBoardingPage() {
    // print(Provider.of<MainModel>(context, listen: false).firstLogin);
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
  GlobalKey buttonSearchKey = GlobalKey();

  final dataKey = GlobalKey();

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
    // setOpacityOn(false);
    setState(() {});
  }

  setEndTimeList(List value) {
    endTimeList = value;
    // setOpacityOn(false);
    setState(() {});
  }

  onDateChanged(String value, DateTime date) {
    datePicked = value;
    selectedDate = date;
    _dateController.text = datePicked;
    if (DateFormat('yyyy-MM-dd').format(date) !=
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      startTime = '07:00';
      endTime = '07:15';
    } else {
      dynamic hour = TimeOfDay.now().hour;
      dynamic minute = TimeOfDay.now().minute;
      dynamic endMinute = minute;
      dynamic endHour = hour;
      if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
        minute = TimeOfDay.now().replacing(minute: 15).minute;
      } else if (TimeOfDay.now().minute > 15 && TimeOfDay.now().minute <= 30) {
        minute = TimeOfDay.now().replacing(minute: 30).minute;
      } else if (TimeOfDay.now().minute > 30 && TimeOfDay.now().minute <= 45) {
        minute = TimeOfDay.now().replacing(minute: 45).minute;
      } else if (TimeOfDay.now().minute > 45 && TimeOfDay.now().minute <= 60) {
        minute = TimeOfDay.now().replacing(minute: 0).minute;
        hour = hour + 1;
      }
      endMinute = minute + 15;
      if (endMinute == 60) {
        endHour = hour;
        endMinute = 0;
      }
      hour = hour.toString().padLeft(2, '0');
      minute = minute.toString().padLeft(2, '0');

      endHour = endHour.toString().padLeft(2, '0');
      endMinute = endMinute.toString().padLeft(2, '0');

      startTime = "$hour:$minute";
      endTime = "$hour:$endMinute";
    }

    _timeController.text = "$startTime - $endTime";
    setOpacityOn(false);
    setState(() {});
  }

  onParticipanSelected(String value) {
    participantSelected = value;
    _participantController.text = "$participantSelected Person";
    setOpacityOn(false);
    setState(() {});
  }

  onMeetingTypeSelected(String value, String name, String url, String nameRoom,
      String nameBuilding) {
    setState(() {
      meetingTypeValue = value;
      meetingTypeName = name;
      coverPhotoRoomType = url;
      roomName = nameRoom;
      buildingName = nameBuilding;
      setOpacityOn(false);
    });
  }

  setStartTime(String start) {
    startTime = start;

    var hour = int.parse(start.split(':').first);
    var minute = int.parse(start.split(':').last);
    var minuteEnd = minute;
    var hourEnd = hour + 1;
    if (minuteEnd == 60) {
      hourEnd = hourEnd + 1;
      minuteEnd = 0;
    }

    endTime =
        "${hourEnd.toString().padLeft(2, '0')}:${minuteEnd.toString().padLeft(2, '0')}";
    _timeController.text = "$startTime - $endTime";
    setState(() {});
  }

  setEndTime(String end) {
    endTime = end;

    setOpacityOn(false);
    setTimePickerStatus(false);
    setEndTimeStatus(false);
    setState(() {});
  }

  setInitialEndTime(String value) {
    // initialEndTime = value;
    endTime = value;
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

  onChangeFilter() {
    // print(listFilter);
    submitFilter.clear();
    for (var element in listFilter!) {
      if (element.selected!) {
        submitFilter.add("\"${element.value}\"");
      }
    }
    List listAmen = [];
    for (var element in facilitySelected) {
      listAmen.add('"$element"');
    }

    // print(listAmen);
    apiReq
        .searchRoomApi(
      selectedDateFormatted,
      startTime,
      endTime,
      participantSelected,
      listAmen,
      meetingTypeValue,
      submitFilter,
      sort,
    )
        .then((value) {
      if (value['Status'] == "200") {
        setState(() {
          isSearching = false;
          searchResult = value["Data"]["Room"];
        });
      } else {
        setState(() {
          isSearching = false;
        });
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
          title: 'Can\'t Connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      ).then((value) {
        setState(() {
          isSearching = false;
        });
      });
    });
  }

  onChangeSorting(String value, String text) {
    // print(value);
    List listAmen = [];
    for (var element in facilitySelected) {
      listAmen.add('"$element"');
    }
    setState(() {
      selectedSorting = text;
    });
    sort = value;

    // print(listAmen);
    apiReq
        .searchRoomApi(
      selectedDateFormatted,
      startTime,
      endTime,
      participantSelected,
      listAmen,
      meetingTypeValue,
      submitFilter,
      sort,
    )
        .then((value) {
      if (value['Status'].toString() == "200") {
        setState(() {
          isSearching = false;
          searchResult = value["Data"]["Room"];
        });
      } else {
        setState(() {
          isSearching = false;
        });
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
          title: 'Failed Connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      ).then((value) {
        setState(() {
          isSearching = false;
        });
      });
    });
  }

  searchFromHome(MainModel model) {
    autoScroll(context, model);
    dynamic date = DateTime.parse(widget.queryParam['date']);
    List listAmen = [];
    // print('facility-> ${widget.queryParam['facility']}');
    setState(() {
      if (submitFilter.isEmpty) {
        // print('masuk sini');
        for (var element in listFilter!) {
          element.selected = true;
        }
        for (var element in listFilter!) {
          submitFilter.add("\"${element.value}\"");
        }
      }

      if (widget.queryParam['facility'] == "[]") {
        _facilityController.text = 'None';
      } else {
        List listFacility = json.decode(widget.queryParam['facility']);
        if (listFacility.length > 1) {
          _facilityController.text = listFacility[0] + " & " + listFacility[1];
        } else {
          _facilityController.text = listFacility.first;
          facilitySelected = listFacility;

          for (var element in listFacility) {
            listAmen.add('"$element"');
          }
        }
      }

      selectedDateFormatted = DateFormat('yyyy-MM-dd').format(selectedDate);
      _dateController.text = DateFormat('dd MMM yyyy').format(selectedDate);
      // _facilityController.text = widget.queryParam['facility'];
      _timeController.text =
          widget.queryParam['startTime'] + ' - ' + widget.queryParam['endTime'];
      _participantController.text =
          widget.queryParam['participant'] + " Person";
      selectedDate = date;
      startTime = widget.queryParam['startTime'];
      endTime = widget.queryParam['endTime'];
      participantSelected = widget.queryParam['participant'];

      meetingTypeValue = widget.queryParam['roomTypeValue'];
      meetingTypeName = widget.queryParam['roomTypeName'];

      apiReq
          .searchRoomApi(
        selectedDateFormatted,
        startTime,
        endTime,
        participantSelected,
        listAmen,
        meetingTypeValue,
        submitFilter,
        sort,
      )
          .then((value) {
        // print(value);
        if (value['Status'] == "200") {
          setState(() {
            isSearching = false;
            searchResult = value["Data"]["Room"];
          });
        } else {
          setState(() {
            isSearching = false;
          });
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
    });
  }

  searchRoom(MainModel model) {
    autoScroll(context, model);
    setOpacityOn(false);
    if (participantSelected == "") {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogBlack(
          title: 'Failed',
          contentText: 'Please choose total Participants',
          isSuccess: false,
        ),
      );
    } else {
      setState(() {
        isSearching = true;
      });
      selectedDateFormatted = DateFormat('yyyy-MM-dd').format(selectedDate);

      if (submitFilter.isEmpty) {
        for (var element in listFilter!) {
          element.selected = true;
        }
        for (var element in resultArea) {
          submitFilter.add("\"${element['AreaID']}\"");
        }
      }
      List listAmen = [];
      for (var element in facilitySelected) {
        listAmen.add('"$element"');
      }

      // print(listAmen);
      apiReq
          .searchRoomApi(
        selectedDateFormatted,
        startTime,
        endTime,
        participantSelected,
        listAmen,
        meetingTypeValue,
        submitFilter,
        sort,
      )
          .then((value) {
        print(value);
        if (value['Status'].toString() == "200") {
          setState(() {
            isSearching = false;
            searchResult = value["Data"]["Room"];
          });
        } else {
          setState(() {
            isSearching = false;
          });
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
            title: 'Failed Connect to API',
            contentText: error.toString(),
            isSuccess: false,
          ),
        ).then((value) {
          setState(() {
            isSearching = false;
          });
        });
      });
    }
  }

  resetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 1,
      model: mainModel,
      scrollController: scrollController,
      resetState: resetState,
      setDatePickerStatus: resetAllVisibleStatus,
      child: Consumer<MainModel>(builder: (context, model, child) {
        return ConstrainedBox(
          constraints: pageConstraints,
          child: Form(
            // key: _formKey,
            // child: searchRoom(),
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
                                                //   image: NetworkImage(
                                                //     coverPhotoRoomType,
                                                //     scale: 0.5,
                                                //   ),
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              child: coverPhotoRoomType == ""
                                                  ? SizedBox()
                                                  : CachedNetworkImage(
                                                      filterQuality:
                                                          FilterQuality.none,
                                                      imageUrl:
                                                          coverPhotoRoomType,
                                                      imageBuilder: (context,
                                                          imageProvider) {
                                                        return Container(
                                                          width: 1100,
                                                          height: 400,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: graySand,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image:
                                                                DecorationImage(
                                                              image: Image(
                                                                image:
                                                                    imageProvider,
                                                              ).image,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 185,
                                            right: 0,
                                            child: Container(
                                              // color: Colors.black,
                                              decoration: const BoxDecoration(
                                                color: eerieBlack,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              padding: const EdgeInsets.only(
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
                                                    roomName,
                                                    style:
                                                        helveticaText.copyWith(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: culturedWhite,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '- $buildingName',
                                                    style:
                                                        helveticaText.copyWith(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                                searchSettingsKey:
                                                    searchContainerKey,
                                                buttonSearchKey:
                                                    buttonSearchKey,
                                                dateNode: dateNode,
                                                getPositionDatePicker:
                                                    getPositionDatePicker,
                                                getPositionAmenities:
                                                    getPositionAmenities,
                                                getPositionparticipant:
                                                    getPositionParticipant,
                                                setPickerStatus:
                                                    setDatePickerVisible,
                                                setAmenitiesStatus:
                                                    setAmenitiesStatus,
                                                setParticipantStatus:
                                                    setParticipantStatus,
                                                setTimeStatus:
                                                    setTimePickerStatus,
                                                setStartTimeStatus:
                                                    setStartTimeStatus,
                                                setEndTimeStatus:
                                                    setEndTimeStatus,
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
                                                    meetingTypeValue,
                                                meetingTypeName:
                                                    meetingTypeName,
                                                meetingTypeStatus:
                                                    meetingTypeContainerVisible,
                                                setMeetingTypeStatus:
                                                    setMeetingTypeContainerStatus,
                                                dateKey: dateKey,
                                                timeKey: timeKey,
                                                amenitiesKey: amenitiesKey,
                                                meetingTypeKey: meetingTypeKey,
                                                participantKey: participantKey,
                                                datakey: dataKey,
                                                searchRoom: searchRoom,
                                                roomTypeCover:
                                                    coverPhotoRoomType,
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
                                                    child: Visibility(
                                                      visible: searchResult
                                                                  .isEmpty &&
                                                              submitFilter
                                                                  .isEmpty
                                                          ? false
                                                          : true,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SortingContainer(
                                                            listSorting:
                                                                listSorting,
                                                            selectedSorting:
                                                                selectedSorting,
                                                            onChangeSorting:
                                                                onChangeSorting,
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          FilterContainer(
                                                            key: dataKey,
                                                            listFilter:
                                                                listFilter,
                                                            onChangeFilter:
                                                                onChangeFilter,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 35,
                                                  ),
                                                  Expanded(
                                                    child: isSearching
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: eerieBlack,
                                                            ),
                                                          )
                                                        : searchResult.isEmpty
                                                            ? Visibility(
                                                                visible: searchResult
                                                                            .isEmpty &&
                                                                        submitFilter
                                                                            .isEmpty
                                                                    ? false
                                                                    : true,
                                                                child: SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 200,
                                                                  child: Center(
                                                                    child: Text(
                                                                      'No room available at the moment',
                                                                      style: helveticaText
                                                                          .copyWith(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        color:
                                                                            davysGray,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                child: ListView
                                                                    .builder(
                                                                  // physics: NeverScrollableScrollPhysics,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      searchResult
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return ListRoomContainer(
                                                                      roomID: searchResult[
                                                                              index]
                                                                          [
                                                                          'RoomID'],
                                                                      roomName:
                                                                          searchResult[index]
                                                                              [
                                                                              'RoomName'],
                                                                      duration:
                                                                          searchResult[index]
                                                                              [
                                                                              'Duration'],
                                                                      amenities:
                                                                          searchResult[index]
                                                                              [
                                                                              'Amenities'],
                                                                      endTime: searchResult[
                                                                              index]
                                                                          [
                                                                          'EndTime'],
                                                                      floor: searchResult[
                                                                              index]
                                                                          [
                                                                          'AreaName'],
                                                                      startTime:
                                                                          searchResult[index]
                                                                              [
                                                                              'StartTime'],
                                                                      minCapacity:
                                                                          searchResult[index]['MinCapacity']
                                                                              .toString(),
                                                                      maxCapacity:
                                                                          searchResult[index]['MaxCapacity']
                                                                              .toString(),
                                                                      photo: searchResult[
                                                                              index]
                                                                          [
                                                                          'Photo'],
                                                                      date:
                                                                          selectedDateFormatted,
                                                                      selectedStartTime:
                                                                          startTime,
                                                                      selectedEndTime:
                                                                          endTime,
                                                                    );
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
                                              Visibility(
                                                visible: isAccSyncToGoogle
                                                    ? false
                                                    : true,
                                                child: InkWell(
                                                  onTap: () {
                                                    context.go('/gws');
                                                  },
                                                  child:
                                                      const WhiteBannerLandscape(
                                                    title:
                                                        'Link your Google account',
                                                    subtitle:
                                                        '& enjoy your benefits.',
                                                    imagePath:
                                                        'assets/banner_pict_google.png',
                                                  ),
                                                ),
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
                                              constraints: const BoxConstraints(
                                                minHeight: 1000,
                                                minWidth: 1366,
                                                // minWidth: 1000,
                                                // maxWidth: 1366,
                                              ),
                                              child: Container(
                                                color: Colors.white
                                                    .withOpacity(0.5),
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
                        selectedMeetingType: meetingTypeValue,
                        setMeetingTypeStatus: setMeetingTypeContainerStatus,
                        meetingType: roomType,
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
                        maxDate: selectedDate.add(const Duration(days: 30)),
                        canPickPastDay: false,
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
                          // print(facilitySelected);
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
                              _facilityController.text = facilitySelected[0];
                            }
                          } else {
                            _facilityController.text = "None";
                          }
                          // print(facilitySelected);

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
                        initialEndTime: endTime,
                        selectedDate: selectedDate,
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
          ),
        );
      }),
    );
  }
}
