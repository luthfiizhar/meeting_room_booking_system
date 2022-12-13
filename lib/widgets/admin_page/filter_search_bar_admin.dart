import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/white_input_field.dart';
import 'package:universal_html/html.dart' as html;

class FilterSearchBarAdmin extends StatefulWidget {
  FilterSearchBarAdmin({
    super.key,
    this.index,
    this.roomType,
    this.getRoomStatus,
    this.search,
    this.searchController,
  });

  int? index;
  String? roomType;
  Function? getRoomStatus;
  Function? search;
  TextEditingController? searchController;

  @override
  State<FilterSearchBarAdmin> createState() => _FilterSearchBarAdminState();
}

class _FilterSearchBarAdminState extends State<FilterSearchBarAdmin> {
  int? index;
  bool _hovering = false;
  bool onSelected = false;
  FocusNode searchNode = FocusNode();
  String? roomType;

  TextEditingController? _search = TextEditingController();

  List<Color> color = [blueAccent, greenAcent, orangeAccent, violetAccent];
  late int indexColor;
  late Color selectedColor = blueAccent;
  final _random = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    roomType = widget.roomType;
    indexColor = _random.nextInt(color.length);
    selectedColor = color[indexColor];
  }

  void onHighlight(String type) {
    switch (type) {
      case "Request":
        changeHighlight(0);
        widget.getRoomStatus!(type);
        break;
      case "Approved":
        changeHighlight(1);
        widget.getRoomStatus!(type);
        break;
      case "Decline":
        changeHighlight(2);
        widget.getRoomStatus!(type);
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
      height: 61,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: grayx11,
                  width: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // bottom: 0,
            // left: 0,
            child: Container(
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // width: 500,
                    child: Row(
                      children: [
                        FilterSearchBarAdminItem(
                          title: 'Request',
                          type: 'Request',
                          onHighlight: onHighlight,
                          selected: index == 0,
                          color: selectedColor,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        FilterSearchBarAdminItem(
                          title: 'Approved',
                          type: 'Approved',
                          onHighlight: onHighlight,
                          selected: index == 1,
                          color: selectedColor,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        FilterSearchBarAdminItem(
                          title: 'Declined',
                          type: 'Declined',
                          onHighlight: onHighlight,
                          selected: index == 2,
                          color: selectedColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    // color: Colors.green,
                    // child: Text('haha'),
                    child: BlackInputField(
                      controller: widget.searchController!,
                      obsecureText: false,
                      enabled: true,
                      maxLines: 1,
                      focusNode: searchNode,
                      hintText: 'Search',
                      onFieldSubmitted: (value) => widget.search!(),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: davysGray,
                      ),
                    ),
                  )
                  // Expanded(
                  //   child: Container(
                  //     //   child: WhiteInputField(
                  //     //     controller: _search!,
                  //     //     enabled: true,
                  //     //     obsecureText: false,
                  //     //   ),
                  //     child: Text('haha'),
                  //   ),
                  // ),

                  // BlackInputField(
                  //   controller: _search!,
                  //   enabled: true,
                  //   obsecureText: false,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSearchBarAdminItem extends StatelessWidget {
  const FilterSearchBarAdminItem({
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
        child: FilterSearchBarAdminInteractiveItem(
          text: title,
          selected: selected,
          type: type,
          color: color!,
        ),
      ),
    );
  }
}

class FilterSearchBarAdminInteractiveItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  FilterSearchBarAdminInteractiveItem({
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
          child: FilterSearchBarAdminInteractiveText(
              text: text!, selected: selected!, color: color),
        );
}

class FilterSearchBarAdminInteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;
  final Color color;

  FilterSearchBarAdminInteractiveText(
      {@required this.text, this.selected, this.color = blueAccent});

  @override
  FilterSearchBarAdminInteractiveTextState createState() =>
      FilterSearchBarAdminInteractiveTextState();
}

class FilterSearchBarAdminInteractiveTextState
    extends State<FilterSearchBarAdminInteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  void initState() {
    // TODO: implement initState
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
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide.none,
                right: BorderSide.none,
                top: BorderSide.none,
                bottom: _hovering
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
              ),
            ),
            child: Wrap(
              children: [
                Text(
                  widget.text!,
                  style: _hovering
                      ? filterSearchBarText.copyWith(
                          color: widget.color, //eerieBlack,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        )
                      : (widget.selected!)
                          ? filterSearchBarText.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            )
                          : filterSearchBarText.copyWith(
                              color: davysGray,
                              fontWeight: FontWeight.w300,
                              height: 1.3,
                            ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: sonicSilver,
                  ),
                  child: Text(
                    '10',
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: culturedWhite,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
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
