import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/interactive_calendar_text.dart';
import 'package:universal_html/html.dart' as html;

class InteractiveCalendarMenuItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  InteractiveCalendarMenuItem(
      {Widget? child, String? text, bool? selected, String? routeName})
      : super(
          onHover: (PointerHoverEvent evt) {
            appContainer.style.cursor = 'pointer';
          },
          onExit: (PointerExitEvent evt) {
            appContainer.style.cursor = 'default';
          },
          child: InteractiveCalendarMenu(text: text!, selected: selected!),
        );
}
