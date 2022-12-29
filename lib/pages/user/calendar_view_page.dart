import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/event_class.dart';
import 'package:meeting_room_booking_system/model/event_data_source.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/pages/user/rooms_page.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/rooms_page/detail_appointment_container.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({Key? key}) : super(key: key);

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  CalendarController _calendar = CalendarController();
  EventDataSource _events = EventDataSource(<Event>[]);
  Event? selectedEvent;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  DateTime today = DateTime.now();

  bool isShowDetail = false;
  bool isLoadingGetDetail = false;
  bool isLoadingGetCalendar2 = true;
  BookingDetail detailEvent = BookingDetail();

  String selectedView = "Weekly";

  double startTime = 6;
  double endTime = 20;

  String dayTextViewHeader1 = "S";
  String dayTextViewHeader2 = "M";
  String dayTextViewHeader3 = "T";
  String dayTextViewHeader4 = "W";
  String dayTextViewHeader5 = "T";
  String dayTextViewHeader6 = "F";
  String dayTextViewHeader7 = "S";

  String dateTextViewHeader1 = "1";
  String dateTextViewHeader2 = "2";
  String dateTextViewHeader3 = "3";
  String dateTextViewHeader4 = "4";
  String dateTextViewHeader5 = "5";
  String dateTextViewHeader6 = "6";
  String dateTextViewHeader7 = "7";

  String dayViewTextViewHeader = "";

  String displayMonthString = DateFormat('MMMM yyyy').format(DateTime.now());

  // ScrollController? _scrollController = ScrollController();
  EventDataSource _getCalendarDataSource() {
    List<Event> events = <Event>[];
    events.add(
      Event(
          eventName: 'Meeting 2',
          organizer: 'HEHE',
          contactID: ' ',
          capacity: 5,
          from: DateTime.now(),
          to: DateTime.now().add(Duration(hours: 2)),
          background: Colors.black45,
          isAllDay: false,
          endTimeZone: '',
          recurrenceRule: '',
          startTimeZone: ''),
    );

    events.add(
      Event(
          eventName: 'Meeting 3',
          organizer: 'HEHE',
          contactID: ' ',
          capacity: 5,
          from: DateTime.now(),
          to: DateTime.now().add(Duration(hours: 2)),
          background: Colors.red,
          isAllDay: false,
          endTimeZone: '',
          recurrenceRule: '',
          startTimeZone: ''),
    );
    events.add(
      Event(
          eventName: 'Meeting 3',
          organizer: 'HEHE',
          contactID: ' ',
          capacity: 5,
          from: DateTime.now(),
          to: DateTime.now().add(Duration(hours: 2)),
          background: Colors.black,
          isAllDay: false,
          endTimeZone: '',
          recurrenceRule: '',
          startTimeZone: ''),
    );

    // events.add(Event());
    return EventDataSource(events);
  }

  RoomEventDataSource _getRoomDataSource() {
    List<RoomEvent> roomEvents = <RoomEvent>[];
    List<CalendarResource> resourceCol = <CalendarResource>[];
    resourceCol.add(CalendarResource(
      displayName: 'John',
      id: '0001',
      color: Colors.red,
    ));
    resourceCol.add(CalendarResource(
      displayName: 'Matt',
      id: '0002',
      color: Colors.blue,
    ));
    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime(2022, 08, 31, 14, 0, 0),
    //     endTime: DateTime(2022, 08, 31, 14, 30, 0),
    //     subject: 'General Meeting',
    //     color: Colors.red,
    //     resourceIds: ['0001', '0002'],
    //   ),
    // );

    // roomEvents.add(
    //   Appointment(
    //     startTime: DateTime(2022, 09, 2, 11, 0, 0),
    //     endTime: DateTime(2022, 09, 2, 14, 30, 0),
    //     subject: 'General Meeting',
    //     color: Colors.blue,
    //     resourceIds: ['0001', '0002'],
    //   ),
    // );
    return RoomEventDataSource(roomEvents, resourceCol);
  }

  int activeCalendarMenu = 1;
  int selectedMenu = 1;
  void onHighlight(int menu) {
    switch (menu) {
      case 1:
        changeHighlight(1);
        break;
      case 2:
        changeHighlight(2);
        break;
    }
  }

  void changeHighlight(int newIndex) {
    setState(() {
      selectedMenu = newIndex;
      activeCalendarMenu = 1;
    });
  }

  assignDataToCalendar(dynamic data) {
    _events.appointments!.clear();
    print('data');
    print(data);
    for (var element in data) {
      print(element['BookingID']);
      _events.appointments!.add(
        Event(
          from: DateTime.parse(element['StartDateTime']),
          to: DateTime.parse(element['EndDateTime']),
          eventName: element['Summary'],
          bookingId: element['BookingID'],
          background: element['BookingID'] == '-' ? violetAccent : greenAcent,
        ),
      );
    }

    _events.notifyListeners(
        CalendarDataSourceAction.reset, _events.appointments!);
  }

  closeDetail() {
    setState(() {
      isShowDetail = false;
    });
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<MainModel>(context, listen: false).setShadowActive(false);
    // });

    // TODO: implement initState
    super.initState();

    startTime = 7;
    endTime = 19;
    // getUserCalendar("", "");
    // _scrollController!.addListener(() {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     _scrollListener(_scrollController!);
    //     // print(Provider.of<MainModel>(context).toString());
    //   });
    // });
  }

  // _scrollListener(ScrollController scrollInfo) {
  //   // setState(() {});
  //   // print(scrollInfo.position.minScrollExtent);
  //   if (scrollInfo.offset == 0) {
  //     Provider.of<MainModel>(context, listen: false)
  //         .setShadowActive(false);
  //   } else {
  //     Provider.of<MainModel>(context, listen: false).setShadowActive(true);
  //     print('scroll');
  //   }
  // }
  ScrollController scrollController = ScrollController();
  setDatePickerStatus(bool value) {}
  resetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // double cellWidth = isShowDetail
    //     ? (MediaQuery.of(context).size.width - 400) / 7
    //     : (MediaQuery.of(context).size.width - 50) / 7;

    return LayoutPageWeb(
      index: 4,
      scrollController: scrollController,
      setDatePickerStatus: setDatePickerStatus,
      resetState: resetState,
      topButtonVisible: false,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 70 - 115,
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 110),
                        child: calendarUserPage(),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: isShowDetail
                          ? isLoadingGetDetail
                              ? const CircularProgressIndicator(
                                  color: eerieBlack,
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width > 1366
                                          ? MediaQuery.of(context).size.height -
                                              70 -
                                              115
                                          : null,
                                  child: DetailAppointmentContainer(
                                    // event: selectedEvent,
                                    closeDetail: closeDetail,
                                    bookingDetail: detailEvent,
                                  ),
                                )
                          : SizedBox(),
                    ),
                  ],
                ),
                Visibility(
                  visible: isLoadingGetCalendar2,
                  child: Opacity(
                    opacity: 0.5,
                    child: Container(
                      color: culturedWhite,
                      width: MediaQuery.of(context).size.width,
                      height: double.infinity,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: eerieBlack,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: const BoxDecoration(
                color: white,
                // border: Border(
                //   bottom: BorderSide(color: platinum),
                // ),
              ),
              child: customHeader(),
            ),
          ),
        ],
      ),
    );
  }

  Widget customHeader() {
    return Builder(builder: (context) {
      double cellWidth = isShowDetail
          ? (MediaQuery.of(context).size.width - 400) / 7
          : (MediaQuery.of(context).size.width - 50) / 7;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isShowDetail
                ? MediaQuery.of(context).size.width - 350
                : MediaQuery.of(context).size.width,
            height: 40,
            // color: orangeAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_calendar.view == CalendarView.day) {
                          _calendar.displayDate = _calendar.displayDate!
                              .subtract(const Duration(days: 1));
                        }
                        if (_calendar.view == CalendarView.week) {
                          _calendar.displayDate = _calendar.displayDate!
                              .subtract(const Duration(days: 7));
                        }
                        if (_calendar.view == CalendarView.month) {
                          _calendar.displayDate = _calendar.displayDate!
                              .subtract(const Duration(days: 30));
                        }
                      },
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.chevron_left_sharp,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_calendar.view == CalendarView.day) {
                          _calendar.displayDate = _calendar.displayDate!
                              .add(const Duration(days: 1));
                        }
                        if (_calendar.view == CalendarView.week) {
                          _calendar.displayDate = _calendar.displayDate!
                              .add(const Duration(days: 7));
                        }
                        if (_calendar.view == CalendarView.month) {
                          _calendar.displayDate = _calendar.displayDate!
                              .add(const Duration(days: 30));
                        }
                      },
                      splashRadius: 20,
                      icon: const Icon(
                        Icons.chevron_right_sharp,
                        size: 28,
                      ),
                    ),
                    const SizedBox(
                      width: 29,
                    ),
                    Text(
                      displayMonthString,
                      style: helveticaText.copyWith(
                        color: eerieBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    RegularButton(
                      text: 'Today',
                      disabled: false,
                      padding: ButtonSize().smallSize(),
                      onTap: () {
                        _calendar.displayDate = DateTime.now();
                      },
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    const VerticalDivider(
                      color: davysGray,
                      thickness: 0.5,
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Row(
                      children: [
                        RegularButton(
                          text: 'Monthly',
                          disabled: false,
                          padding: ButtonSize().smallSize(),
                          onTap: () {
                            _calendar.view = CalendarView.month;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        RegularButton(
                          text: 'Weekly',
                          disabled: false,
                          padding: ButtonSize().smallSize(),
                          onTap: () {
                            _calendar.view = CalendarView.week;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        RegularButton(
                          text: 'Day',
                          disabled: false,
                          padding: ButtonSize().smallSize(),
                          onTap: () {
                            _calendar.view = CalendarView.day;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: isShowDetail
                ? MediaQuery.of(context).size.width - 350
                : MediaQuery.of(context).size.width,
            height: 60,
            // color: greenAcent,
            child: Builder(builder: (context) {
              if (_calendar.view == CalendarView.week) {
                return weeklyViewHeader(cellWidth);
              }
              if (_calendar.view == CalendarView.month) {
                return monthlyViewHeader(cellWidth);
              }
              if (_calendar.view == CalendarView.day) {
                return dayViewHeader(cellWidth);
              }
              return SizedBox();
            }),
          ),
        ],
      );
    });
  }

  Widget monthlyViewHeader(double cellWidth) {
    var dayTextStyle = helveticaText.copyWith(
      fontSize: 18,
      color: eerieBlack,
      fontWeight: FontWeight.w300,
    );
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader1,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader2,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader3,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader4,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader5,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader6,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Text(
              dayTextViewHeader7,
              textAlign: TextAlign.center,
              style: dayTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget weeklyViewHeader(double cellWidth) {
    var dayTextStyle = helveticaText.copyWith(
      fontSize: 14,
      color: eerieBlack,
      fontWeight: FontWeight.w300,
    );
    var dateTextStyle = helveticaText.copyWith(
      fontSize: 18,
      color: eerieBlack,
      fontWeight: FontWeight.w300,
    );

    var month = DateFormat('MM').format(DateTime.now());
    return Row(
      children: [
        Container(
          width: 50,
          decoration: const BoxDecoration(
              border: Border(
            right: BorderSide(
              color: platinum,
            ),
          )),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader1,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 3,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader1 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader1,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader1 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader2,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader2 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader2,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader2 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader3,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader3 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader3,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader3 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader4,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader4 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader4,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader4 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader5,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader5 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader5,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader5 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader6,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader6 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader6,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader6 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: cellWidth,
            child: Column(
              children: [
                Text(
                  dayTextViewHeader7,
                  textAlign: TextAlign.center,
                  style: dayTextStyle,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dateTextViewHeader7 ==
                                DateFormat('d').format(today) &&
                            DateFormat('MM').format(_calendar.displayDate!) ==
                                month
                        ? eerieBlack
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTextViewHeader7,
                      textAlign: TextAlign.center,
                      style: dateTextStyle.copyWith(
                          color: dateTextViewHeader7 ==
                                      DateFormat('d').format(today) &&
                                  DateFormat('MM')
                                          .format(_calendar.displayDate!) ==
                                      month
                              ? white
                              : eerieBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dayViewHeader(double cellWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                color: platinum,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          dayViewTextViewHeader,
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: eerieBlack,
          ),
        ),
      ],
    );
  }

  Widget calendarUserPage() {
    return SafeArea(
      child: SfCalendar(
        controller: _calendar,
        showDatePickerButton: true,
        allowViewNavigation: true,
        headerHeight: 0,
        viewHeaderHeight: 0,
        viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: eerieBlack,
            ),
            dayTextStyle: helveticaText.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: eerieBlack,
            )),
        onViewChanged: (viewChangedDetails) {
          print(_calendar.view);
          startDate = viewChangedDetails.visibleDates.first;
          endDate = viewChangedDetails.visibleDates.last;

          print("Start ${startDate.toString()}");
          print("End ${endDate.toString()}");
          // print(_calendar.view.toString());

          getUserCalendar(startDate.toString(), endDate.toString())
              .then((value) {
            setState(() {
              isLoadingGetCalendar2 = false;
            });
            print(value);
            assignDataToCalendar(value['Data']);
          }).onError((error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Error fetching user data!',
                  maxLines: 1,
                ),
              ),
            );
          });

          if (_calendar.view == CalendarView.day) {
            dayViewTextViewHeader = DateFormat('dd MMMM yyyy')
                .format(viewChangedDetails.visibleDates[0])
                .toString();
            displayMonthString = DateFormat('MMMM yyyy')
                .format(viewChangedDetails.visibleDates.first);
          }

          if (_calendar.view == CalendarView.month) {
            displayMonthString = DateFormat('MMMM yyyy')
                .format(viewChangedDetails.visibleDates[9]);
            dayTextViewHeader1 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[0])
                .toString();
            dayTextViewHeader2 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[1])
                .toString();
            dayTextViewHeader3 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[2])
                .toString();
            dayTextViewHeader4 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[3])
                .toString();
            dayTextViewHeader5 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[4])
                .toString();
            dayTextViewHeader6 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[5])
                .toString();
            dayTextViewHeader7 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[6])
                .toString();
          }

          if (_calendar.view == CalendarView.week) {
            displayMonthString = DateFormat('MMMM yyyy')
                .format(viewChangedDetails.visibleDates[4]);
            dayTextViewHeader1 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[0])
                .toString();
            dayTextViewHeader2 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[1])
                .toString();
            dayTextViewHeader3 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[2])
                .toString();
            dayTextViewHeader4 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[3])
                .toString();
            dayTextViewHeader5 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[4])
                .toString();
            dayTextViewHeader6 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[5])
                .toString();
            dayTextViewHeader7 = DateFormat('EEE')
                .format(viewChangedDetails.visibleDates[6])
                .toString();

            dateTextViewHeader1 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[0])
                .toString();
            dateTextViewHeader2 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[1])
                .toString();
            dateTextViewHeader3 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[2])
                .toString();
            dateTextViewHeader4 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[3])
                .toString();
            dateTextViewHeader5 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[4])
                .toString();
            dateTextViewHeader6 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[5])
                .toString();
            dateTextViewHeader7 = DateFormat('d')
                .format(viewChangedDetails.visibleDates[6])
                .toString();
          }

          SchedulerBinding.instance.addPostFrameCallback((duration) {
            setState(() {});
          });
        },
        headerDateFormat: 'MMMM y',
        initialDisplayDate: DateTime.now(),
        onTap: (calendarTapDetails) {
          // print(_calendar.forward);
          if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell) {}
          if (calendarTapDetails.targetElement == CalendarElement.appointment) {
            setState(() {
              Event list = calendarTapDetails.appointments![0];
              selectedEvent = list;
              if (isShowDetail) {
                isShowDetail = false;
                isLoadingGetDetail = false;
              }
              isLoadingGetDetail = true;

              getBookingDetail(selectedEvent!.bookingId!).then((value) {
                setState(() {
                  isLoadingGetDetail = false;
                  print(value);
                  detailEvent.bookingId = value['Data']['BookingID'];
                  detailEvent.location = value['Data']['RoomName'];
                  detailEvent.summary = value['Data']['Summary'];
                  detailEvent.description = value['Data']['Description'];
                  detailEvent.eventDate = value['Data']['BookingDate'];
                  detailEvent.eventTime = value['Data']['BookingStartTime'] +
                      " - " +
                      value['Data']['BookingEndTime'];
                  detailEvent.duration = value['Data']['Duration'];
                  detailEvent.floor = value['Data']['AreaName'];
                  detailEvent.email = value['Data']['Email'];
                  detailEvent.avaya = value['Data']['AvayaNumber'];
                  detailEvent.host = value['Data']['EmpName'];
                  detailEvent.attendatsNumber =
                      value['Data']['AttendantsNumber'].toString();
                  if (!isShowDetail) {
                    isShowDetail = true;
                  }
                });
              });
            });

            // print(list.capacity);
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return DetailEventDialog();
            //     });
          }
          // if (calendarTapDetails.appointments![0] != null) {
          // } else {
          //   print("kosong");
          // }
        },
        dataSource: _events,
        // showDatePickerButton: true,
        // headerDateFormat: 'MMM,yyy',
        showNavigationArrow: true,
        view: CalendarView.week,
        allowedViews: const [
          CalendarView.month,
          CalendarView.day,
          CalendarView.week,
        ],
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        // scheduleViewSettings: ScheduleViewSettings(),
        todayHighlightColor: orangeAccent,
        timeSlotViewSettings: TimeSlotViewSettings(
          // timelineAppointmentHeight: -1,
          timeIntervalHeight: 50,
          timeFormat: 'H:mm ',
          // timeIntervalWidth: -1,
          timeInterval: const Duration(
            minutes: 15,
          ),
          // dateFormat: 'd',
          // dayFormat: 'EEE',
          startHour: startTime,
          endHour: endTime,
        ),
      ),
    );
  }
}
