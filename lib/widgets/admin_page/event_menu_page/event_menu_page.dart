import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/no_border_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class EventMenuPage extends StatefulWidget {
  const EventMenuPage({super.key});

  @override
  State<EventMenuPage> createState() => _EventMenuPageState();
}

class _EventMenuPageState extends State<EventMenuPage> {
  FocusNode minTimeRange = FocusNode();
  FocusNode maxTimeRange = FocusNode();
  FocusNode interval = FocusNode();
  FocusNode globalMinDuration = FocusNode();
  FocusNode globalMaxDuration = FocusNode();
  FocusNode meetingRoomMinDuration = FocusNode();
  FocusNode meetingRoomMaxDuration = FocusNode();
  FocusNode audiMinDuration = FocusNode();
  FocusNode audiMaxDuration = FocusNode();
  FocusNode socMinDuration = FocusNode();
  FocusNode socMaxDuration = FocusNode();
  FocusNode maxRepeat = FocusNode();

  String minTimeRangeValue = "07:00";
  String maxTimeRangeValue = "19:00";
  String intervalValue = "900";
  String globalMinDurationValue = "900";
  String globalMaxDurationValue = "900";
  String meetingRoomMinDurationValue = "global";
  String meetingRoomMaxDurationValue = "global";
  String audiMinDurationValue = "global";
  String audiMaxDurationValue = "global";
  String socMinDurationValue = "global";
  String socMaxDurationValue = "global";
  String maxRepeatValue = "1";

  List<TimeRange> intervalChoices = [
    TimeRange(displayName: '15 Minutes', minuteValue: '15', secondValue: '900'),
    TimeRange(
        displayName: '30 Minutes', minuteValue: '30', secondValue: '1800'),
    TimeRange(displayName: '1 Hour', minuteValue: '60', secondValue: '2700'),
  ];

  List<TimeRange> globalChoices = [
    TimeRange(displayName: '15 Minutes', minuteValue: '15', secondValue: '900'),
    TimeRange(
        displayName: '30 Minutes', minuteValue: '30', secondValue: '1800'),
    TimeRange(displayName: '1 Hour', minuteValue: '60', secondValue: '2700'),
    TimeRange(displayName: '2 Hours', minuteValue: '120', secondValue: '7200'),
  ];

  List<TimeRange> roomChoices = [
    TimeRange(
        displayName: 'Same as global',
        minuteValue: 'global',
        secondValue: 'global'),
    TimeRange(
        displayName: 'No Limit',
        minuteValue: 'nolimit',
        secondValue: 'nolimit'),
    TimeRange(displayName: '15 Minutes', minuteValue: '15', secondValue: '900'),
    TimeRange(
        displayName: '30 Minutes', minuteValue: '30', secondValue: '1800'),
    TimeRange(displayName: '1 Hour', minuteValue: '60', secondValue: '2700'),
    TimeRange(displayName: '2 Hours', minuteValue: '120', secondValue: '7200'),
    TimeRange(displayName: '3 Hour', minuteValue: '180', secondValue: '10800'),
    TimeRange(displayName: '4 Hours', minuteValue: '240', secondValue: '14400'),
    TimeRange(displayName: '5 Hour', minuteValue: '300', secondValue: '18000'),
    // TimeRange(displayName: '6 Hours', minuteValue: '360', secondValue: '21600'),
    // TimeRange(displayName: '7 Hour', minuteValue: '420', secondValue: '25200'),
    // TimeRange(displayName: '8 Hours', minuteValue: '480', secondValue: '28800'),
    // TimeRange(displayName: '9 Hour', minuteValue: '540', secondValue: '33400'),
    TimeRange(
        displayName: '10 Hours', minuteValue: '600', secondValue: '36000'),
    // TimeRange(displayName: '11 Hour', minuteValue: '660', secondValue: '39600'),
    TimeRange(
        displayName: '12 Hours', minuteValue: '720', secondValue: '43200'),
  ];

  List maxRepeatChoices = [
    {'value': '1', 'displayName': '1 Event'},
    {'value': '3', 'displayName': '3 Events'},
    {'value': '5', 'displayName': '5 Events'},
    {'value': '10', 'displayName': '10 Events'},
    {'value': '15', 'displayName': '15 Events'},
    {'value': '20', 'displayName': '20 Events'},
    {'value': '25', 'displayName': '25 Events'},
    {'value': '30', 'displayName': '30 Events'},
  ];
  List timeChoices = [
    '01:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00',
    '24:00',
  ];

