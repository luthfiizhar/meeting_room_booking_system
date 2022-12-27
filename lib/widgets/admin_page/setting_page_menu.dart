import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/white_input_field.dart';
import 'package:universal_html/html.dart' as html;

class SettingPageMenu extends StatefulWidget {
  SettingPageMenu({
    super.key,
    this.index,
    this.menu,
    this.onChagedMenu,
    this.isAdmin = false,
  });

  int? index;
  String? menu;
  Function? onChagedMenu;
  bool isAdmin;

  @override
  State<SettingPageMenu> createState() => _SettingPageMenuState();
}

class _SettingPageMenuState extends State<SettingPageMenu> {
  int? index;
  bool _hovering = false;
  bool onSelected = false;
  FocusNode searchNode = FocusNode();
  String? roomType;

  List<Color> color = [blueAccent, greenAcent, orangeAccent, violetAccent];
  late int indexColor;
  late Color selectedColor = blueAccent;
  final _random = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    roomType = widget.menu;
    indexColor = _random.nextInt(color.length);
    selectedColor = color[indexColor];
  }

  void onHighlight(String type) {
    switch (type) {
      case "Profile":
        changeHighlight(0);
        widget.onChagedMenu!(type);
        break;
      case "Floor":
        changeHighlight(1);
        widget.onChagedMenu!(type);
        break;
      case "Area":
        changeHighlight(2);
        widget.onChagedMenu!(type);
        break;
      case "Capacity":
        changeHighlight(3);
        widget.onChagedMenu!(type);
        break;
      case "Event":
        changeHighlight(4);
        widget.onChagedMenu!(type);
        break;
      case "Facility":
        changeHighlight(5);
        widget.onChagedMenu!(type);
        break;
      case "Admin":
        changeHighlight(6);
        widget.onChagedMenu!(type);
        break;
    }
  }

  void changeHighlight(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      padding: EdgeInsets.zero,
      // height: 61,
      width: 151,
      child: Stack(
        children: [
          Container(
            width: 146,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: grayx11,
                  width: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            // bottom: 0,
            // left: 0,
            child: Container(
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SettingPageMenuItem(
                    title: 'Profile',
                    type: 'Profile',
                    onHighlight: onHighlight,
                    selected: index == 0,
                    color: selectedColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  !widget.isAdmin
                      ? SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SettingPageMenuItem(
                              title: 'Floor',
                              type: 'Floor',
                              onHighlight: onHighlight,
                              selected: index == 1,
                              color: selectedColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SettingPageMenuItem(
                              title: 'Area',
                              type: 'Area',
                              onHighlight: onHighlight,
                              selected: index == 2,
                              color: selectedColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SettingPageMenuItem(
                              title: 'Capacity',
                              type: 'Capacity',
                              onHighlight: onHighlight,
                              selected: index == 3,
                              color: selectedColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SettingPageMenuItem(
                              title: 'Event',
                              type: 'Event',
                              onHighlight: onHighlight,
                              selected: index == 4,
                              color: selectedColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SettingPageMenuItem(
                              title: 'Facility',
                              type: 'Facility',
                              onHighlight: onHighlight,
                              selected: index == 5,
                              color: selectedColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SettingPageMenuItem(
                              title: 'Admin',
                              type: 'Admin',
                              onHighlight: onHighlight,
                              selected: index == 6,
                              color: selectedColor,
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingPageMenuItem extends StatelessWidget {
  const SettingPageMenuItem({
    super.key,
    this.title,
    this.type,
    this.selected,
    this.onHighlight,
    this.color,
  });

  final String? title;
  final String? type;
  final bool? selected;
  final Function? onHighlight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: SettingPageMenuInteractiveItem(
          text: title,
          selected: selected,
          type: type,
          color: color!,
        ),
      ),
    );
  }
}

class SettingPageMenuInteractiveItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  SettingPageMenuInteractiveItem({
    Widget? child,
    String? text,
    bool? selected,
    String? type,
    Color color = blueAccent,
  }) : super(
          onHover: (PointerHoverEvent evt) {
            appContainer.style.cursor = 'pointer';
          },
          onExit: (PointerExitEvent evt) {
            appContainer.style.cursor = 'default';
          },
          child: SettingPageMenuInteractiveText(
              text: text!, selected: selected!, color: color),
        );
}

class SettingPageMenuInteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;
  final Color color;

  SettingPageMenuInteractiveText(
      {@required this.text, this.selected, this.color = blueAccent});

  @override
  SettingPageMenuInteractiveTextState createState() =>
      SettingPageMenuInteractiveTextState();
}

class SettingPageMenuInteractiveTextState
    extends State<SettingPageMenuInteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide.none,
                right: _hovering
                    ? BorderSide(
                        color: widget.color,
                        width: 3,
                        style: BorderStyle.solid,
                      )
                    : (widget.selected!)
                        ? BorderSide(
                            color: widget.color,
                            width: 3,
                            style: BorderStyle.solid,
                          )
                        : BorderSide.none,
                top: BorderSide.none,
                bottom: BorderSide.none,
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text!,
                style: _hovering
                    ? helveticaText.copyWith(
                        fontSize: 18,
                        color: widget.color, //eerieBlack,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      )
                    : (widget.selected!)
                        ? helveticaText.copyWith(
                            fontSize: 18,
                            color: widget.color,
                            fontWeight: FontWeight.w400,
                            height: 1.3,
                          )
                        : helveticaText.copyWith(
                            fontSize: 18,
                            color: navBarInActiveState,
                            fontWeight: FontWeight.w300,
                            height: 1.3,
                          ),
              ),
            ),
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
