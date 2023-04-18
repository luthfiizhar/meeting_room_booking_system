import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/white_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/home_page/available_room_offer_container.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/rooms_page/detail_appointment_container.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  ReqAPI apiReq = ReqAPI();
  CalendarView? calendarView = CalendarView.timelineDay;
  DateTime? selectedDate = DateTime.now();
  CalendarController? calendarControl = CalendarController();
  DateRangePickerController datePickerControl = DateRangePickerController();
  String? selectedRoom = 'AR-1';
  String? selectedArea = 'AR-1';
  List<Area> areaList = [];
  List dataRoom = [];
  List eventRoom = [];

  List colors = [
    eerieBlack,
    davysGray,
    sonicSilver,
    spanishGray,
    grayx11,
    lightGray,
    platinum
  ];

  BookingDetail detailEvent = BookingDetail();

  RoomEvent? selectedEvent;

  bool isShowDetail = false;
  bool loadingGetCalendar = true;

  FocusNode areaNode = FocusNode();

  // double totalRoom = 6;

  // String urlApi = apiUrlGlobal;

  Booking bookingDetail = Booking();
  List<RoomEvent> roomEvents = <RoomEvent>[];
  List<CalendarResource> resourceCol = <CalendarResource>[];
  // late MainModel mainModel = Provider.of<MainModel>(context, listen: true);
  MainModel mainModel = MainModel();

  RoomEventDataSource? _events;

  Future forRefreshCalendar() async {
    var box = await Hive.openBox('calendarInfo');

    box.put('selectedArea', selectedArea);
    box.put('selectedDate', selectedDate);
    box.put('dataRoom', dataRoom);
    box.put('roomEvents', roomEvents);
  }

  onChangedArea(String selectedValue) {
    setState(() {
      loadingGetCalendar = true;
    });
    _events!.resources!.clear();
    Provider.of<MainModel>(context, listen: false).events.resources!.clear();
    // _events!.appointments!.clear();
    int indexColor = 0;
    // List areaselect;
    dataRoom = areaList
        .where((element) => element.areaId == selectedValue)
        .first
        .toJson()['Room'];
    if (dataRoom.isEmpty) {
      _events!.appointments!.clear();
    }
    for (var e in dataRoom) {
      if (indexColor % 3 == 0) {
        indexColor = 0;
      }
      _events!.resources!.add(
        CalendarResource(
          id: e['RoomID'],
          displayName: e['RoomString'],
          color: colors[indexColor],
        ),
      );
      Provider.of<MainModel>(context, listen: false).events.resources!.add(
            CalendarResource(
              id: e['RoomID'],
              displayName: e['RoomString'],
              color: colors[indexColor],
            ),
          );
      indexColor++;
    }
    setState(() {
      updateCalendar(selectedDate.toString());
      // apiReq
      //     .getBookingListRoom(
      //         selectedArea!, selectedDate.toString(), _events!.appointments!)
      //     .then((value) {
      //   if (value['Status'].toString() == "200") {
      //     assignDataToCalendar(value['Data']);
      //   } else {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialogBlack(
      //         title: value['Title'],
      //         contentText: value['Message'],
      //         isSuccess: false,
      //       ),
      //     );
      //   }
      // }).onError((error, stackTrace) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialogBlack(
      //       title: 'Failed connect to API',
      //       contentText: error.toString(),
      //       isSuccess: false,
      //     ),
      //   );
      // });
    });
    //     .map((e) {
    //   _events!.resources!.add(
    //     CalendarResource(
    //       id: e['RoomID'],
    //       displayName: e['RoomName'],
    //       color: colors[indexColor],
    //     ),
    //   );
    //   indexColor++;
    // });
    // print(_events!.resources!);
  }

  getMrbsBookingDetail() {
    apiReq.getBookingDetail(selectedEvent!.bookingID!).then((value) {
      // print("MRBS ---> $value");
      String status = value['Status'].toString();
      if (value['Status'] == "200") {
        setState(() {
          // print('BookingDetail $value');
          detailEvent.bookingId = value['Data']['BookingID'];
          detailEvent.empNip = value['Data']['EmpNIP'];
          detailEvent.phoneNumber = value['Data']['PhoneNumber'];
          detailEvent.location = value['Data']['RoomName'];
          detailEvent.summary = value['Data']['Summary'];
          detailEvent.description = value['Data']['Description'] ?? "";
          detailEvent.eventDate = value['Data']['BookingDate'];
          detailEvent.eventTime = value['Data']['BookingStartTime'] +
              " - " +
              value['Data']['BookingEndTime'];
          detailEvent.startTime = value['Data']['BookingStartTime'];
          detailEvent.duration = value['Data']['Duration'];
          detailEvent.floor = value['Data']['AreaName'];
          detailEvent.email = value['Data']['Email'];
          detailEvent.avaya = value['Data']['AvayaNumber'];
          detailEvent.host = value['Data']['EmpName'];
          detailEvent.attendatsNumber =
              value['Data']['AttendantsNumber'].toString();
          detailEvent.status = value['Data']['Status'];
          detailEvent.stepBooking = value['Data']['BookingStep'].toString();
          detailEvent.type = "MRBS";
          detailEvent.bookingType = value['Data']['BookingType'] ?? "";
          detailEvent.originalBookingDate =
              value['Data']['BookingDateOriginal'];
          detailEvent.phoneOptions =
              value['Data']['DisplayPhoneNumber'] ?? false;
          if (!isShowDetail) {
            isShowDetail = true;
          }
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
        ).then((value) {
          if (status == "401") {
            context.go('/login');
          }
        });
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed getMRBSBookingDetail',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  getGoogleBookingDetail() {
    apiReq
        .getGoogleRoomDetail(selectedEvent!.googleID!, selectedEvent!.roomId!)
        .then((value) {
      // print("GOOGLE ---> $value");
      if (value['Status'] == "200") {
        setState(() {
          // print(value);
          detailEvent.bookingId = selectedEvent!.googleID!;
          detailEvent.empNip = "";
          detailEvent.phoneNumber = "-";
          detailEvent.location = value['Data']['RoomName'];
          detailEvent.phoneNumber = value['Data']['PhoneNumber'];
          detailEvent.summary = value['Data']['Summary'] ?? "";
          detailEvent.description = value['Data']['Description'] ?? "";
          detailEvent.eventDate = value['Data']['BookingDate'];
          detailEvent.eventTime = value['Data']['BookingStart'] +
              " - " +
              value['Data']['BookingEnd'];
          detailEvent.duration = value['Data']['Duration'];
          detailEvent.floor = value['Data']['AreaName'];
          detailEvent.email = value['Data']['Email'];
          detailEvent.avaya = value['Data']['AvayaNumber'] ?? "-";
          detailEvent.host = value['Data']['EmpName'];
          detailEvent.attendatsNumber =
              value['Data']['AttendantsNumber'].toString();
          detailEvent.status = value['Data']['Status'];
          detailEvent.stepBooking = value['Data']['BookingStep'].toString();
          detailEvent.type = "GOOGLE";
          detailEvent.bookingType = value['Data']['BookingType'] ?? "";
          detailEvent.startTime = value['Data']['BookingStart'];
          detailEvent.originalBookingDate =
              value['Data']['BookingDateOriginal'] ?? "";
          detailEvent.phoneOptions =
              value['Data']['DisplayPhoneNumber'] ?? false;
          if (!isShowDetail) {
            isShowDetail = true;
          }
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
          title: 'Error getGoogleBookingDetail',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  setDatePickerStatus(bool value) {
    // setState(() {
    //   isShowDetail = false;
    // });
  }

  closeDetail() {
    setState(() {
      isShowDetail = false;
    });
  }

  resetState() {
    setState(() {});
  }

  setDate(String value, DateTime date) {
    setState(() {
      selectedDate = date;
      // calendarControl!.selectedDate = selectedDate;
      datePickerControl.displayDate = selectedDate;
      calendarControl!.displayDate = selectedDate;
    });
  }

  List<DropdownMenuItem<String>> addDividerItem(List<Area> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item.areaId,
            child: Text(
              item.areaName!,
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                color: culturedWhite,
              ),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights(List items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(15);
      }
    }
    return _itemsHeights;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _events.addListener((p0, p1) {});
    _events = RoomEventDataSource(<RoomEvent>[], <CalendarResource>[]);
    // print('ini init state');
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   mainModel = Provider.of<MainModel>(context, listen: false);
    // });
    apiReq.getAreaListWithRooms().then((value) {
      if (value['Status'].toString() == "200") {
        List area = value['Data'];
        for (var i = 0; i < area.length; i++) {
          areaList.add(
            Area(
              areaId: area[i]["AreaID"],
              areaName: area[i]["AreaName"],
              rooms: area[i]['Room'],
            ),
          );
        }
        // print(areaList);
        selectedArea = areaList.first.areaId;
        // print(selectedArea);
        // print(areaList
        //     .where((element) => element.areaId == selectedArea)
        //     .first
        //     .toJson());
        // print(areaList.toString());
        // for (var i = 0; i < areaList.length; i++) {}
        // print(areaList);
        onChangedArea(selectedArea!);
        // addResourceRoom().then((value) {
        //   _events!.appointments!.clear();
        // });
        updateCalendar(selectedDate.toString());
        // apiReq
        //     .getBookingListRoom(
        //         selectedArea!, selectedDate.toString(), _events!.appointments!)
        //     .then((value) {
        //   assignDataToCalendar(value['Data']);
        // });
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
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Error getAreaListWithRooms',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });

    // addResourceRoom().then((_) {
    //   _events!.appointments!.clear();
    // getBookingListRoom('AR-1', DateTime.now().toString()).then((value) {
    //   print(value);
    //   print('getbooking');
    //   dataRoom = value['Data'];
    //   int length = dataRoom.length;
    //   // print(dataRoom);
    //   for (var i = 0; i < length; i++) {
    //     eventRoom = dataRoom[i]['Bookings'];
    //     for (var j = 0; j < eventRoom.length; j++) {
    //       _events!.appointments!.add(
    //         RoomEvent(
    //           resourceIds: [dataRoom[i]['RoomID']],
    //           from: DateTime.parse(eventRoom[j]['StartDateTime']),
    //           to: DateTime.parse(eventRoom[j]['EndDateTime']),
    //           background: davysGray,
    //           capacity: 5,
    //           contactID: "1111",
    //           isAllDay: false,
    //           eventName: eventRoom[j]['Description'],
    //           organizer: "",
    //           recurrenceRule: "NONE",
    //           endTimeZone: "",
    //           startTimeZone: "",
    //           // subject: ,
    //           // resourceIds: [dataRoom[i]['RoomID']],
    //           // startTime: DateTime.parse(eventRoom[j]['StartDateTime']),
    //           // endTime: DateTime.parse(eventRoom[j]['EndDateTime']),
    //         ),
    //       );
    //     }
    //   }

    //   setState(() {});
    // });
    // });
    _events!.notifyListeners(
        CalendarDataSourceAction.reset, _events!.appointments!);
    _events!
        .notifyListeners(CalendarDataSourceAction.reset, _events!.resources!);
    areaNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    areaNode.removeListener(() {});
    areaNode.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
  }

  // Future<dynamic> getBookingListRoom() async {

  // }

  assignDataToCalendar(dynamic data) {
    _events!.appointments!.clear();
    Provider.of<MainModel>(context, listen: false).events.appointments!.clear();
    dataRoom = data;
    int length = dataRoom.length;
    // print(dataRoom);
    for (var i = 0; i < length; i++) {
      eventRoom = dataRoom[i]['Bookings'];

      for (var j = 0; j < eventRoom.length; j++) {
        // _events!.appointments!.add(
        //   RoomEvent(
        //     // subject: ,
        //     resourceIds: [dataRoom[i]['RoomID']],
        //     from: DateTime.parse(eventRoom[j]['StartDateTime']),
        //     to: DateTime.parse(eventRoom[j]['EndDateTime']),
        //     background: eventRoom[j]['MeetingType'] == "EXTERNAL"
        //         ? yellowAccent
        //         : davysGray,
        //     capacity: 5,
        //     contactID: "1111",
        //     isAllDay: false,
        //     eventName: eventRoom[j]['Summary'] ?? "-",
        //     organizer: "",
        //     recurrenceRule: "NONE",
        //     endTimeZone: "",
        //     startTimeZone: "",
        //     bookingID: eventRoom[j]['BookingID'],
        //     type: eventRoom[j]['Type'],
        //     googleID: eventRoom[j]['GoogleCalendarEventID'],
        //     roomId: dataRoom[i]['RoomID'],
        //     meetingType: eventRoom[j]['MeetingType'],
        //   ),
        // );
        Provider.of<MainModel>(context, listen: false).events.appointments!.add(
              RoomEvent(
                // subject: ,
                resourceIds: [dataRoom[i]['RoomID']],
                from: DateTime.parse(eventRoom[j]['StartDateTime']),
                to: DateTime.parse(eventRoom[j]['EndDateTime']),
                background: eventRoom[j]['MeetingType'] == "EXTERNAL"
                    ? yellowAccent
                    : davysGray,
                capacity: 5,
                contactID: "1111",
                isAllDay: false,
                eventName: eventRoom[j]['Summary'] ?? "-",
                organizer: "",
                recurrenceRule: "NONE",
                endTimeZone: "",
                startTimeZone: "",
                bookingID: eventRoom[j]['BookingID'],
                type: eventRoom[j]['Type'],
                googleID: eventRoom[j]['GoogleCalendarEventID'],
                roomId: dataRoom[i]['RoomID'],
                meetingType: eventRoom[j]['MeetingType'],
              ),
            );
      }
    }
    // _events!.notifyListeners(
    //     CalendarDataSourceAction.reset, _events!.appointments!);
    Provider.of<MainModel>(context, listen: false).events.notifyListeners(
        CalendarDataSourceAction.reset,
        Provider.of<MainModel>(context, listen: false).events.appointments!);
    // setState(() {});
    setState(() {
      loadingGetCalendar = false;
    });
  }

  updateCalendar(String date) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      // setState(() {});
      setState(() {
        isShowDetail = false;
        loadingGetCalendar = true;
      });
    });

    apiReq.getBookingListRoom(selectedArea!, date).then((value) {
      // print(value);
      if (value['Status'].toString() == "200") {
        assignDataToCalendar(value['Data']);
        setState(() {});
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
      print(stackTrace);
      loadingGetCalendar = false;
      setState(() {});
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Error getBookingListRoom',
          contentText: error.toString(),
        ),
      );
    });
  }

  Future addResourceRoom() async {
    onChangedArea(selectedArea!);
    // _events!.resources!.add(CalendarResource(
    //   displayName: 'R. 101',
    //   id: 'RM-1',
    //   color: davysGray,
    // ));
    // _events!.resources!.add(CalendarResource(
    //   displayName: 'Amphiteather',
    //   id: 'RM-2',
    //   color: eerieBlack,
    // ));
    // _events!.resources!.add(CalendarResource(
    //   displayName: 'R. 103',
    //   id: 'RM-3',
    //   color: davysGray,
    // ));
    // _events!.resources!.add(CalendarResource(
    //   displayName: 'R. 104',
    //   id: 'RM-4',
    //   color: eerieBlack,
    // ));
    // _events!.resources!.add(CalendarResource(
    //   displayName: 'R. 105',
    //   id: 'RM-5',
    //   color: davysGray,
    // ));
    // _events!.resources!.add(CalendarResource(
    //   displayName: 'R. 106',
    //   id: 'RM-6',
    //   color: eerieBlack,
    // ));
  }

  setVisible(bool value) {
    // calendarControl!.notifyPropertyChangedListeners('initialDate');
  }

  // Future getBookingListRoom(String area, String date) async {
  //   // String link = 'fmklg.klgsys.com';
  //   String link = 'fmklg-backend.klgsys.com';
  //   _events!.appointments!.clear();
  //   var box = await Hive.openBox('userLogin');
  //   var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  //   var url =
  //       Uri.https(link, '/MRBS_Backend/public/api/room/booking/list/$area');
  //   Map<String, String> requestHeader = {
  //     'Authorization': 'Bearer $jwt',
  //     // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
  //     'Content-Type': 'application/json',
  //   };
  //   var bodySend = """
  // {
  //   "StartDate" : "$date",
  //   "EndDate" : "$date"
  // }
  // """;
  //   try {
  //     var response =
  //         await http.post(url, headers: requestHeader, body: bodySend);

  //     var data = json.decode(response.body);
  //     return data;
  //   } on Error catch (e) {
  //     return e;
  //   }
  // }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getBookingListRoom(selectedArea!, selectedDate.toString()).then((value) {
    //     assignDataToCalendar(value['Data']);
    //   });
    // });
    // resetState() {
    //   setState(() {});
    // }
    double screenW = MediaQuery.of(context).size.width;
    double sideBarHeight = 0;
    if (screenW > 1366) {
      sideBarHeight = MediaQuery.of(context).size.height;
      if (dataRoom.length > 6) {
        sideBarHeight = sideBarHeight + 20;
      } else {
        sideBarHeight - 145;
      }
    } else {
      sideBarHeight = MediaQuery.of(context).size.height;
      if (dataRoom.length > 4) {
        sideBarHeight = sideBarHeight - 15;
      } else {
        sideBarHeight = sideBarHeight + 40;
      }
    }
    return LayoutPageWeb(
      scrollController: scrollController,
      topButtonVisible: false,
      index: 2,
      setDatePickerStatus: setDatePickerStatus,
      resetState: resetState,
      child: ChangeNotifierProvider.value(
        value: mainModel,
        child: Consumer<MainModel>(builder: (context, model, child) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 145,
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 280,
                      child: Column(
                        children: [
                          CustomDatePicker(
                            controller: datePickerControl,
                            isDark: true,
                            setPickerStatus: setVisible,
                            changeDate: setDate,
                            currentDate: selectedDate,
                            maxDate:
                                DateTime.now().add(const Duration(days: 30)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AvailableRoomContainer(
                            height: 275,
                            smallFont: true,
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          headerCustom(),
                          const SizedBox(
                            height: 10,
                          ),
                          calendarRoomPage(model),
                        ],
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: isShowDetail
                          ? GestureDetector(
                              onTap: () {},
                              child: Container(
                                // height: MediaQuery.of(context).size.width > 1366
                                //     ? (100 * dataRoom.length) >= 600
                                //         ? (100 * dataRoom.length) + 100 + 63
                                //         : MediaQuery.of(context).size.height -
                                //             180
                                //     : (100 * dataRoom.length) >= 600
                                //         ? (100 * dataRoom.length) + 100 + 63
                                //         : null,
                                // height: (150 * dataRoom.length) >= 600
                                //     ? (150 * dataRoom.length) + 100 + 63
                                //     : MediaQuery.of(context).size.width > 1366
                                //         ? MediaQuery.of(context).size.height -
                                //             180
                                //         : 785,
                                // height: MediaQuery.of(context).size.width > 1366
                                //     ? MediaQuery.of(context).size.height - 145
                                //     : MediaQuery.of(context).size.height - 100,
                                height: sideBarHeight,
                                child: DetailAppointmentContainer(
                                  // event: selectedEvent,
                                  closeDetail: closeDetail,
                                  bookingDetail: detailEvent,
                                  updateCalendar: updateCalendar,
                                  selectedDate: selectedDate,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget headerCustom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RegularButton(
              text: 'Today',
              disabled: false,
              padding: ButtonSize().smallSize(),
              onTap: () {
                setState(() {
                  selectedDate = DateTime.now();
                });
                datePickerControl.selectedDate = selectedDate;
                calendarControl!.displayDate = selectedDate;
              },
            ),
            const SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedDate = calendarControl!.displayDate!
                      .subtract(const Duration(days: 1));
                });
                datePickerControl.selectedDate = selectedDate;
                datePickerControl.displayDate = selectedDate;
                calendarControl!.displayDate = selectedDate;
              },
              splashRadius: 20,
              icon: const Icon(
                Icons.chevron_left_sharp,
                size: 28,
              ),
            ),
            IconButton(
              onPressed: () {
                // getBookingListRoom(
                //     selectedArea!, selectedDate!.toString());
                setState(() {
                  selectedDate = calendarControl!.displayDate!
                      .add(const Duration(days: 1));
                });
                // print(calendarControl!.displayDate!);
                datePickerControl.selectedDate = selectedDate;
                calendarControl!.displayDate = selectedDate;
                datePickerControl.displayDate = selectedDate;
                // print(selectedDate!.isAfter(calendarControl!.displayDate!));
                if (selectedDate!.isAfter(calendarControl!.displayDate!)) {
                  setState(() {
                    selectedDate = calendarControl!.displayDate!;
                  });
                } else {}
              },
              splashRadius: 20,
              icon: const Icon(
                Icons.chevron_right_sharp,
                size: 28,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              DateFormat('d MMMM y').format(selectedDate!),
              style: const TextStyle(
                fontFamily: 'Helvetica',
                color: eerieBlack,
                fontSize: 20,
                fontWeight: FontWeight.w300,
                height: 1.3,
              ),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.end,
                direction: Axis.horizontal,
                // direction: isShowDetail ? Axis.vertical : Axis.horizontal,
                // spacing: isShowDetail ? 10 : 30,
                spacing: 30,
                runSpacing: 10,
                children: [
                  legends(davysGray, 'Internal'),
                  legends(yellowAccent, 'External'),
                ],
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            SizedBox(
              width: 180,
              child: WhiteDropdown(
                focusNode: areaNode,
                customHeights: _getCustomItemsHeights(areaList),
                items: addDividerItem(areaList),
                enabled: true,
                hintText: '',
                onChanged: (value) {
                  // print(value);
                  selectedArea = value;
                  onChangedArea(selectedArea!);
                  if (isShowDetail) {
                    setState(() {
                      isShowDetail = false;
                    });
                  }
                },
                value: selectedArea,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 100,
          ),
          child: Text(
            DateFormat('d EEEE').format(selectedDate!),
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: eerieBlack,
            ),
          ),
        )
      ],
    );
  }

  Widget calendarRoomPage(MainModel model) {
    double screenW = MediaQuery.of(context).size.width;
    double calendarTemp = MediaQuery.of(context).size.height - 100;
    double calendarHeight = calendarTemp;
    if (screenW > 1366) {
      if (dataRoom.length <= 6) {
        calendarHeight = dataRoom.length * 150;
      }
    } else {
      if (dataRoom.length <= 4) {
        calendarHeight = dataRoom.length * 150;
      }
    }
    // double calendarHeight = screenW > 1366
    //     ? dataRoom.length < 5
    //         ? (150 * dataRoom.length)
    //         : calendarTemp
    //     : dataRoom.length < 2
    //         ? (150 * dataRoom.length)
    //         : calendarTemp;
    // dataRoom.length > 2 ? 330 : (150 * dataRoom.length) + 30;
    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.hovered)) {
                return davysGray;
              }

              return davysGray.withOpacity(0.8);
            }),
          )),
          child: Container(
            // color: Colors.amber,
            height: dataRoom.isNotEmpty ? calendarHeight : 500,
            // height: dataRoom.isNotEmpty ? calendarHeight : 500,
            child: SfCalendar(
              key: const ValueKey(CalendarView.timelineDay),
              // loadMoreWidgetBuilder: (context, loadMoreAppointments) =>
              //     CircularProgressIndicator(),
              // onSelectionChanged: (calendarSelectionDetails) {
              //   print(calendarSelectionDetails);
              // },
              view: CalendarView.timelineDay,
              maxDate: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day, 24)
                  .add(const Duration(days: 30)),
              onViewChanged: (viewChangedDetails) {
                selectedDate = viewChangedDetails.visibleDates.first;
                if (dataRoom == []) {
                  _events!.appointments!.clear();
                  Provider.of<MainModel>(context, listen: false)
                      .events
                      .appointments!
                      .clear();
                } else {
                  // setState(() {
                  //   loadingGetCalendar = true;
                  // });

                  updateCalendar(viewChangedDetails.visibleDates[0].toString());
                }
              },
              headerHeight: 0,
              viewHeaderHeight: 0,
              viewHeaderStyle: const ViewHeaderStyle(
                dayTextStyle: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: eerieBlack,
                ),
                dateTextStyle: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: eerieBlack,
                ),
              ),
              initialDisplayDate:
                  selectedDate!.subtract(const Duration(minutes: 15)),
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.targetElement ==
                    CalendarElement.appointment) {
                  if ((jwtToken != null || jwtToken != "") && isTokenValid) {
                    setState(() {
                      RoomEvent list = calendarTapDetails.appointments![0];
                      selectedEvent = list;
                      if (isShowDetail) {
                        isShowDetail = false;
                      }
                      if (list.type == "MRBS") {
                        getMrbsBookingDetail();
                      }
                      if (list.type == "GOOGLE") {
                        getGoogleBookingDetail();
                      }
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialogBlack(
                        title: 'Access denied',
                        contentText: 'Login first!',
                        isSuccess: false,
                      ),
                    );
                  }
                }
                if (calendarTapDetails.targetElement ==
                    CalendarElement.calendarCell) {
                  if ((jwtToken != null || jwtToken != "") && isTokenValid) {
                    if (calendarTapDetails.date!.compareTo(DateTime.now()) >
                        0) {
                      // bookingDetail.startDate = calendarTapDetails.date;
                      // bookingDetail.roomId =
                      //     calendarTapDetails.resource!.id.toString();
                      // bookingDetail.endDate =
                      //     calendarTapDetails.date!.add(Duration(hours: 2));
                      // bookingDetail.attendantsNumber = '3';
                      // bookingDetail.recursive = '';
                      // bookingDetail.description = 'Test Book !!!!!!!!!!';
                      // bookingDetail.summary = 'Masih Tes';
                      // bookingDetail.meetingType = 'Internal';
                      // bookingDetail.recursive = 'NONE';
                      // bookingDetail.attendants = [];
                      // bookingDetail.amenities = [];
                      // bookingDetail.foodAmenities = [];
                      // print('data Room ' + dataRoom.toString());
                      // print('selected area ' + selectedArea!);
                      // print('event room ' + eventRoom.toString());
                      // print('Selected Date -> ${selectedDate.toString()}');
                      // forRefreshCalendar();
                      // Provider.of<MainModel>(context, listen: false)
                      //     .setSelectedDate(selectedDate!.toString());
                      // Provider.of<MainModel>(context, listen: false)
                      //     .setSelectedArea(selectedArea!);
                      // Provider.of<MainModel>(context, listen: false)
                      //     .setDataAndEventRoom(dataRoom);
                      // Provider.of<MainModel>(context, listen: false)
                      //     .setEventRoom(eventRoom);
                      setState(() {
                        model.setSelectedDate(selectedDate!.toString());
                        model.setSelectedArea(selectedArea!);
                        model.setDataAndEventRoom(dataRoom);
                        model.setEventRoom(eventRoom);
                      });

                      // mainModel.setSelectedDate(selectedDate!.toString());
                      // mainModel.setSelectedArea(selectedArea!);
                      // mainModel.setDataAndEventRoom(dataRoom);
                      // mainModel.setEventRoom(eventRoom);
                      // context.pushNamed(
                      //   'booking',
                      //   params: {
                      //     "roomId": calendarTapDetails.resource!.id.toString(),
                      //     'date': calendarTapDetails.date.toString().substring(0, 10),
                      //     'startTime':
                      //         calendarTapDetails.date.toString().substring(11, 16),
                      //     'endTime': calendarTapDetails.date!
                      //         .add(const Duration(hours: 1))
                      //         .toString()
                      //         .substring(11, 16),
                      //     'participant': '1',
                      //     'facilities': '[]',
                      //     'roomType': 'meeting_room',
                      //   },
                      // );
                      //BOOK WITH DIALOG
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => BookingRoomPageDialog(
                      //     roomId: calendarTapDetails.resource!.id.toString(),
                      //     date: calendarTapDetails.date.toString().substring(0, 10),
                      //     startTime: calendarTapDetails.date.toString().substring(11, 16),
                      //     endTime: calendarTapDetails.date!
                      //         .add(const Duration(hours: 1))
                      //         .toString()
                      //         .substring(11, 16),
                      //     participant: '1',
                      //     facilities: '[]',
                      //     roomType: 'MeetingRoom',
                      //   ),
                      // ).then((value) {
                      //   getBookingListRoom(selectedArea!, selectedDate.toString())
                      //       .then((value) {
                      //     assignDataToCalendar(value['Data']);
                      //   });
                      // });
                      //END BOOK WITH DIALOG
                      // _events!.appointments!.clear();
                      context.goNamed(
                        'booking_rooms',
                        params: {
                          "roomId": calendarTapDetails.resource!.id.toString(),
                          'date': calendarTapDetails.date
                              .toString()
                              .substring(0, 10),
                          'startTime': calendarTapDetails.date
                              .toString()
                              .substring(11, 16),
                          'endTime': calendarTapDetails.date!
                              .add(const Duration(hours: 1))
                              .toString()
                              .substring(11, 16),
                          'participant': '0',
                          'roomType': 'MeetingRoom',
                          'isEdit': 'false',
                          'floor': selectedArea.toString(),
                        },
                        // queryParams: {
                        //   "roomId": calendarTapDetails.resource!.id.toString(),
                        //   'date': calendarTapDetails.date.toString().substring(0, 10),
                        //   'startTime':
                        //       calendarTapDetails.date.toString().substring(11, 16),
                        //   'endTime': calendarTapDetails.date!
                        //       .add(const Duration(hours: 1))
                        //       .toString()
                        //       .substring(11, 16),
                        //   'participant': '1',
                        //   'facilities': '[]',
                        //   'roomType': 'MeetingRoom',
                        //   'isEdit': 'false',
                        // },
                      );
                      // Navigator.of(context)
                      //     .push(
                      //   MaterialPageRoute(
                      //     builder: (context) => BookingRoomPage(
                      //       roomId: calendarTapDetails.resource!.id.toString(),
                      //       participant: '1',
                      //       facilities: '[]',
                      //       roomType: 'meeting_room',
                      //       date: calendarTapDetails.date.toString().substring(0, 10),
                      //       startTime:
                      //           calendarTapDetails.date.toString().substring(11, 16),
                      //       endTime: calendarTapDetails.date!
                      //           .add(const Duration(hours: 1))
                      //           .toString()
                      //           .substring(11, 16),
                      //     ),
                      //   ),
                      // )
                      //     .then((value) {
                      //   getBookingListRoom(selectedArea!, selectedDate.toString())
                      //       .then((value) {
                      //     assignDataToCalendar(value['Data']);
                      //   });
                      //   setState(() {});
                      // });

                      // showDialog(
                      //   context: context,
                      //   builder: (context) => BookingRoomDialog(
                      //     roomId: calendarTapDetails.resource!.id.toString(),
                      //     startDate: calendarTapDetails.date,
                      //     nip: 'HAHAHA',
                      //     bookingDetail: bookingDetail,
                      //   ),
                      // ).then((value) {
                      //   _events!.appointments!.clear();
                      //   getBookingListRoom('AR-1', DateTime.now().toString())
                      //       .then((value) {
                      //     assignDataToCalendar(value['Data']);
                      //     // dataRoom = value['Data'];
                      //     // int length = dataRoom.length;
                      //     // // print(dataRoom);
                      //     // for (var i = 0; i < length; i++) {
                      //     //   eventRoom = dataRoom[i]['Bookings'];

                      //     //   for (var j = 0; j < eventRoom.length; j++) {
                      //     //     _events!.appointments!.add(
                      //     //       RoomEvent(
                      //     //         // subject: ,
                      //     //         resourceIds: [dataRoom[i]['RoomID']],
                      //     //         from: DateTime.parse(eventRoom[j]['StartDateTime']),
                      //     //         to: DateTime.parse(eventRoom[j]['EndDateTime']),
                      //     //         background: davysGray,
                      //     //         capacity: 5,
                      //     //         contactID: "1111",
                      //     //         isAllDay: false,
                      //     //         eventName: eventRoom[j]['Description'],
                      //     //         organizer: "",
                      //     //         recurrenceRule: "NONE",
                      //     //         endTimeZone: "",
                      //     //         startTimeZone: "",
                      //     //       ),
                      //     //     );
                      //     //   }
                      //     // }
                      //     // _events!.notifyListeners(
                      //     //     CalendarDataSourceAction.reset, _events!.appointments!);
                      //     // setState(() {});
                      //   });
                      // });
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialogBlack(
                        title: 'Access denied',
                        contentText: 'Login first!',
                        isSuccess: false,
                      ),
                    );
                  }
                }
              },
              dataSource: Provider.of<MainModel>(context, listen: false)
                  .events, //_events, //_getRoomDataSource(selectedRoom!, resetState),
              showDatePickerButton: true,
              showNavigationArrow: true,
              appointmentBuilder: appointmentBuilder,
              controller: calendarControl,
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeIntervalHeight: -1,
                timeIntervalWidth: 50,
                timeInterval: Duration(minutes: 15),
                timelineAppointmentHeight: 170,
                // dateFormat: 'd',
                // dayFormat: 'EEE',
                timeTextStyle: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: spanishGray,
                ),
                timeFormat: 'H:mm',
                startHour: 6,
                endHour: 19,
              ),
              todayHighlightColor: orangeAccent,
              resourceViewHeaderBuilder: resourceViewHeaderBuilder,
              resourceViewSettings: ResourceViewSettings(
                size: 120,
                displayNameTextStyle: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: culturedWhite,
                ),
                showAvatar: false,
                // visibleResourceCount: screenW > 1366
                //     ? dataRoom.length <= 6
                //         ? -1
                //         : -1
                //     : dataRoom.length <= 4
                //         ? -1
                //         : -1,
                visibleResourceCount: -1,
              ),
              // resourceViewHeaderBuilder: (context, details) {
              //   return Container(
              //     height: 10,
              //     width: 10,
              //     color: Colors.black,
              //   );
              // },
              // resourceViewHeaderBuilder: (context, details) {
              //   return Container(
              //     height: 20,
              //     child: Text(details.resource.displayName),
              //   );
              // },
            ),
          ),
        ),
        // Column(
        //   children: [
        //     const SizedBox(
        //       height: 30,
        //     ),
        //     SizedBox(
        //       height: dataRoom.isNotEmpty ? (150 * dataRoom.length) + 30 : 500,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: dataRoom.map((e) {
        //           return Row(
        //             children: [
        //               Expanded(
        //                 child: SizedBox(
        //                   height: 150,
        //                   child: Align(
        //                     alignment: Alignment.bottomCenter,
        //                     child: Container(
        //                       width: double.infinity,
        //                       height: 7,
        //                       color: Colors.transparent,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           );
        //         }).toList(),
        //       ),
        //     ),
        //   ],
        // ),
        !loadingGetCalendar
            ? const SizedBox()
            : Container(
                color: eerieBlack.withOpacity(0.6),
                width: double.infinity,
                // height:
                //     dataRoom.isNotEmpty ? (150 * dataRoom.length) + 40 : 500,
                height: calendarHeight,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: eerieBlack,
                  ),
                ),
              )
      ],
    );
  }

  Widget resourceViewHeaderBuilder(
      BuildContext context, ResourceViewHeaderDetails details) {
    final String roomName = details.resource.displayName.split(",")[0];
    final String capacity = details.resource.displayName.split(",")[1];

    return Container(
      color: details.resource.color,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              roomName,
              textAlign: TextAlign.center,
              style: helveticaText.copyWith(
                fontWeight: FontWeight.w400,
                color: culturedWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              capacity,
              textAlign: TextAlign.center,
              style: helveticaText.copyWith(
                fontWeight: FontWeight.w300,
                color: culturedWhite,
                fontSize: 16,
              ),
            )
          ],
        ),

        // child: Text(
        //   details.resource.displayName,
        //   style: helveticaText.copyWith(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w400,
        //     color: culturedWhite,
        //   ),
        //   textAlign: TextAlign.center,
        // ),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final RoomEvent appointment = calendarAppointmentDetails.appointments.first;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          color: appointment.background,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointment.eventName!,
              style: TextStyle(
                fontFamily: 'Helvetica',
                color: appointment.meetingType == "EXTERNAL"
                    ? eerieBlack
                    : culturedWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
            // Text(
            //   appointment.resourceIds![0].toString(),
            //   style: const TextStyle(
            //     fontFamily: 'Helvetica',
            //     color: culturedWhite,
            //     fontWeight: FontWeight.w300,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget legends(Color color, String label) {
    return Wrap(
      // alignment: WrapAlignment.end,
      // runAlignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          label,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: davysGray,
          ),
        )
      ],
    );
  }
}

