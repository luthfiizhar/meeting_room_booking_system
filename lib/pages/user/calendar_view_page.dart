import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/event_class.dart';
import 'package:meeting_room_booking_system/model/event_data_source.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/calendar_menu_item.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/dialog_detail_event.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
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
  ScrollController? _scrollController = ScrollController();
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
    List<Appointment> roomEvents = <Appointment>[];
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
    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 08, 31, 14, 0, 0),
        endTime: DateTime(2022, 08, 31, 14, 30, 0),
        subject: 'General Meeting',
        color: Colors.red,
        resourceIds: ['0001', '0002'],
      ),
    );

    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 09, 2, 11, 0, 0),
        endTime: DateTime(2022, 09, 2, 14, 30, 0),
        subject: 'General Meeting',
        color: Colors.blue,
        resourceIds: ['0001', '0002'],
      ),
    );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController!.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollListener(_scrollController!);
        // print(Provider.of<LoginInfoModel>(context).toString());
      });
    });
  }

  _scrollListener(ScrollController scrollInfo) {
    // setState(() {});
    // print(scrollInfo.position.minScrollExtent);
    if (scrollInfo.offset == 0) {
      Provider.of<LoginInfoModel>(context, listen: false)
          .setShadowActive(false);
    } else {
      Provider.of<LoginInfoModel>(context, listen: false).setShadowActive(true);
      print('scroll');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginInfoModel>(builder: (context, model, child) {
        return Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(boxShadow: [
                  // model.navbarShadow
                  BoxShadow(
                    blurRadius: !model.shadowActive ? 0 : 40,
                    offset: !model.shadowActive ? Offset(0, 0) : Offset(0, 0),
                    color: Color.fromRGBO(29, 29, 29, 0.1),
                  )
                ]),
                child: NavigationBarWeb(
                  index: 4,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              // Container(
                              //   // width: 100,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       CalendarMenu(
                              //         menuName: 'My Events',
                              //         selected: selectedMenu == 1,
                              //         onHighlight: onHighlight,
                              //         index: 1,
                              //       ),
                              //       CalendarMenu(
                              //         menuName: 'Meeting Rooms',
                              //         selected: selectedMenu == 2,
                              //         onHighlight: onHighlight,
                              //         index: 2,
                              //       ),
                              //       // Chip(

                              //       //   label: Text('My Calendar'),
                              //       // ),
                              //       // Chip(label: Text('Meeting Rooms'))
                              //     ],
                              //   ),
                              // ),
                              Container(
                                height: MediaQuery.of(context).size.height,
                                child: calendarUserPage(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FooterWeb(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget calendarUserPage() {
    return SafeArea(
      child: SfCalendar(
        controller: _calendar,
        onViewChanged: (viewChangedDetails) {
          print(viewChangedDetails.visibleDates);
        },
        initialDisplayDate: DateTime.now(),
        onTap: (calendarTapDetails) {
          // print(_calendar.forward);

          if (calendarTapDetails.appointments![0] != null) {
            Event list = calendarTapDetails.appointments![0];
            print(list.capacity);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DetailEventDialog();
                });
          } else {
            print("kosong");
          }
        },
        dataSource: _getCalendarDataSource(),
        // showDatePickerButton: true,
        // headerDateFormat: 'MMM,yyy',
        showNavigationArrow: true,
        view: CalendarView.week,
        todayHighlightColor: Colors.black,
        timeSlotViewSettings: const TimeSlotViewSettings(
            // timelineAppointmentHeight: -1,
            timeIntervalHeight: -1,
            // timeIntervalWidth: -1,
            dateFormat: 'd',
            dayFormat: 'EEE',
            startHour: 6,
            endHour: 24,
            nonWorkingDays: <int>[DateTime.friday, DateTime.saturday]),
      ),
    );
  }

  calendarRoomPage() {
    return Container(
      // color: Colors.amber,
      height: MediaQuery.of(context).size.height - 130,
      child: SfCalendar(
        // onTap: (calendarTapDetails) {
        //   print(calendarTapDetails.appointments.toString());
        // },
        dataSource: _getRoomDataSource(),
        // showNavigationArrow: true,
        view: CalendarView.timelineWeek,
        timeSlotViewSettings: TimeSlotViewSettings(
          timeIntervalHeight: -1,
          // dateFormat: 'd',
          // dayFormat: 'EEE',
          // startHour: 7,
          // endHour: 21,
          // nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
        ),
        todayHighlightColor: Colors.black,
        resourceViewSettings: ResourceViewSettings(showAvatar: false),
      ),
    );
  }
}
