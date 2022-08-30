import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({Key? key}) : super(key: key);

  @override
  State<CalendarViewPage> createState() => _CalendarViewPageState();
}

class _CalendarViewPageState extends State<CalendarViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  NavigationBarWeb(
                    index: 3,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: SfCalendar(
                      showDatePickerButton: true,
                      showNavigationArrow: true,
                      view: CalendarView.week,
                      todayHighlightColor: Colors.black,
                      timeSlotViewSettings: TimeSlotViewSettings(
                          dateFormat: 'd',
                          dayFormat: 'EEE',
                          startHour: 7,
                          endHour: 21,
                          nonWorkingDays: <int>[
                            DateTime.friday,
                            DateTime.saturday
                          ]),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
