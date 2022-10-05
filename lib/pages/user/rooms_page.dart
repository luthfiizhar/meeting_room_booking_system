import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  CalendarController? calendarControl = CalendarController();
  int? selectedRoom = 1;

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // color: Colors.amber,
            width: 100,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(7),
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                focusColor: eerieBlack,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: eerieBlack, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Color(0xFF929AAB), width: 2)),
                fillColor: graySand,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Color(0xFF929AAB), width: 2)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              ),
              items: [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Lantai 1'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Lantai 2'),
                )
              ],
              onChanged: (value) {
                selectedRoom = int.parse(value.toString());
                setState(() {});
              },
              value: selectedRoom,
            ),
          ),
          calendarRoomPage(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: pageConstraints,
          child: Align(
            alignment: Alignment.topCenter,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      NavigationBarWeb(
                        index: 2,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // color: Colors.amber,
                            width: 100,
                            child: DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(7),
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                isDense: true,
                                focusColor: eerieBlack,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                        color: eerieBlack, width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                        color: Color(0xFF929AAB), width: 2)),
                                fillColor: graySand,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(
                                        color: Color(0xFF929AAB), width: 2)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Lantai 1'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Lantai 2'),
                                )
                              ],
                              onChanged: (value) {
                                selectedRoom = int.parse(value.toString());
                                setState(() {});
                              },
                              value: selectedRoom,
                            ),
                          ),
                          calendarRoomPage(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
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
    );
  }

  RoomEventDataSource _getRoomDataSource(int selectedRoom) {
    List<Appointment> roomEvents = <Appointment>[];
    List<CalendarResource> resourceCol = <CalendarResource>[];
    switch (selectedRoom) {
      case 1:
        resourceCol.clear();
        resourceCol.add(CalendarResource(
          displayName: 'R. 101',
          id: '0001',
          color: Colors.black54,
        ));
        resourceCol.add(CalendarResource(
          displayName: 'R. 102',
          id: '0002',
          color: Colors.black87,
        ));
        break;

      case 2:
        resourceCol.clear();
        resourceCol.add(CalendarResource(
          displayName: 'R. 201',
          id: '0003',
          color: Colors.black54,
        ));
        resourceCol.add(CalendarResource(
          displayName: 'R. 202',
          id: '0004',
          color: Colors.black87,
        ));
        resourceCol.add(CalendarResource(
          displayName: 'R. 203',
          id: '0005',
          color: Colors.black54,
        ));
        break;
      default:
    }
    // resourceCol.add(CalendarResource(
    //   displayName: 'R. 101',
    //   id: '0001',
    //   color: Colors.transparent,
    // ));
    // resourceCol.add(CalendarResource(
    //   displayName: 'R. 102',
    //   id: '0002',
    //   color: Colors.transparent,
    // ));
    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 09, 2, 14, 0, 0),
        endTime: DateTime(2022, 09, 2, 16, 0, 0),
        subject: 'General Meeting',
        color: Colors.red,
        resourceIds: ['0001'],
      ),
    );

    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 09, 2, 11, 0, 0),
        endTime: DateTime(2022, 09, 2, 14, 0, 0),
        subject: 'General Meeting 2',
        color: Colors.blue,
        resourceIds: ['0002'],
      ),
    );

    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 09, 2, 14, 0, 0),
        endTime: DateTime(2022, 09, 2, 18, 0, 0),
        subject: 'General Meeting 3',
        color: Colors.amber,
        resourceIds: ['0002'],
      ),
    );

    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 09, 2, 14, 0, 0),
        endTime: DateTime(2022, 09, 2, 18, 0, 0),
        subject: 'MRBS',
        color: Colors.green,
        resourceIds: ['0003'],
      ),
    );

    roomEvents.add(
      Appointment(
        startTime: DateTime(2022, 09, 1, 10, 0, 0),
        endTime: DateTime(2022, 09, 1, 12, 0, 0),
        subject: 'Weekly Meeting',
        color: Colors.amber,
        resourceIds: ['0004'],
      ),
    );
    return RoomEventDataSource(roomEvents, resourceCol);
  }

  Widget calendarRoomPage() {
    return Container(
      // color: Colors.amber,
      // height: MediaQuery.of(context).size.height - 60,
      // height: 500,
      child: SfCalendar(
        // allowDragAndDrop: true,

        onTap: (calendarTapDetails) {
          if (calendarTapDetails.targetElement == CalendarElement.appointment) {
            // print('Kosong gan');
            Appointment list = calendarTapDetails.appointments![0];
            print(list);
          }
        },
        dataSource: _getRoomDataSource(selectedRoom!),
        showDatePickerButton: true,
        showNavigationArrow: true,
        appointmentBuilder: appointmentBuilder,
        view: CalendarView.timelineDay,
        controller: calendarControl,
        timeSlotViewSettings: TimeSlotViewSettings(
          timeIntervalHeight: -1,
          timeIntervalWidth: -1,
          // dateFormat: 'd',
          // dayFormat: 'EEE',
          startHour: 6,
          // endHour: 24,
        ),
        todayHighlightColor: Colors.black,
        resourceViewSettings: ResourceViewSettings(
          displayNameTextStyle: TextStyle(color: Colors.white),
          showAvatar: false,
        ),
      ),
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Appointment appointment =
        calendarAppointmentDetails.appointments.first;

    return Container(
      decoration: BoxDecoration(
        color: appointment.color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(appointment.subject),
          Text(appointment.resourceIds![0].toString())
        ],
      ),
    );
  }
}