  List<DropdownMenuItem> getTimeChoices(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item.toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item,
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

  List<DropdownMenuItem> getDurationTimeChoices(List<TimeRange> items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item.secondValue.toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item.displayName,
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

  List<DropdownMenuItem> getInterval(List<TimeRange> items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item.secondValue.toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item.displayName,
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

  List<DropdownMenuItem> getMaxRepeatItems(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['value'].toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['displayName'],
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
        bookingTimeRange(),
        const SizedBox(
          height: 30,
        ),
        eventDurationGlobal(),
        const SizedBox(
          height: 30,
        ),
        eventDurationMeetingRoom(),
        const SizedBox(
          height: 30,
        ),
        eventDurationAuditorium(),
        const SizedBox(
          height: 30,
        ),
        eventDurationSocialHub(),
        const SizedBox(
          height: 28,
        ),
        const Divider(
          color: davysGray,
          thickness: 0.5,
        ),
        const SizedBox(
          height: 28,
        ),
        repeatEvent(),
        const SizedBox(
          height: 28,
        ),
        const Divider(
          color: davysGray,
          thickness: 0.5,
        ),
        const SizedBox(
          height: 28,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TransparentButtonBlack(
              text: 'Cancel',
              disabled: false,
              onTap: () {},
              padding: ButtonSize().smallSize(),
            ),
            const SizedBox(
              width: 20,
            ),
            RegularButton(
              text: 'Save',
              disabled: false,
              onTap: () {},
              padding: ButtonSize().smallSize(),
            )
          ],
        )
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

  Widget bookingTimeRange() {
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
          'Min. Time Range',
          SizedBox(
            width: 140,
            child: NoBorderDropdownButton(
              hintText: 'Choose interval',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: minTimeRangeValue,
              focusNode: minTimeRange,
              items: getTimeChoices(timeChoices),
              customHeights: getCustomItemsHeights(timeChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Max. Time Range',
          SizedBox(
            width: 140,
            child: NoBorderDropdownButton(
              hintText: 'Choose interval',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: maxTimeRangeValue,
              focusNode: maxTimeRange,
              items: getTimeChoices(timeChoices),
              customHeights: getCustomItemsHeights(timeChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Interval',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              hintText: 'Choose interval',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: intervalValue,
              focusNode: interval,
              items: getInterval(intervalChoices),
              customHeights: getCustomItemsHeights(intervalChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        // inputField(
        //   '',
        //   Expanded(
        //     child: Text(
        //       'Maximum 10 events being held in one booking. User have to book again to extend the repeat up to 10 events.',
        //       style: helveticaText.copyWith(
        //         fontSize: 16,
        //         fontWeight: FontWeight.w300,
        //         height: 1.375,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget repeatEvent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Repeat Event',
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
          'Max. Repeat',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              hintText: 'Choose max repeat',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: maxRepeatValue,
              focusNode: maxRepeat,
              items: getMaxRepeatItems(maxRepeatChoices),
              customHeights: getCustomItemsHeights(maxRepeatChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          '',
          Expanded(
            child: Text(
              'Maximum 10 events being held in one booking. User have to book again to extend the repeat up to 10 events.',
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                height: 1.375,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget eventDurationGlobal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Event Duration - Global',
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
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: globalMinDurationValue,
              focusNode: globalMinDuration,
              items: getDurationTimeChoices(globalChoices),
              customHeights: getCustomItemsHeights(globalChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Max. Duration',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: globalMaxDurationValue,
              focusNode: globalMaxDuration,
              items: getDurationTimeChoices(globalChoices),
              customHeights: getCustomItemsHeights(globalChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        )
      ],
    );
  }

  Widget eventDurationMeetingRoom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Event Duration - Meeting Room',
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
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: meetingRoomMinDurationValue,
              focusNode: meetingRoomMinDuration,
              items: getDurationTimeChoices(roomChoices),
              customHeights: getCustomItemsHeights(roomChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Max. Duration',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: meetingRoomMaxDurationValue,
              focusNode: meetingRoomMaxDuration,
              items: getDurationTimeChoices(roomChoices),
              customHeights: getCustomItemsHeights(roomChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        )
      ],
    );
  }

  Widget eventDurationAuditorium() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Event Duration - Meeting Room',
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
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: audiMinDurationValue,
              focusNode: audiMinDuration,
              items: getDurationTimeChoices(roomChoices),
              customHeights: getCustomItemsHeights(roomChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Max. Duration',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: audiMaxDurationValue,
              focusNode: audiMaxDuration,
              items: getDurationTimeChoices(roomChoices),
              customHeights: getCustomItemsHeights(roomChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        )
      ],
    );
  }

  Widget eventDurationSocialHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Event Duration - Social Hub',
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
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: socMinDurationValue,
              focusNode: socMinDuration,
              items: getDurationTimeChoices(roomChoices),
              customHeights: getCustomItemsHeights(roomChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputField(
          'Max. Duration',
          SizedBox(
            width: 250,
            child: BlackDropdown(
              hintText: 'Choose duration time',
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_sharp,
              ),
              value: socMaxDurationValue,
              focusNode: socMaxDuration,
              items: getDurationTimeChoices(roomChoices),
              customHeights: getCustomItemsHeights(roomChoices),
              enabled: true,
              onChanged: (value) {},
            ),
          ),
        )
      ],
    );
  }
}

class TimeRange {
  TimeRange({
    this.displayName = "",
    this.minuteValue = "",
    this.secondValue = "",
  });
  String displayName;
  String secondValue;
  String minuteValue;

  @override
  String toString() {
    return "{displayName : $displayName, secondValue = $secondValue, minuteValue = $minuteValue}";
  }
}
