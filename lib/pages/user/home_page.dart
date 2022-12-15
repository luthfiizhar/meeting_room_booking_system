import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/end_time_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/feature_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/greeting_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/home_search_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/upcoming_event_container.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
  String datePicked = "";
  String meetingTypeSelected = "Meeting Room";

  DateTime selectedDate = DateTime.now();

  bool datePickerVisible = false;
  bool amenitiesContainerVisible = false;
  bool participantContainerVisible = false;
  bool timePickerContainerVisible = false;
  bool startTimeContainerVisible = false;
  bool endTimeContainerVisible = false;
  bool meetingTypeContainerVisible = false;

  ScrollController scrollController = ScrollController();

  scrollListener(ScrollController scrollInfo) {}
  initTime() {
    int minute = TimeOfDay.now().minute;
    int hour = TimeOfDay.now().hour;
    int minuteEndInit = 0;
    int hourEndInit = 0;
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
    minuteEndInit = int.parse(minuteString) + 15;
    hourEndInit = hour;
    var minuteEndString = minuteEndInit.toString();
    print(minuteEndInit);
    if (minuteEndInit == 60) {
      print('masuk sini');

      minuteEndString =
          TimeOfDay(hour: hour, minute: 0).minute.toString().padLeft(2, '0');
      // print(hour);
      // print(hourEndInit);
      print(minuteEndString);
    }
    // minuteEndString = minuteEndInit.toString();
    startTime = "$hourString:$minuteString";
    initialEndTime =
        "${hourEndInit.toString().padLeft(2, '0')}:${minuteEndString.toString().padLeft(2, '0')}";
    endTime = initialEndTime;
    print('endTime -> $endTime');
  }

  @override
  void dispose() {
    // _controller.dispose();
    _dateController.dispose();
    _participantController.dispose();
    _timeController.dispose();
    _facilityController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
    _dateController.text = formattedDate;
    _facilityController.text = 'None';
    _timeController.text = 'Choose Time';
    _participantController.text = '1';
    participantSelected = "1";

    initTime();
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
    if (value) {
      setOpacityOn(true);
    } else {
      setOpacityOn(false);
    }
    datePickerVisible = value;
    // _datePickerOverlay(context);
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
    setOpacityOn(false);
    setState(() {});
  }

  setTimePickerStatus(bool value) {
    timePickerContainerVisible = value;
    opacityOn = value;
    setState(() {});
  }

  setListStartTime(List value) {
    startTimeList = value;
    // setOpacityOn(false);
    setState(() {});
  }

  setListEndTime(List value) {
    endTimeList = value;
    // setOpacityOn(false);
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

  setTime(String start, String end) {
    startTime = start;
    endTime = end;
    _timeController.text = "$startTime - $endTime";
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

  setParticipantStatus(bool value) {
    participantContainerVisible = value;
    opacityOn = value;
    setState(() {});
  }

  onParticipanSelected(String value) {
    participantSelected = value;
    _participantController.text = participantSelected;
    setOpacityOn(false);
    setState(() {});
  }

  setAmenitiesStatus(bool value) {
    amenitiesContainerVisible = value;
    opacityOn = value;
    setState(() {});
  }

  search() {
    String selectedDateFormatted = DateFormat('yyyy-M-dd').format(selectedDate);

    List listAmen = [];
    for (var element in facilitySelected) {
      listAmen.add('"$element"');
    }

    context.goNamed(
      'search',
      queryParams: {
        'date': selectedDate.toString(),
        'startTime': startTime,
        'endTime': endTime,
        'participant': participantSelected,
        'facility': listAmen.toString(),
      },
    );

    // print("""
    //   $selectedDateFormatted,
    //   $startTime,
    //   $endTime,
    //   $participantSelected,
    //   ${listAmen.toString()},
    // """);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      scrollController: scrollController,
      index: 0,
      setDatePickerStatus: resetAllVisibleStatus,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 40,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        row1(),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: row2(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              opacityOn
                  ? Center(
                      child: ConstrainedBox(
                        constraints: pageConstraints.copyWith(
                          minHeight: MediaQuery.of(context).size.width,
                        ),
                        child: InkWell(
                          onTap: () {
                            resetAllVisibleStatus(false);
                          },
                          child: Container(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              Visibility(
                visible: datePickerVisible,
                child: Positioned(
                  left: 265,
                  top: 285,
                  child: CustomDatePicker(
                    controller: datePickerControl,
                    isDark: true,
                    changeDate: onDateChanged,
                    currentDate: selectedDate,
                    setPickerStatus: setDatePickerVisible,
                  ),
                ),
              ),
              Visibility(
                visible: timePickerContainerVisible,
                child: Positioned(
                  left: 465,
                  top: 285,
                  child: TimePickerContainer(
                    // controller: datePickerControl,
                    endTime: endTime,
                    startTime: startTime,
                    initialEndTime: initialEndTime,
                    endTimeStatus: endTimeContainerVisible,
                    startTimeStatus: startTimeContainerVisible,
                    isDark: true,
                    selectedDate: selectedDate,
                    setEndTimeStatus: setEndTimeStatus,
                    setStartTimeStatus: setStartTimeStatus,
                    setListEndTime: setListEndTime,
                    setListStartTime: setListStartTime,
                    setTime: setTime,
                    setTimePickerStatus: setTimePickerStatus,
                  ),
                ),
              ),
              Visibility(
                visible: startTimeContainerVisible,
                child: Positioned(
                  top: 395,
                  left: 475,
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
                  top: 395,
                  left: 595,
                  child: EndTimeContainer(
                    items: endTimeList,
                    setEndTime: setEndTime,
                    setEndTimeStatus: setEndTimeStatus,
                    startTime: startTime,
                    setTime: setTime,
                  ),
                ),
              ),
              Visibility(
                visible: participantContainerVisible,
                child: Positioned(
                  left: 265,
                  top: 365,
                  child: ParticipantContainer(
                    setParticipantStatus: setParticipantStatus,
                    onChangeParticipant: onParticipanSelected,
                  ),
                ),
              ),
              Visibility(
                visible: amenitiesContainerVisible,
                child: Positioned(
                  left: 465,
                  top: 365,
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
                          _facilityController.text = facilitySelected[0];
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
            ],
          ),
        ),
      ),
    );
  }

  Widget row1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const GreetingContainer(),
        const SizedBox(
          height: 30,
        ),
        HomeRoomSearchContainer(
          dateController: _dateController,
          participantController: _participantController,
          timeController: _timeController,
          facilityController: _facilityController,
          setDatePickerStatus: setDatePickerVisible,
          datePickerStatus: datePickerVisible,
          setTimeContainerStatus: setTimePickerStatus,
          timePickerStatus: timePickerContainerVisible,
          setParticipantStatus: setParticipantStatus,
          participantStatus: participantContainerVisible,
          setAmenitiesStatus: setAmenitiesStatus,
          amenitiesStatus: amenitiesContainerVisible,
          searchRoom: search,
        ),
        const SizedBox(
          height: 30,
        ),
        UpcomingEventContainer(),
        const SizedBox(
          height: 30,
        ),
        InkWell(
          onTap: () {
            context.go('/gws');
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 780,
              minWidth: 780,
            ),
            child: const WhiteBannerLandscape(
              title: 'Link your Google account',
              subtitle: '& enjoy your benefits.',
              imagePath: 'assets/banner_pict_google.png',
            ),
          ),
        ),
      ],
    );
  }

  Widget row2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 690,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: davysGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: platinum,
                width: 1,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 375,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: davysGray,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: platinum,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
