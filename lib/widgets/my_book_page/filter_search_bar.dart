import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/white_input_field.dart';
import 'package:universal_html/html.dart' as html;

class FilterSearchBar extends StatefulWidget {
  FilterSearchBar({
    super.key,
    this.index,
  });

  int? index;

  @override
  State<FilterSearchBar> createState() => _FilterSearchBarState();
}

class _FilterSearchBarState extends State<FilterSearchBar> {
  int? index;
  bool _hovering = false;
  bool onSelected = false;
  FocusNode searchNode = FocusNode();

  TextEditingController? _search = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
  }

  void onHighlight(String type) {
    switch (type) {
      case "MeetingRoom":
        changeHighlight(0);
        break;
      case "Auditorium":
        changeHighlight(1);
        break;
      case "SocialHub":
        changeHighlight(2);
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
                        FilterSearchBarItem(
                          title: 'Meeting Room',
                          type: 'MeetingRoom',
                          onHighlight: onHighlight,
                          selected: index == 0,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        FilterSearchBarItem(
                          title: 'Auditorium',
                          type: 'Auditorium',
                          onHighlight: onHighlight,
                          selected: index == 1,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        FilterSearchBarItem(
                          title: 'Social Hub',
                          type: 'SocialHub',
                          onHighlight: onHighlight,
                          selected: index == 2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    // color: Colors.green,
                    // child: Text('haha'),
                    child: BlackInputField(
                      controller: _search!,
                      obsecureText: false,
                      enabled: true,
                      focusNode: searchNode,
                      hintText: 'Search',
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

class FilterSearchBarItem extends StatelessWidget {
  const FilterSearchBarItem({
    super.key,
    this.title,
    this.type,
    this.selected,
    this.onHighlight,
  });

  final String? title;
  final String? type;
  final bool? selected;
  final Function? onHighlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: FilterSearchBarInteractiveItem(
          text: title,
          selected: selected,
          type: type,
        ),
      ),
    );
  }
}

class FilterSearchBarInteractiveItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  FilterSearchBarInteractiveItem({
    Widget? child,
    String? text,
    bool? selected,
    String? type,
  }) : super(
          onHover: (PointerHoverEvent evt) {
            appContainer.style.cursor = 'pointer';
          },
          onExit: (PointerExitEvent evt) {
            appContainer.style.cursor = 'default';
          },
          child:
              FilterSearchBarInteractiveText(text: text!, selected: selected!),
        );
}

class FilterSearchBarInteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;

  FilterSearchBarInteractiveText({@required this.text, this.selected});

  @override
  FilterSearchBarInteractiveTextState createState() =>
      FilterSearchBarInteractiveTextState();
}

class FilterSearchBarInteractiveTextState
    extends State<FilterSearchBarInteractiveText> {
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
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide.none,
                right: BorderSide.none,
                top: BorderSide.none,
                bottom: _hovering
                    ? const BorderSide(
                        color: davysGray,
                        width: 3,
                        style: BorderStyle.solid,
                      )
                    : (widget.selected!)
                        ? const BorderSide(
                            color: davysGray,
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
                          color: eerieBlack,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        )
                      : (widget.selected!)
                          ? filterSearchBarText.copyWith(
                              color: eerieBlack,
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