class Area {
  Area({
    this.areaId,
    this.areaName,
    this.rooms,
  });

  String? areaId;
  String? areaName;
  List? rooms;

  Area.fromJSon(Map<String, dynamic> json)
      : areaId = json['AreaID'],
        areaName = json['AreaName'],
        rooms = json['Room'];

  Map<String, dynamic> toJson() =>
      {'AreaID': areaId ?? "", 'AreaName': areaName ?? "", 'Room': rooms};

  // @override
  // String toString() {
  //   // TODO: implement toString
  //   return 'Room : $rooms';
  // }
}

class BookingDetail {
  BookingDetail({
    this.bookingId = "",
    this.empNip = "",
    this.location = "",
    this.floor = "",
    this.eventTime = "",
    this.eventDate = "",
    this.duration = "",
    this.host = "",
    this.email = "",
    this.avaya = "",
    this.summary = "",
    this.description = "",
    this.attendatsNumber = "",
    this.status = "",
    this.stepBooking = "",
    this.phoneNumber = "",
    this.type = "",
    this.bookingType = "",
    this.startTime = "",
    this.originalBookingDate = "",
    this.phoneOptions = false,
  });
  String bookingId;
  String empNip;
  String location;
  String floor;
  String eventTime;
  String eventDate;
  String duration;
  String summary;
  String description;
  String attendatsNumber;

  String startTime;

  String host;
  String email;
  String avaya;
  String phoneNumber;

  String status;
  String stepBooking;
  String bookingType;

  String type;
  String originalBookingDate;

  bool phoneOptions;
}
