import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';

class EventMenuPage extends StatefulWidget {
  const EventMenuPage({super.key});

  @override
  State<EventMenuPage> createState() => _EventMenuPageState();
}

class _EventMenuPageState extends State<EventMenuPage> {
  FocusNode globalMinDuration = FocusNode();
  FocusNode globalMaxDuration = FocusNode();
  FocusNode meetingRoomMinDuration = FocusNode();
  FocusNode meetingRoomMaxDuration = FocusNode();
  FocusNode audiMinDuration = FocusNode();
  FocusNode audiMaxDuration = FocusNode();
  FocusNode socMinDuration = FocusNode();
  FocusNode socMaxDuration = FocusNode();
  FocusNode maxRepeat = FocusNode();

  String globalMinDurationValue = "";
  String globalMaxDurationValue = "";
  String meetingRoomMinDurationValue = "";
  String meetingRoomMaxDurationValue = "";
  String socMinDurationValue = "";
  String socMaxDurationValue = "";
  String maxRepeatValue = "";

  List globalTimeChoices = [];
  List timeChoices = [];

  List<DropdownMenuItem> selectTimesItem(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['Value'].toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['Name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> getCustomItemsHeights(List items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(15);
      }
    }
    return _itemsHeights;
  }

  @override
  void initState() {
    super.initState();
    globalMinDuration.addListener(() {
      setState(() {});
    });
    globalMaxDuration.addListener(() {
      setState(() {});
    });
    meetingRoomMinDuration.addListener(() {
      setState(() {});
    });
    meetingRoomMaxDuration.addListener(() {
      setState(() {});
    });
    audiMinDuration.addListener(() {
      setState(() {});
    });
    audiMaxDuration.addListener(() {
      setState(() {});
    });
    socMinDuration.addListener(() {
      setState(() {});
    });
    maxRepeat.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    globalMinDuration.removeListener(() {});
    globalMaxDuration.removeListener(() {});
    meetingRoomMinDuration.removeListener(() {});
    meetingRoomMaxDuration.removeListener(() {});
    audiMinDuration.removeListener(() {});
    audiMaxDuration.removeListener(() {});
    socMinDuration.removeListener(() {});
    maxRepeat.removeListener(() {});
    globalMinDuration.dispose();
    globalMaxDuration.dispose();
    meetingRoomMinDuration.dispose();
    meetingRoomMaxDuration.dispose();
    audiMinDuration.dispose();
    audiMaxDuration.dispose();
    socMinDuration.dispose();
    maxRepeat.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        timeRangeSection(),
      ],
    );
  }

  Widget inputField(
    String label,
    Widget widget,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 160,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        widget,
      ],
    );
  }

  Widget timeRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Booking Time Range',
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Min. Duration',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              items: [],
              enabled: true,
            ),
          ),
        )
      ],
    );
  }
}
