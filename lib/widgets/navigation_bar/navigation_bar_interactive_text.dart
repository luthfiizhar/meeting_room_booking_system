import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class InteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;

  InteractiveText({@required this.text, this.selected});

  @override
  InteractiveTextState createState() => InteractiveTextState();
}

class InteractiveTextState extends State<InteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.zero,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     color: _hovering
            //         ? eerieBlack
            //         : (widget.selected!)
            //             ? eerieBlack
            //             : Colors.transparent),
            child: Text(widget.text!,
                style: _hovering
                    ? MediaQuery.of(context).size.width <= 600
                        ? navBarTextMobile.copyWith(
                            color: navBarActiveState, height: 1.3)
                        : navBarText.copyWith(
                            color: navBarActiveState, height: 1.3)
                    : (widget.selected!)
                        ? MediaQuery.of(context).size.width < 600
                            ? navBarTextMobile.copyWith(
                                color: navBarActiveState, height: 1.3)
                            : navBarText.copyWith(
                                color: navBarActiveState, height: 1.3)
                        : MediaQuery.of(context).size.width < 600
                            ? navBarTextMobile.copyWith(height: 1.3)
                            : navBarText.copyWith(height: 1.3)),
          ),
        ),
      ),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
