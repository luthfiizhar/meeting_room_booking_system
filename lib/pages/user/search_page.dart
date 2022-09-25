import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_white.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/calendar_menu_item.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/input/input_search_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:meeting_room_booking_system/widgets/search_page/check_box_amenities.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? _bookDate = TextEditingController();
  TextEditingController? _startTime = TextEditingController();
  TextEditingController? _endTime = TextEditingController();
  TextEditingController? _participant = TextEditingController();

  int? participant = 1;

  int? selectedRoom = 1;

  int activeCalendarMenu = 2;
  int selectedMenu = 1;

  bool checkBoxAmenTv = false;
  bool checkBoxAmenCam = false;
  List? selectedAmen = [];

  final _formKey = new GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();

  List<Room> roomList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _participant!.text = participant.toString();
    roomList.add(Room(
      roomId: 'R202',
      roomName: 'PERSISTANCE',
      areaId: '2',
      availability: true,
      bookingDuration: '2',
      capacity: '8',
      roomType: 'medium',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  NavigationBarWeb(
                    index: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: searchRoom(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FooterWeb(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchRoom() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: 450,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: eerieBlack),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 6,
                    child: bookingDateInput(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    // flex: 6,
                    child: checkBoxAmenities(),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: bookingTimeInput(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: participantInput(),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: RegularButton(
                  text: 'Search',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  disabled: true,
                  padding: ButtonSize().longSize(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: TransparentButtonBlack(
                  padding: ButtonSize().longSize(),
                  text: 'Search',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfirmDialogBlack(
                          title: 'Confirmation',
                          contentText: 'Are you sure?',
                        );
                      },
                    );
                  },
                  // backgroundColor: cardBg,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 300,
          width: 500,
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  // width: 250,
                  child: WhiteRegularButton(
                    padding: ButtonSize().mediumSize(),
                    text: 'Search',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ConfirmDialogBlack(
                            title: 'Confirmation',
                            contentText:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed semper ligula quam, id pretium ligula euismod non',
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: TransparentButtonWhite(
                    padding: ButtonSize().mediumSize(),
                    text: 'Search',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Available Rooms'),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: roomList.length,
                  itemBuilder: (context, index) {
                    // var list = roomList;
                    return LayoutBuilder(builder: (context, constraints) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 400,
                          // height: 100,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: eerieBlack),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 175,
                                // height: double.infinity,
                                // decoration: BoxDecoration(),
                                // clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  'assets/persistance_1.png',
                                  fit: BoxFit.cover,
                                ),
                                // child: SizedBox(),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        roomList[index].roomName!,
                                        style: cardHeaderText,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .watch_later_outlined,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: roomList[index]
                                                                .availability!
                                                            ? "Available"
                                                            : "Not Available",
                                                        style: cardContentText
                                                            .copyWith(
                                                          color: roomList[index]
                                                                  .availability!
                                                              ? Colors.green
                                                              : orangeRed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${roomList[index].capacity} Person',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .corporate_fare_sharp,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${roomList[index].areaId} Floor',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Amenities :',
                                                  style: cardContentText,
                                                ),
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.tv_sharp,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'TV',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.videocam_sharp,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Camera',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RegularButton(
                                        text: 'Book',
                                        fontSize: 12,
                                        onTap: () {},
                                        disabled: false,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bookingTimeInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time Start'),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(_startTime!);
                    },
                    child: InputSearch(
                      controller: _startTime,
                      enabled: false,
                      suffix: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: scaffoldBg,
                        size: 20,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Required";
                        }
                        if (_endTime!.text == "") {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectTime(_startTime!);
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time End'),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (() {
                      _selectTime(_endTime!);
                    }),
                    child: InputSearch(
                      controller: _endTime,
                      enabled: false,
                      suffix: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: scaffoldBg,
                        size: 20,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Required";
                        }
                        if (_startTime!.text == "") {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectTime(_endTime!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget participantInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Participant (total person)'),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 130,
              child: InputSearch(
                controller: _participant,
                enabled: false,
                suffix: Icon(
                  Icons.people_sharp,
                  size: 20,
                  color: scaffoldBg,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              height: 40,
              child: Column(children: [
                InkWell(
                  onTap: () {
                    participant = participant! + 1;
                    _participant!.text = participant.toString();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.keyboard_arrow_up_sharp,
                    size: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    participant = participant! - 1;
                    if (participant! <= 0) {
                      participant = 1;
                    }
                    _participant!.text = participant.toString();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 20,
                  ),
                )
              ]),
            )
            // Expanded(
            //   child: SizedBox(
            //     height: 40,
            //     child: ElevatedButton(
            //       child: Icon(Icons.search_sharp),
            //       onPressed: () {
            //         if (_formKey.currentState!.validate()) {}
            //       },
            //       style: ButtonStyle(
            //         foregroundColor:
            //             MaterialStateProperty.resolveWith(getColor),
            //         backgroundColor:
            //             MaterialStateProperty.resolveWith<Color>((states) {
            //           return spanishGray;
            //         }),
            //         shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
            //             (Set<MaterialState> states) {
            //           if (states.contains(MaterialState.pressed))
            //             return RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10),
            //                 side: BorderSide(color: eerieBlack, width: 5));
            //           return RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10));
            //         }),
            //         overlayColor: MaterialStateProperty.resolveWith<Color?>(
            //           (Set<MaterialState> states) {
            //             if (states.contains(MaterialState.pressed))
            //               return Colors.white; //<-- SEE HERE
            //             return null; // Defer to the widget's default.
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget bookingDateInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Booking For'),
        SizedBox(
          height: 10,
        ),
        InputSearch(
          controller: _bookDate,
          enabled: true,
          prefix: Icon(
            Icons.calendar_month_outlined,
            color: scaffoldBg,
            size: 20,
          ),
          onTap: () {
            _selectStartDate();
          },
        ),
      ],
    );
  }

  Future _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: eerieBlack,
                onPrimary: silver,
                onSurface: eerieBlack,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: eerieBlack,
                ),
              ),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        });

    if (picked_s != null) {
      final hour = picked_s.hour.toString().padLeft(2, '0');
      final minute = picked_s.minute.toString().padLeft(2, '0');
      setState(() {
        selectedTime = picked_s;
        controller.text = "$hour:$minute";
      });
    }
  }

  Future _selectStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: eerieBlack,
              onPrimary: silver,
              onSurface: eerieBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: eerieBlack,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String formattedDate = DateFormat('d MMMM yyyy').format(picked!);
    if (picked != null)
      setState(() {
        _bookDate!.text = formattedDate;
      });
  }

  Widget checkBoxAmenities() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amenities'),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            CheckBoxAmenities(
              selectedValue: checkBoxAmenTv,
              onChanged: (value) {
                print('check');
                if (checkBoxAmenTv) {
                  checkBoxAmenTv = false;
                  selectedAmen!.removeWhere((element) => element == 'tv');
                } else {
                  checkBoxAmenTv = true;
                  selectedAmen!.add('tv');
                }
                setState(() {});
                print(selectedAmen);
              },
              label: 'TV',
            ),
            CheckBoxAmenities(
              selectedValue: checkBoxAmenCam,
              onChanged: (value) {
                if (checkBoxAmenCam) {
                  checkBoxAmenCam = false;
                  selectedAmen!.removeWhere((element) => element == 'cam');
                } else {
                  checkBoxAmenCam = true;
                  selectedAmen!.add('cam');
                }
                setState(() {});
                print(selectedAmen);
              },
              label: 'Camera',
            ),
          ],
        )
      ],
    );
  }
}
