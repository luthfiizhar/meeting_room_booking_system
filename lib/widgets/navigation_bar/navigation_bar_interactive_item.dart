import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar_interactive_text.dart';
import 'package:universal_html/html.dart' as html;

class InteractiveNavItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  InteractiveNavItem(
      {Widget? child, String? text, bool? selected, String? routeName})
      : super(
          onHover: (PointerHoverEvent evt) {
            appContainer.style.cursor = 'pointer';
          },
          onExit: (PointerExitEvent evt) {
            appContainer.style.cursor = 'default';
          },
          child: InteractiveText(text: text!, selected: selected!),
        );
}
