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
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        // width: 160,
        // height: 40,

        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     color: _hovering
            //         ? eerieBlack
            //         : (widget.selected!)
            //             ? eerieBlack
            //             : Colors.transparent),
            child: Column(
              children: [
                Text(widget.text!,
                    style: _hovering
                        ? MediaQuery.of(context).size.width <= 600
                            ? navBarTextMobile.copyWith(
                                color: navBarActiveState)
                            : navBarText.copyWith(color: navBarActiveState)
                        : (widget.selected!)
                            ? MediaQuery.of(context).size.width < 600
                                ? navBarTextMobile.copyWith(
                                    color: navBarActiveState)
                                : navBarText.copyWith(color: navBarActiveState)
                            : MediaQuery.of(context).size.width < 600
                                ? navBarTextMobile
                                : navBarText),
                SizedBox(
                  height: 0,
                ),
                SizedBox(
                  width: 20,
                  // height: 1,
                  child: Divider(
                    height: 2,
                    thickness: 2,
                    color: _hovering
                        ? eerieBlack
                        : (widget.selected!)
                            ? eerieBlack
                            : scaffoldBg,
                  ),
                ),
                // Container(
                //   width: 20,
                //   height: 1,
                //   decoration: BoxDecoration(
                //     // color: eerieBlack,
                //     border: Border(
                //       bottom: BorderSide(
                //         // style: BorderStyle.solid,
                //         color: _hovering
                //             ? eerieBlack
                //             : (widget.selected!)
                //                 ? eerieBlack
                //                 : scaffoldBg,
                //         width: 3,
                //       ),
                //     ),
                //   ),
                //   child: SizedBox(),
                // )
              ],
            ),
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
