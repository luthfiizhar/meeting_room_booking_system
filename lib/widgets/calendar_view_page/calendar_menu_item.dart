import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/interactive_calendar_menu_item.dart';

class CalendarMenu extends StatelessWidget {
  const CalendarMenu({
    Key? key,
    this.menuName,
    this.selected,
    this.onHighlight,
    this.index,
  }) : super(key: key);

  final String? menuName;
  final bool? selected;
  final Function? onHighlight;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(index);
      },
      child: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(10),
        child: InteractiveCalendarMenuItem(text: menuName, selected: selected),
      ),
    );
  }
}
