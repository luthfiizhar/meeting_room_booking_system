import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class InteractiveCalendarMenu extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveCalendarMenu({@required this.text, this.selected});

  @override
  InteractiveCalendarMenuState createState() => InteractiveCalendarMenuState();
}

class InteractiveCalendarMenuState extends State<InteractiveCalendarMenu> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // width: 160,
        // height: 40,

        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _hovering
                    ? eerieBlack
                    : (widget.selected!)
                        ? eerieBlack
                        : Colors.transparent),
            child: Text(widget.text!,
                style: _hovering
                    ? navBarText.copyWith(color: Colors.white)
                    : (widget.selected!)
                        ? navBarText.copyWith(color: Colors.white)
                        : navBarText.copyWith(color: Colors.black)),
          ),
        ),
      ),

      // Text(widget.text!,
      // style: _hovering
      //     ? kPageTitleStyle.copyWith(color: Colors.indigo)
      //     : (widget.selected!)
      //         ? kPageTitleStyle.copyWith(color: Colors.red)
      //         : kPageTitleStyle),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
