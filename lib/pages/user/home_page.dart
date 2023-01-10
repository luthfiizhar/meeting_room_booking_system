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
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';
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
import 'package:meeting_room_booking_system/widgets/home_page/apporval_message.dart';
import 'package:meeting_room_booking_system/widgets/home_page/available_room_offer_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/feature_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/greeting_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/home_search_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/room_type_home_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/schedule_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/statistic_container.dart';
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
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:js' as js;
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.index = 0}) : super(key: key);
  int index;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ReqAPI apiReq = ReqAPI();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
  List roomTypeList = [];
  String participantSelected = "";
  String startTime = "";
  String endTime = "";
  String initialEndTime = "";
  String datePicked = "";
  String meetingTypeSelected = "Meeting Room";
  String roomTypeName = "Meeting Room";
  String roomTypeValue = "MeetingRoom";
  String roomTypeImage = "";

  List? upcomingData = [];
  String emptyMessage = "";

  DateTime selectedDate = DateTime.now();

  bool datePickerVisible = false;
  bool amenitiesContainerVisible = false;
  bool participantContainerVisible = false;
  bool timePickerContainerVisible = false;
  bool startTimeContainerVisible = false;
  bool endTimeContainerVisible = false;
  bool meetingTypeContainerVisible = false;
  bool initLoading = true;

  bool isAccSyncToGoogle = false;

  bool isUserAdmin = false;

  ScrollController scrollController = ScrollController();

  setIsUserAdmin(bool value) {
    setState(() {
      isUserAdmin = false;
    });
  }

  scrollListener(ScrollController scrollInfo) {}
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

  initRoomType() {
    apiReq.getRoomType().then((value) {
      setState(() {
        initLoading = false;
      });
      if (value["Status"] == "200") {
        roomTypeList = value['Data'];
        for (var element in roomTypeList) {
          if (element['Value'] == roomTypeValue) {
            setState(() {
              roomTypeImage = element['Image'];
            });
          }
        }
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

  initUpcomingEvent() {
    apiReq.getUpcomingEvent().then((value) {
      // print(value);
      if (value['Status'] == "200") {
        setState(() {
          upcomingData = [value['Data']];
          emptyMessage = value['Message'];
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
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  initGetUserProfile() {
    apiReq.getUserProfile().then((value) {
      if (value['Status'].toString() == "200") {
        if (value['Data']['Admin'].toString() == "1") {
          setState(() {
            isUserAdmin = true;
          });
        }
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
  void dispose() {
    // _controller.dispose();
    _dateController.dispose();
    _participantController.dispose();
    _timeController.dispose();
    _facilityController.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
    _dateController.text = formattedDate;
    _facilityController.text = 'None';
    _timeController.text = 'Choose Time';
    _participantController.text = '2';
    participantSelected = "2";

    initTime();
    initRoomType();
    initGetUserProfile();
    // initUpcomingEvent();
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
      dynamic endHour = hour + 1;
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
      // endMinute = minute + 15;
      // endHour = endHour + 1;
      if (endMinute == 60) {
        endHour = hour;
        endMinute = 0;
      }
      hour = hour.toString().padLeft(2, '0');
      minute = minute.toString().padLeft(2, '0');

      endHour = endHour.toString().padLeft(2, '0');
      endMinute = endMinute.toString().padLeft(2, '0');

      startTime = "$hour:$minute";
      endTime = "$endHour:$endMinute";
    }
    _timeController.text = "$startTime - $endTime";
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
    timePickerContainerVisible = false;
    endTimeContainerVisible = false;
    opacityOn = false;
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

  setMeetingTypeContainerStatus(bool value) {
    meetingTypeContainerVisible = value;
    opacityOn = value;
    setState(() {});
  }

  changeRoomType(String value, String name, String url) {
    roomTypeValue = value;
    roomTypeName = name;
    roomTypeImage = url;
    setOpacityOn(false);
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
        'roomTypeValue': roomTypeValue,
        'roomTypeName': roomTypeName,
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

  resetState() {
    // super.initState();
    // scaffoldKey.currentState!.setState(() {});
    // print('resetHome');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      resetState: resetState,
      scrollController: scrollController,
      index: widget.index,
      setDatePickerStatus: resetAllVisibleStatus,
      child: ConstrainedBox(
        constraints: pageConstraints.copyWith(
            // maxHeight: 2000,
            ),
        child: jwtToken == "" || jwtToken == null
            ? const Align(
                alignment: Alignment.center,
                child: Text(''),
              )
            : !isTokenValid
                ? const Align(
                    alignment: Alignment.center,
                    child: Text(''),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 40,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Table(
                            //   columnWidths: const {
                            //     0: FlexColumnWidth(4.5),
                            //     1: FlexColumnWidth(2)
                            //   },
                            //   children: [
                            //     TableRow(
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.only(
                            //             right: 25,
                            //           ),
                            //           child: row1(),
                            //         ),
                            //         TableCell(
                            //           verticalAlignment:
                            //               TableCellVerticalAlignment.fill,
                            //           child: Container(
                            //             alignment: Alignment.center,
                            //             child: row2(),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ResponsiveRowColumn(
                            //   layout: MediaQuery.of(context).size.width < 1200
                            //       ? ResponsiveRowColumnType.COLUMN
                            //       : ResponsiveRowColumnType.ROW,
                            //   rowCrossAxisAlignment: CrossAxisAlignment.start,
                            //   rowMainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   columnMainAxisAlignment: MainAxisAlignment.start,
                            //   columnVerticalDirection: VerticalDirection.down,
                            //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   // crossAxisAlignment: CrossAxisAlignment.start,
                            //   rowSpacing: 30,
                            //   children: [
                            //     ResponsiveRowColumnItem(
                            //       columnFlex: 1,
                            //       columnFit: FlexFit.loose,
                            //       columnOrder: 1,
                            //       child: ConstrainedBox(
                            //         constraints: const BoxConstraints(
                            //           minWidth: 786,
                            //           maxWidth: 786,
                            //         ),
                            //         child: row1(),
                            //       ),
                            //     ),
                            //     // const ResponsiveRowColumnItem(
                            //     //   child: SizedBox(
                            //     //     width: 30,
                            //     //   ),
                            //     // ),
                            //     ResponsiveRowColumnItem(
                            //       columnFlex: 1,
                            //       columnFit: FlexFit.loose,
                            //       columnOrder: 2,
                            //       child: Expanded(
                            //         flex: 1,
                            //         child: row2(),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minWidth: 786,
                                    maxWidth: 786,
                                  ),
                                  child: row1(),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: row2(),
                                ),
                              ],
                            ),
                            // ),
                          ],
                        ),
                        opacityOn
                            ? Center(
                                child: ConstrainedBox(
                                  constraints: pageConstraints.copyWith(
                                    minHeight:
                                        MediaQuery.of(context).size.width,
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
                            top: 310,
                            child: CustomDatePicker(
                              controller: datePickerControl,
                              isDark: true,
                              changeDate: onDateChanged,
                              currentDate: selectedDate,
                              setPickerStatus: setDatePickerVisible,
                              canPickPastDay: false,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: timePickerContainerVisible,
                          child: Positioned(
                            left: 465,
                            top: 310,
                            child: TimePickerContainer(
                              // controller: datePickerControl,
                              endTime: endTime,
                              startTime: startTime,
                              initialEndTime: endTime,
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
                            top: 440,
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
                            top: 440,
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
                            top: 390,
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
                            top: 390,
                            child: AmenitiesContainer(
                              tvOnChange: (value) {
                                if (checkBoxTv) {
                                  checkBoxTv = false;
                                  facilitySelected.removeWhere(
                                      (element) => element == 'TV');
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
                                  facilitySelected.removeWhere(
                                      (element) => element == 'Camera');
                                } else {
                                  checkBoxCamera = true;
                                  facilitySelected.add('Camera');
                                }
                                if (facilitySelected.isNotEmpty) {
                                  if (facilitySelected.length > 1) {
                                    _facilityController.text = "TV & Camera";
                                  } else if (facilitySelected.length == 1) {
                                    _facilityController.text =
                                        facilitySelected[0];
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
                          visible: meetingTypeContainerVisible,
                          child: Positioned(
                            left: 30,
                            top: 420,
                            child: RoomTypeContainerHomePage(
                              changeRoomType: changeRoomType,
                              setContainerStatus: setMeetingTypeContainerStatus,
                              roomTypeList: roomTypeList,
                              roomTypeName: roomTypeName,
                              roomTypeValue: roomTypeValue,
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
          setMeetingTypeStatus: setMeetingTypeContainerStatus,
          meetingTypeStatus: meetingTypeContainerVisible,
          roomTypeName: roomTypeName,
          roomTypeSelected: roomTypeValue,
          roomTypeUrl: roomTypeImage,
          searchRoom: search,
          initLoading: initLoading,
        ),
        const SizedBox(
          height: 30,
        ),
        StatisticContainer(),
        const SizedBox(
          height: 30,
        ),
        UpcomingEventContainer(),
        const SizedBox(
          height: 30,
        ),
        Visibility(
          visible: isAccSyncToGoogle ? false : true,
          child: InkWell(
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
        ),
      ],
    );
  }

  Widget row2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: isUserAdmin ? true : false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ApprovalMessage(setIsAdmin: setIsUserAdmin),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        ScheduleContainer(),
        const SizedBox(
          height: 30,
        ),
        AvailableRoomContainer(),
      ],
    );
  }
}
