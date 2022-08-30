import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/routes/routes.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar_interactive_item.dart';
import 'package:provider/provider.dart';

class NavigationItem extends StatelessWidget {
  final String? title;
  final String? routeName;
  final bool? selected;
  final Function? onHighlight;

  const NavigationItem(
      {@required this.title, this.routeName, this.selected, this.onHighlight});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '$routeName');
        // navKey.currentState!.pushReplacementNamed(routeName!);
        context.go(routeName!);
        onHighlight!(routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: InteractiveNavItem(
          text: title,
          selected: selected,
          routeName: routeName,
        ),
      ),
    );
  }
}
