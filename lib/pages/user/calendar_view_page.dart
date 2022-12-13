import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/event_class.dart';
import 'package:meeting_room_booking_system/model/event_data_source.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/calendar_menu_item.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/dialog_detail_event.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({Key? key}) : super(key: key);

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  CalendarController _calendar = CalendarController();
  EventDataSource _events = EventDataSource(<Event>[]);

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  String selectedView = "Weekly";

  double startTime = 6;
  double endTime = 20;
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
      _events.appointments!.add(
        Event(
          from: DateTime.parse(element['StartDateTime']),
          to: DateTime.parse(element['EndDateTime']),
          eventName: element['Summary'],
          bookingId: element['BookingID'],
        ),
      );
    }

    _events.notifyListeners(
        CalendarDataSourceAction.reset, _events.appointments!);
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
  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 4,
      scrollController: scrollController,
      setDatePickerStatus: setDatePickerStatus,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Container(
          height: MediaQuery.of(context).size.height - 115 - 60,
          child: calendarUserPage(),
        ),
      ),
    );
  }

  Widget calendarUserPage() {
    return SafeArea(
      child: SfCalendar(
        controller: _calendar,
        showDatePickerButton: true,
        allowViewNavigation: true,
        onViewChanged: (viewChangedDetails) {
          // print(viewChangedDetails.visibleDates.first);
          startDate = viewChangedDetails.visibleDates.first;
          endDate = viewChangedDetails.visibleDates.last;

          print("Start ${startDate.toString()}");
          print("End ${endDate.toString()}");
          // print(_calendar.view.toString());

          getUserCalendar(startDate.toString(), endDate.toString())
              .then((value) {
            print(value);
            assignDataToCalendar(value['Data']);
          });
        },
        headerDateFormat: 'MMMM y',
        initialDisplayDate: DateTime.now(),
        onTap: (calendarTapDetails) {
          // print(_calendar.forward);
          if (calendarTapDetails.targetElement ==
              CalendarElement.calendarCell) {}
          if (calendarTapDetails.targetElement == CalendarElement.appointment) {
            Event list = calendarTapDetails.appointments![0];
            print(list.capacity);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DetailEventDialog();
                });
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
        allowedViews: [
          CalendarView.month,
          CalendarView.day,
          CalendarView.week,
        ],
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        // scheduleViewSettings: ScheduleViewSettings(),
        todayHighlightColor: Colors.black,
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
