import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/widgets/amenities_container.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/feedback_dialog.dart';
import 'package:meeting_room_booking_system/widgets/end_time_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/apporval_message.dart';
import 'package:meeting_room_booking_system/widgets/home_page/available_room_offer_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/greeting_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/home_search_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/report_banner.dart';
import 'package:meeting_room_booking_system/widgets/home_page/room_type_home_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/schedule_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/statistic_container.dart';
import 'package:meeting_room_booking_system/widgets/home_page/upcoming_event_container.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/participant_container.dart';
import 'package:meeting_room_booking_system/widgets/start_time_container.dart';
import 'package:meeting_room_booking_system/widgets/time_picker_container.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.index = 0}) : super(key: key);
  int index;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  ReqAPI apiReq = ReqAPI();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey datePickerKey = GlobalKey();
  GlobalKey timeFieldkey = GlobalKey();
  GlobalKey selectTimePickerKey = GlobalKey();
  GlobalKey participantKey = GlobalKey();
  GlobalKey facilityKey = GlobalKey();
  GlobalKey roomTypeKey = GlobalKey();
  // GlobalKey searchContainerKey = GlobalKey();
  LayerLink datePickerLayerLink = LayerLink();
  LayerLink timeFieldLayerLink = LayerLink();
  LayerLink selectTimePickerLayerLink = LayerLink();
  LayerLink participantLayerLink = LayerLink();
  LayerLink facilityLayerLink = LayerLink();
  LayerLink roomTypeLayerLink = LayerLink();

  OverlayEntry? datePickerOverlayEntry;
  OverlayEntry? selectTimeOverlayEntry;
  OverlayEntry? startTimeOverlayEntry;
  OverlayEntry? endTimeOverlayEntry;
  OverlayEntry? participantOverlayEntry;
  OverlayEntry? facilityOverlayEntry;
  OverlayEntry? roomTypeOverlayEntry;
  OverlayState? overlayState = OverlayState();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _participantController = TextEditingController();
  final DateRangePickerController datePickerControl =
      DateRangePickerController();

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
  double participantValue = 2;

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
  bool feedback = false;
  bool feedbackBanner = false;

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
      print(value);
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
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
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
        // if (value['Status'].toString() == "401") {
        //   context.go('/login');
        // }
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
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
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
        if (value['Status'].toString() == "401") {
          context.go('/login');
        }
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
      String status = value['Status'].toString();
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
        if (status == "401") {
          showDialog(
            context: context,
            builder: (context) => TokenExpiredDialog(
              title: value['Title'],
              contentText: value['Message'],
              isSuccess: false,
            ),
          );
        }
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

  feedbackCheck() {
    // var box = await Hive.openBox('userLogin');

    // feedback = box.get('feedback') ?? false;
    // feedbackBanner = box.get('feedbackBanner') ?? false;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   feedback = Provider.of<MainModel>(context, listen: false).feedback;
    //   feedbackBanner =
    //       Provider.of<MainModel>(context, listen: false).feedbackBanner;
    // });
    apiReq.feedbackStatus().then((value) {
      feedback = value['Data']['Feedback'];
      feedbackBanner = value['Data']['FeedbackBanner'];
      setState(() {});

      if (feedback) {
        showDialog(
          context: context,
          builder: (context) => const FeedbackDialog(),
        ).then((value) {});
      }
    });
  }

  OverlayEntry datePickerOverlay() {
    RenderBox? renderBox =
        datePickerKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 277,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                link: datePickerLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
                  child: CustomDatePicker(
                    controller: datePickerControl,
                    isDark: true,
                    changeDate: onDateChanged,
                    currentDate: selectedDate,
                    maxDate: DateTime.now().add(const Duration(days: 30)),
                    setPickerStatus: setDatePickerVisible,
                    canPickPastDay: false,
                  ),
                ),
              ),
            ));
  }

  OverlayEntry timePickerOverlay() {
    RenderBox? renderBox =
        timeFieldkey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 277,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                link: timeFieldLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
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
            ));
  }

  OverlayEntry startTimeOverlay() {
    RenderBox? renderBox =
        timeFieldkey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 85,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 115),
                link: timeFieldLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
                  child: StartTimeContainer(
                    items: startTimeList,
                    setStartTime: setStartTime,
                    setStartTimeStatus: setStartTimeStatus,
                    setInitialEndTime: setInitialEndTime,
                  ),
                ),
              ),
            ));
  }

  OverlayEntry endTimeOverlay() {
    RenderBox? renderBox =
        timeFieldkey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 85,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(175, size.height + 115),
                link: timeFieldLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
                  child: EndTimeContainer(
                    items: endTimeList,
                    setEndTime: setEndTime,
                    setEndTimeStatus: setEndTimeStatus,
                    startTime: startTime,
                    setTime: setTime,
                  ),
                ),
              ),
            ));
  }

  OverlayEntry participantOverlay() {
    RenderBox? renderBox =
        participantKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 300,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                link: participantLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
                  child: ParticipantContainer(
                    setParticipantStatus: setParticipantStatus,
                    onChangeParticipant: onParticipanSelected,
                    participantValue: participantValue,
                  ),
                ),
              ),
            ));
  }

  OverlayEntry facilityOverlay() {
    RenderBox? renderBox =
        facilityKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 150,
              height: 100,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                link: facilityLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
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
                      facilityOverlayEntry!.markNeedsBuild();
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
                      facilityOverlayEntry!.markNeedsBuild();
                      // print(facilitySelected);

                      setState(() {});
                    },
                    cameraValue: checkBoxCamera,
                    tvValue: checkBoxTv,
                  ),
                ),
              ),
            ));
  }

  OverlayEntry roomTypeOverlay() {
    RenderBox? renderBox =
        roomTypeKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              width: 550,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                link: roomTypeLayerLink,
                child: Material(
                  color: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4.0,
                  child: RoomTypeContainerHomePage(
                    changeRoomType: changeRoomType,
                    setContainerStatus: setMeetingTypeContainerStatus,
                    roomTypeList: roomTypeList,
                    roomTypeName: roomTypeName,
                    roomTypeValue: roomTypeValue,
                  ),
                ),
              ),
            ));
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
    feedbackCheck();
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
    setOpacityOn(value);

    // Overlay.of(context)!.();
    if (datePickerOverlayEntry != null) {
      if (datePickerOverlayEntry!.mounted) {
        datePickerOverlayEntry!.remove();
      }
    }
    if (selectTimeOverlayEntry != null) {
      if (selectTimeOverlayEntry!.mounted) {
        selectTimeOverlayEntry!.remove();
      }
    }
    if (participantOverlayEntry != null) {
      if (participantOverlayEntry!.mounted) {
        participantOverlayEntry!.remove();
      }
    }
    if (facilityOverlayEntry != null) {
      if (facilityOverlayEntry!.mounted) {
        facilityOverlayEntry!.remove();
      }
    }
    if (roomTypeOverlayEntry != null) {
      if (roomTypeOverlayEntry!.mounted) {
        roomTypeOverlayEntry!.remove();
      }
    }
    if (startTimeOverlayEntry != null) {
      if (startTimeOverlayEntry!.mounted) {
        startTimeOverlayEntry!.remove();
      }
    }
    if (endTimeOverlayEntry != null) {
      if (endTimeOverlayEntry!.mounted) {
        endTimeOverlayEntry!.remove();
      }
    }

    setState(() {});
  }

  setOpacityOn(bool value) {
    opacityOn = value;
    if (!value) {
      // datePickerOverlayEntry!.remove();
    }
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
      datePickerOverlayEntry = datePickerOverlay();
      Overlay.of(context)!.insert(datePickerOverlayEntry!);
    } else {
      datePickerOverlayEntry!.remove();

      setOpacityOn(false);
    }
    // datePickerVisible = value;
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
    // if (datePickerOverlayEntry!.mounted) {
    //   datePickerOverlayEntry!.remove();
    // }
    setOpacityOn(false);

    setState(() {});
  }

  setTimePickerStatus(bool value) {
    // timePickerContainerVisible = value;
    opacityOn = value;
    if (value) {
      selectTimeOverlayEntry = timePickerOverlay();
      Overlay.of(context)!.insert(selectTimeOverlayEntry!);
    } else {
      selectTimeOverlayEntry!.remove();
      setOpacityOn(false);
    }
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
    // startTimeContainerVisible = value;
    if (value) {
      startTimeOverlayEntry = startTimeOverlay();
      Overlay.of(context)!.insert(startTimeOverlayEntry!);
    } else {
      if (startTimeOverlayEntry != null) {
        if (startTimeOverlayEntry!.mounted) {
          startTimeOverlayEntry!.remove();
        }
      }
    }
    setState(() {});
  }

  setEndTimeStatus(bool value) {
    // endTimeContainerVisible = value;
    if (value) {
      endTimeOverlayEntry = endTimeOverlay();
      Overlay.of(context)!.insert(endTimeOverlayEntry!);
    } else {
      if (endTimeOverlayEntry != null) {
        if (endTimeOverlayEntry!.mounted) {
          endTimeOverlayEntry!.remove();
        }
      }
    }
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
    if (hourEnd >= 19) {
      hourEnd = 19;
      if (minuteEnd > 0) {
        minuteEnd = 0;
      }
    }

    endTime =
        "${hourEnd.toString().padLeft(2, '0')}:${minuteEnd.toString().padLeft(2, '0')}";
    _timeController.text = "$startTime - $endTime";
    setState(() {});
  }

  setEndTime(String end) {
    endTime = end;
    // timePickerContainerVisible = false;
    // endTimeContainerVisible = false;
    opacityOn = false;
    if (selectTimeOverlayEntry != null) {
      if (selectTimeOverlayEntry!.mounted) {
        selectTimeOverlayEntry!.remove();
      }
    }
    setState(() {});
  }

  setInitialEndTime(String value) {
    initialEndTime = value;
    setState(() {});
  }

  setParticipantStatus(bool value) {
    // participantContainerVisible = value;
    opacityOn = value;
    if (value) {
      participantOverlayEntry = participantOverlay();
      Overlay.of(context)!.insert(participantOverlayEntry!);
    } else {
      participantOverlayEntry!.remove();
      setOpacityOn(false);
    }
    setState(() {});
  }

  onParticipanSelected(String value, double valueDouble) {
    participantSelected = value;
    participantValue = valueDouble;
    _participantController.text = participantSelected;
    participantOverlayEntry!.markNeedsBuild();
    // participantOverlayEntry!.remove();
    // setOpacityOn(false);
    setState(() {});
  }

  setAmenitiesStatus(bool value) {
    // amenitiesContainerVisible = value;
    opacityOn = value;
    if (value) {
      facilityOverlayEntry = facilityOverlay();
      Overlay.of(context)!.insert(facilityOverlayEntry!);
    } else {
      facilityOverlayEntry!.remove();
      setOpacityOn(value);
    }
    setState(() {});
  }

  setMeetingTypeContainerStatus(bool value) {
    // meetingTypeContainerVisible = value;
    opacityOn = value;
    if (value) {
      roomTypeOverlayEntry = roomTypeOverlay();
      Overlay.of(context)!.insert(roomTypeOverlayEntry!);
    } else {
      roomTypeOverlayEntry!.remove();
    }
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
                                  child: GestureDetector(
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
                        // Visibility(
                        //   visible: datePickerVisible,
                        //   child: Positioned(
                        //     left: 265,
                        //     // top: isAccSyncToGoogle ? 310 : 440,
                        //     top: 310,
                        //     child: CustomDatePicker(
                        //       controller: datePickerControl,
                        //       isDark: true,
                        //       changeDate: onDateChanged,
                        //       currentDate: selectedDate,
                        //       maxDate:
                        //           DateTime.now().add(const Duration(days: 30)),
                        //       setPickerStatus: setDatePickerVisible,
                        //       canPickPastDay: false,
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: timePickerContainerVisible,
                        //   child: Positioned(
                        //     left: 465,
                        //     // top: isAccSyncToGoogle ? 310 : 440,
                        //     top: 310,
                        //     child: TimePickerContainer(
                        //       // controller: datePickerControl,
                        //       endTime: endTime,
                        //       startTime: startTime,
                        //       initialEndTime: endTime,
                        //       endTimeStatus: endTimeContainerVisible,
                        //       startTimeStatus: startTimeContainerVisible,
                        //       isDark: true,
                        //       selectedDate: selectedDate,
                        //       setEndTimeStatus: setEndTimeStatus,
                        //       setStartTimeStatus: setStartTimeStatus,
                        //       setListEndTime: setListEndTime,
                        //       setListStartTime: setListStartTime,
                        //       setTime: setTime,
                        //       setTimePickerStatus: setTimePickerStatus,
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: startTimeContainerVisible,
                        //   child: Positioned(
                        //     // top: isAccSyncToGoogle ? 440 : 560,
                        //     top: 440,
                        //     left: 475,
                        //     child: StartTimeContainer(
                        //       items: startTimeList,
                        //       setStartTime: setStartTime,
                        //       setStartTimeStatus: setStartTimeStatus,
                        //       setInitialEndTime: setInitialEndTime,
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: endTimeContainerVisible,
                        //   child: Positioned(
                        //     // top: isAccSyncToGoogle ? 440 : 560,
                        //     top: 440,
                        //     left: 595,
                        //     child: EndTimeContainer(
                        //       items: endTimeList,
                        //       setEndTime: setEndTime,
                        //       setEndTimeStatus: setEndTimeStatus,
                        //       startTime: startTime,
                        //       setTime: setTime,
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: participantContainerVisible,
                        //   child: Positioned(
                        //     left: 265,
                        //     // top: isAccSyncToGoogle ? 390 : 520,
                        //     top: 390,
                        //     child: ParticipantContainer(
                        //       setParticipantStatus: setParticipantStatus,
                        //       onChangeParticipant: onParticipanSelected,
                        //       participantValue: participantValue,
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: amenitiesContainerVisible,
                        //   child: Positioned(
                        //     left: 465,
                        //     // top: isAccSyncToGoogle ? 390 : 520,
                        //     top: 390,
                        //     child: AmenitiesContainer(
                        //       tvOnChange: (value) {
                        //         if (checkBoxTv) {
                        //           checkBoxTv = false;
                        //           facilitySelected.removeWhere(
                        //               (element) => element == 'TV');
                        //         } else {
                        //           checkBoxTv = true;
                        //           facilitySelected.add('TV');
                        //         }
                        //         if (facilitySelected.isNotEmpty) {
                        //           if (facilitySelected.length > 1) {
                        //             _facilityController.text = "TV & Camera";
                        //           } else if (facilitySelected.length == 1) {
                        //             _facilityController.text =
                        //                 facilitySelected[0].toString();
                        //           }
                        //         } else {
                        //           _facilityController.text = "None";
                        //         }
                        //         // print(facilitySelected);
                        //         setState(() {});
                        //       },
                        //       cameraOnChange: (value) {
                        //         if (checkBoxCamera) {
                        //           checkBoxCamera = false;
                        //           facilitySelected.removeWhere(
                        //               (element) => element == 'Camera');
                        //         } else {
                        //           checkBoxCamera = true;
                        //           facilitySelected.add('Camera');
                        //         }
                        //         if (facilitySelected.isNotEmpty) {
                        //           if (facilitySelected.length > 1) {
                        //             _facilityController.text = "TV & Camera";
                        //           } else if (facilitySelected.length == 1) {
                        //             _facilityController.text =
                        //                 facilitySelected[0];
                        //           }
                        //         } else {
                        //           _facilityController.text = "None";
                        //         }
                        //         // print(facilitySelected);

                        //         setState(() {});
                        //       },
                        //       cameraValue: checkBoxCamera,
                        //       tvValue: checkBoxTv,
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: meetingTypeContainerVisible,
                        //   child: Positioned(
                        //     left: 30,
                        //     // top: isAccSyncToGoogle ? 420 : 550,
                        //     top: 420,
                        //     child: RoomTypeContainerHomePage(
                        //       changeRoomType: changeRoomType,
                        //       setContainerStatus: setMeetingTypeContainerStatus,
                        //       roomTypeList: roomTypeList,
                        //       roomTypeName: roomTypeName,
                        //       roomTypeValue: roomTypeValue,
                        //     ),
                        //   ),
                        // ),
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
        Visibility(
          // visible: isAccSyncToGoogle ? false : true,
          // child: InkWell(
          //   onTap: () {
          //     context.go('/gws');
          //   },
          //   child: ConstrainedBox(
          //     constraints: const BoxConstraints(
          //       maxWidth: 780,
          //       minWidth: 780,
          //     ),
          //     child: const WhiteBannerLandscape(
          //       title: 'Link your Google account',
          //       subtitle: '& enjoy your benefits.',
          //       imagePath: 'assets/banner_pict_google.png',
          //     ),
          //   ),
          // ),
          visible: feedbackBanner,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  // context.go('/gws');
                  showDialog(
                    context: context,
                    builder: (context) => const FeedbackDialog(),
                  );
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 780,
                    minWidth: 780,
                  ),
                  child: const WhiteBannerLandscape(
                    title: 'How is your experience? ',
                    subtitle: 'We love to hear from you!',
                    imagePath: 'assets/feedback_bg.png',
                    borderColor: platinum,
                    backgroundColor: white,
                    fit: BoxFit.fitWidth,
                    isUseGradient: false,
                  ),
                ),
              ),
            ],
          ),
        ),
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
          datePickerKey: datePickerKey,
          participantKey: participantKey,
          timeFieldKey: timeFieldkey,
          facilityKey: facilityKey,
          roomTypeKey: roomTypeKey,
          datePickerLayerLink: datePickerLayerLink,
          participantLayerLink: participantLayerLink,
          timeFieldLayerLink: timeFieldLayerLink,
          facilityLayerLink: facilityLayerLink,
          roomTypeLayerLink: roomTypeLayerLink,
        ),
        const SizedBox(
          height: 30,
        ),
        StatisticContainer(),
        const SizedBox(
          height: 30,
        ),
        UpcomingEventContainer(),
        Visibility(
          visible: isAccSyncToGoogle ? false : true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
        ReportBanner(),
        const SizedBox(
          height: 30,
        ),
        AvailableRoomContainer(),
      ],
    );
  }
}
