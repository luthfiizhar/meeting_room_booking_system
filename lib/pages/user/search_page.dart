import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/pages/user/onboard_page.dart';
import 'package:meeting_room_booking_system/widgets/amenities_container.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_white.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/calendar_menu_item.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/white_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_white.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/white_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/end_time_container.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/input/input_search_page.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/white_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/meeting_type_container.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:meeting_room_booking_system/widgets/participant_container.dart';
import 'package:meeting_room_booking_system/widgets/pop_up_profile.dart';
import 'package:meeting_room_booking_system/widgets/search_container.dart';
import 'package:meeting_room_booking_system/widgets/search_page/check_box_amenities.dart';
import 'package:meeting_room_booking_system/widgets/search_page/filter_container.dart';
import 'package:meeting_room_booking_system/widgets/search_page/list_card.dart';
import 'package:meeting_room_booking_system/widgets/search_page/sorting_container.dart';
import 'package:meeting_room_booking_system/widgets/start_time_container.dart';
import 'package:meeting_room_booking_system/widgets/time_picker_container.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // TextEditingController? _bookDate = TextEditingController();
  // TextEditingController? _startTime = TextEditingController();
  // TextEditingController? _endTime = TextEditingController();
  // TextEditingController? _participant = TextEditingController();

  // FocusNode _testInputNode = FocusNode();
  // FocusNode _testInput2Node = FocusNode();
  // FocusNode _testInputWhiteNode = FocusNode();
  // FocusNode _dropdownBlackNode = FocusNode();
  // FocusNode _dropdownWhiteNode = FocusNode();
  // FocusNode _blackDateNode = FocusNode();

  // TextEditingController? _testInputField = TextEditingController();
  // TextEditingController? _testInputFieldDisabled = TextEditingController();
  // TextEditingController? _testInputWhiteField = TextEditingController();

  // String? dropdownBlackValue;

  // final List<String> items = [
  //   'Item1',
  //   'Item2',
  //   'Item3',
  //   'Item4',
  // ];

  // bool isPassword = true;

  // int? participant = 1;

  // int? selectedRoom = 1;

  // int activeCalendarMenu = 2;
  // int selectedMenu = 1;

  // bool checkBoxAmenTv = false;
  // bool checkBoxAmenCam = false;
  // List? selectedAmen = [];

  // final _formKey = new GlobalKey<FormState>();

  // TimeOfDay selectedTime = TimeOfDay.now();

  // List<Room> roomList = [];

  // BoxShadow? navbarShadow = BoxShadow(
  //   blurRadius: 0,
  //   offset: Offset(0, 0),
  // );

  // // ScrollController? _scrollController = ScrollController();

  // bool profileVisible = false;

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     Provider.of<MainModel>(context, listen: false).setShadowActive(false);
  //   });

  //   // TODO: implement initState
  //   super.initState();
  //   _participant!.text = participant.toString();
  //   roomList.add(Room(
  //     roomId: 'R202',
  //     roomName: 'PERSISTANCE',
  //     areaId: '2',
  //     availability: true,
  //     bookingDuration: '2',
  //     capacity: '8',
  //     roomType: 'medium',
  //   ));

  //   _testInputNode.addListener(() {
  //     setState(() {});
  //   });
  //   _testInputWhiteNode.addListener(() {
  //     setState(() {});
  //   });
  //   _dropdownBlackNode.addListener(() {
  //     setState(() {});
  //   });
  //   _dropdownWhiteNode.addListener(() {
  //     setState(() {});
  //   });
  //   _blackDateNode.addListener(() {
  //     setState(() {});
  //   });
  //   _testInput2Node.addListener(() {
  //     setState(() {});
  //   });

  //   // _scrollController!.addListener(() {
  //   //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //   //     _scrollListener(_scrollController!,
  //   //         Provider.of<MainModel>(context, listen: false));
  //   //     // print(Provider.of<MainModel>(context).toString());
  //   //   });
  //   // });
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _testInputNode.dispose();
  //   _testInputWhiteNode.dispose();
  //   _dropdownBlackNode.dispose();
  //   _blackDateNode.dispose();
  //   _bookDate!.dispose();
  //   _endTime!.dispose();
  //   _participant!.dispose();
  //   _startTime!.dispose();
  //   _testInputField!.dispose();
  //   _testInputWhiteField!.dispose();
  // }

  // List<DropdownMenuItem<String>> addDividerItem(List<String> items) {
  //   List<DropdownMenuItem<String>> _menuItems = [];
  //   for (var item in items) {
  //     _menuItems.addAll(
  //       [
  //         DropdownMenuItem<String>(
  //           value: item,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0),
  //             child: Text(
  //               item,
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w300,
  //               ),
  //             ),
  //           ),
  //         ),
  //         //If it's last item, we will not add Divider after it.
  //         if (item != items.last)
  //           DropdownMenuItem<String>(
  //             enabled: false,
  //             child: Divider(),
  //           ),
  //       ],
  //     );
  //   }
  //   return _menuItems;
  // }

  // List<DropdownMenuItem<String>> addDividerItemWhite(List<String> items) {
  //   List<DropdownMenuItem<String>> _menuItems = [];
  //   for (var item in items) {
  //     _menuItems.addAll(
  //       [
  //         DropdownMenuItem<String>(
  //           value: item,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 0),
  //             child: Text(
  //               item,
  //               style: const TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.w300,
  //               ),
  //             ),
  //           ),
  //         ),
  //         //If it's last item, we will not add Divider after it.
  //         if (item != items.last)
  //           DropdownMenuItem<String>(
  //             enabled: false,
  //             child: Divider(
  //               color: culturedWhite,
  //             ),
  //           ),
  //       ],
  //     );
  //   }
  //   return _menuItems;
  // }

  // List<double> _getCustomItemsHeights(List items) {
  //   List<double> _itemsHeights = [];
  //   for (var i = 0; i < (items.length * 2) - 1; i++) {
  //     if (i.isEven) {
  //       _itemsHeights.add(40);
  //     }
  //     //Dividers indexes will be the odd indexes
  //     if (i.isOdd) {
  //       _itemsHeights.add(15);
  //     }
  //   }
  //   return _itemsHeights;
  // }

  // // _scrollListener(ScrollController scrollInfo, MainModel model) {
  // //   // setState(() {});
  // //   // print(scrollInfo.position.minScrollExtent);
  // //   if (scrollInfo.offset == 0) {
  // //     Provider.of<MainModel>(context, listen: false)
  // //         .setShadowActive(false);
  // //   } else {
  // //     Provider.of<MainModel>(context, listen: false).setShadowActive(true);
  // //     print('scroll');
  // //   }
  // // }

  // // _onStartScroll(ScrollMetrics metrics) {
  // //   print("Scroll Start");
  // // }

  // // _onUpdateScroll(ScrollMetrics metrics) {
  // //   print("Scroll Update");
  // // }

  // // _onEndScroll(ScrollMetrics metrics) {
  // //   print("Scroll End");
  // // }

  // popUpProfile(bool value) {
  //   if (profileVisible) {
  //     profileVisible = value;
  //   } else {
  //     profileVisible = value;
  //   }
  //   setState(() {});
  // }

  // setDatePickerStatus(bool value) {}

  TextEditingController _dateController = TextEditingController();
  TextEditingController _facilityController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _participantController = TextEditingController();
  DateRangePickerController datePickerControl = DateRangePickerController();

  bool showOnBoard = false;
  bool opacityOn = false;

  bool profileVisible = false;
  // final loginInfo = MainModel();

  bool checkBoxTv = false;
  bool checkBoxCamera = false;
  bool isSearching = false;
  List facilitySelected = [];
  List startTimeList = [];
  List endTimeList = [];
  List searchResult = [];
  String participantSelected = "";
  String startTime = "";
  String endTime = "";
  String initialEndTime = "";
  String meetingTypeName = "Meeting Room";
  String meetingTypeValue = "MeetingRoom";
  dynamic roomType;
  String sort = "alphabetical";
  dynamic resultArea;

  List<RadioModel> listSorting = [
    RadioModel(isSelected: false, text: 'Lowest Floor'),
    RadioModel(isSelected: false, text: 'Highest Floor'),
    RadioModel(isSelected: false, text: 'Lowest Capacity'),
    RadioModel(isSelected: false, text: 'Highest Capacity'),
    RadioModel(isSelected: false, text: 'Alphabetical'),
  ];
  String selectedSorting = "Lowest Floor";

  List<CheckBoxModel>? listFilter = [];
  List submitFilter = [];
  List selectedFilter = ['1', '2', '3', '4'];

  DateTime selectedDate = DateTime.now();
  String selectedDateFormatted = "";

  List<TargetFocus> targets = [];
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();
  GlobalKey key4 = GlobalKey();
  GlobalKey key5 = GlobalKey();
  GlobalKey key6 = GlobalKey();

  Future showTutorial() async {
    tutorialCoachMark = TutorialCoachMark(
      targets: targets, // List<TargetFocus>
      // colorShadow: Colors.red, // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        Provider.of<MainModel>(context, listen: false).onBoardDone();
        print("skip");
      },
      onFinish: () {
        print("finish");
      },
    );
    // TutorialCoachMark().show(context: context);
    if (Provider.of<MainModel>(context, listen: false).firstLogin) {
      tutorialCoachMark.show(context: context);
    }
    // return "";
  }

  addTarget() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: key1,
        shape: ShapeLightFocus.RRect,
        radius: 7,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              // customPosition: CustomTargetContentPosition(top: 100, right: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Home",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Halaman utama user.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                          onPressed: () {
                            tutorialCoachMark.next();
                          },
                          child: Text('Next')))
                ],
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: key2,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Search Room",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Untuk mencari ruang meeting yang tersedia.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 3",
        keyTarget: key3,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "My Bookings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "List booking user.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 4",
        keyTarget: key4,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Calendar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Calendar user (sync with Google Calendar).",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 5",
        keyTarget: key5,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Logout mengakhiri sesi user.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 6",
        keyTarget: key6,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Konten",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Konten.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _datePickerOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: 485,
        left: 183,
        child: CustomDatePicker(
          controller: datePickerControl,
          changeDate: onDateChanged,
          setPickerStatus: setDatePickerVisible,
          currentDate: selectedDate,
        ),
      );
    });

    overlayState!.insert(overlayEntry);
  }

  initTime() {
    int minute = TimeOfDay.now().minute;
    int hour = TimeOfDay.now().hour;
    int minuteEndInit = 0;
    int hourEndInit = 0;
    if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
      minute = TimeOfDay.now().replacing(minute: 15).minute;
    } else if (TimeOfDay.now().minute > 15 && TimeOfDay.now().minute <= 30) {
      minute = TimeOfDay.now().replacing(minute: 30).minute;
    } else if (TimeOfDay.now().minute > 30 && TimeOfDay.now().minute <= 45) {
      minute = TimeOfDay.now().replacing(minute: 45).minute;
    } else if (TimeOfDay.now().minute > 45 && TimeOfDay.now().minute <= 60) {
      minute = TimeOfDay.now().replacing(minute: 0).minute;
      hour = TimeOfDay.now().hour + 1;
    }
    var hourString =
        TimeOfDay(hour: hour, minute: minute).hour.toString().padLeft(2, '0');
    var minuteString =
        TimeOfDay(hour: hour, minute: minute).minute.toString().padLeft(2, '0');
    minuteEndInit = int.parse(minuteString) + 15;
    hourEndInit = hour;
    var minuteEndString;
    print(minuteEndInit);
    if (minuteEndInit == 60) {
      print('masuk sini');

      minuteEndString =
          TimeOfDay(hour: hour, minute: 0).minute.toString().padLeft(2, '0');
      print(hour);
      print(hourEndInit);
      print(minuteEndString);
    }
    minuteEndString = minuteEndInit.toString();
    startTime = "$hourString:$minuteString";
    initialEndTime = "$hourEndInit:$minuteEndString";
    endTime = initialEndTime;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
    _facilityController.dispose();
    _timeController.dispose();
    _participantController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAreaList().then((value) {
      setState(() {
        resultArea = value['Data'];

        for (var element in resultArea) {
          listFilter!.add(CheckBoxModel(
            name: element['AreaName'],
            value: element['AreaID'].toString(),
            selected: true,
          ));
          // submitFilter.add("\"${element['AreaID']}\"");
        }
      });
      print(submitFilter);
      // print(listFilter);
    });
    String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
    _dateController.text = formattedDate;
    _facilityController.text = 'None';
    _timeController.text = 'Choose Time';
    _participantController.text = 'Total Participant';
    participantSelected = "0";

    initTime();
    getRoomType().then((value) {
      print(value);
      if (value['Status'] == "200") {
        roomType = value['Data'];
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
    // addTarget();
    // Future.delayed(
    //   Duration(milliseconds: 500),
    //   () {
    //     showTutorial().then((value) {
    //       Provider.of<MainModel>(context, listen: false).onBoardDone();
    //     });
    //   },
    // );
    // showBoardingPage();
    // checkOnBoardingPage();
    // showBoardingPage();
    dateNode.addListener(() {
      setState(() {
        // getPosition();
      });
    });
  }

  popUpProfile(bool value) {
    if (profileVisible) {
      profileVisible = value;
    } else {
      profileVisible = value;
    }
    setState(() {});
  }

  checkOnBoardingPage() async {
    var box = await Hive.openBox('userLogin');

    var firstLogin = box.get('firstLogin') != "" ? false : true;

    showOnBoard = firstLogin;
    setState(() {});
  }

  showBoardingPage() {
    print(Provider.of<MainModel>(context, listen: false).firstLogin);
    if (Provider.of<MainModel>(context, listen: false).firstLogin) {
      Future.delayed(
        Duration(milliseconds: 500),
        () {
          showDialog(
            context: context,
            builder: (context) {
              return OnBoardPage();
            },
          );
        },
      );
    } else {}
  }

  FocusNode dateNode = FocusNode();

  String datePicked = "";

  double mouseX = 0;
  double mouseY = 0;

  GlobalKey searchContainerKey = GlobalKey();
  GlobalKey dateKey = GlobalKey();
  GlobalKey timeKey = GlobalKey();
  GlobalKey participantKey = GlobalKey();
  GlobalKey amenitiesKey = GlobalKey();
  GlobalKey meetingTypeKey = GlobalKey();

  final dataKey = GlobalKey();

  bool datePickerVisible = false;
  bool amenitiesContainerVisible = false;
  bool participantContainerVisible = false;
  bool timePickerContainerVisible = false;
  bool startTimeContainerVisible = false;
  bool endTimeContainerVisible = false;
  bool meetingTypeContainerVisible = false;

  void _updateLocation(PointerHoverEvent event) {
    setState(() {
      mouseX = event.localPosition.dx;
      mouseY = event.localPosition.dy;
    });
  }

  void getPositionDatePicker() {
    RenderBox box =
        searchContainerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;
    mouseX = x;
    mouseY = y;
    // if (datePickerVisible) {
    //   datePickerVisible = false;
    // } else {
    //   datePickerVisible = true;
    // }
    datePickerVisible = true;

    // print(y);
    setState(() {});
  }

  void getPositionAmenities() {
    RenderBox box =
        searchContainerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;
    mouseX = x;
    mouseY = y;
    // if (datePickerVisible) {
    //   datePickerVisible = false;
    // } else {
    //   datePickerVisible = true;
    // }
    amenitiesContainerVisible = true;

    // print(y);
    setState(() {});
  }

  void getPositionParticipant() {
    RenderBox box =
        searchContainerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;
    mouseX = x;
    mouseY = y;

    // if (datePickerVisible) {
    //   datePickerVisible = false;
    // } else {
    //   datePickerVisible = true;
    // }
    participantContainerVisible = true;

    // print(y);
    setState(() {});
  }

  setStartTimeList(List value) {
    startTimeList = value;
    // setOpacityOn(false);
    setState(() {});
  }

  setEndTimeList(List value) {
    endTimeList = value;
    // setOpacityOn(false);
    setState(() {});
  }

  onDateChanged(String value, DateTime date) {
    datePicked = value;
    selectedDate = date;
    _dateController.text = datePicked;
    if (DateFormat('yyyy-MM-dd').format(date) !=
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      startTime = '07:00';
      endTime = '07:15';
    } else {
      dynamic hour = TimeOfDay.now().hour;
      dynamic minute = TimeOfDay.now().minute;
      dynamic endMinute = minute;
      dynamic endHour = hour;
      if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
        minute = TimeOfDay.now().replacing(minute: 15).minute;
      } else if (TimeOfDay.now().minute > 15 && TimeOfDay.now().minute <= 30) {
        minute = TimeOfDay.now().replacing(minute: 30).minute;
      } else if (TimeOfDay.now().minute > 30 && TimeOfDay.now().minute <= 45) {
        minute = TimeOfDay.now().replacing(minute: 45).minute;
      } else if (TimeOfDay.now().minute > 45 && TimeOfDay.now().minute <= 60) {
        minute = TimeOfDay.now().replacing(minute: 0).minute;
        hour = hour + 1;
      }
      endMinute = minute + 15;
      if (endMinute == 60) {
        endHour = hour;
        endMinute = 0;
      }
      hour = hour.toString().padLeft(2, '0');
      minute = minute.toString().padLeft(2, '0');

      endHour = endHour.toString().padLeft(2, '0');
      endMinute = endMinute.toString().padLeft(2, '0');

      startTime = "$hour:$minute";
      endTime = "$hour:$endMinute";
    }
    setOpacityOn(false);
    setState(() {});
  }

  onParticipanSelected(String value) {
    participantSelected = value;
    _participantController.text = "$participantSelected Person";
    setOpacityOn(false);
    setState(() {});
  }

  onMeetingTypeSelected(String value, String name) {
    meetingTypeValue = value;
    meetingTypeName = name;
    setOpacityOn(false);
    setState(() {});
  }

  setStartTime(String start) {
    startTime = start;
    setState(() {});
  }

  setEndTime(String end) {
    endTime = end;
    setState(() {});
  }

  setInitialEndTime(String value) {
    initialEndTime = value;
    setState(() {});
  }

  setTime(String start, String end) {
    startTime = start;
    endTime = end;
    _timeController.text = "$startTime - $endTime";
    setState(() {});
  }

  setStartTimeStatus(bool value) {
    startTimeContainerVisible = value;
    setState(() {});
  }

  setEndTimeStatus(bool value) {
    endTimeContainerVisible = value;
    setState(() {});
  }

  setMeetingTypeContainerStatus(bool value) {
    meetingTypeContainerVisible = value;
    setState(() {});
  }

  setAmenitiesStatus(bool value) {
    amenitiesContainerVisible = value;
    setState(() {});
  }

  setOpacityOn(bool value) {
    opacityOn = value;
    setState(() {});
  }

  setDatePickerVisible(bool value) {
    // RenderBox box = dateKey.currentContext!.findRenderObject() as RenderBox;
    // Offset position = box.localToGlobal(Offset.zero);
    // double y = position.dy;
    // double x = position.dx;
    // mouseX = x;
    // mouseY = y;
    // print(mouseX);
    // print(mouseY);
    datePickerVisible = value;
    // _datePickerOverlay(context);
    setState(() {});
  }

  setParticipantStatus(bool value) {
    participantContainerVisible = value;
    setState(() {});
  }

  setTimePickerStatus(bool value) {
    timePickerContainerVisible = value;
    setState(() {});
  }

  resetAllVisibleStatus(bool value) {
    datePickerVisible = value;
    amenitiesContainerVisible = value;
    participantContainerVisible = value;
    timePickerContainerVisible = value;
    startTimeContainerVisible = value;
    endTimeContainerVisible = value;
    meetingTypeContainerVisible = value;
    opacityOn = value;
    setState(() {});
  }

  onChangeFilter() {
    print(listFilter);
    submitFilter.clear();
    for (var element in listFilter!) {
      if (element.selected!) {
        submitFilter.add("\"${element.value}\"");
      }
    }
    List listAmen = [];
    for (var element in facilitySelected) {
      listAmen.add('"$element"');
    }

    print(listAmen);
    searchRoomApi(
      selectedDateFormatted,
      startTime,
      endTime,
      participantSelected,
      listAmen.toString(),
      meetingTypeValue,
      submitFilter,
      sort,
    ).then((value) {
      setState(() {
        isSearching = false;
        searchResult = value["Data"]["Room"];
      });
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Can\'t Connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      ).then((value) {
        setState(() {
          isSearching = false;
        });
      });
    });
  }

  searchRoom() {
    setOpacityOn(false);
    setState(() {
      isSearching = true;
    });
    selectedDateFormatted = DateFormat('yyyy-M-dd').format(selectedDate);

    if (submitFilter.isEmpty) {
      for (var element in listFilter!) {
        element.selected = true;
      }
      for (var element in resultArea) {
        submitFilter.add("\"${element['AreaID']}\"");
      }
    }
    List listAmen = [];
    for (var element in facilitySelected) {
      listAmen.add('"$element"');
    }

    print(listAmen);
    searchRoomApi(
      selectedDateFormatted,
      startTime,
      endTime,
      participantSelected,
      listAmen.toString(),
      meetingTypeValue,
      submitFilter,
      sort,
    ).then((value) {
      setState(() {
        isSearching = false;
        searchResult = value["Data"]["Room"];
      });
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Can\'t Connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      ).then((value) {
        setState(() {
          isSearching = false;
        });
      });
    });
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 1,
      scrollController: scrollController,
      setDatePickerStatus: resetAllVisibleStatus,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Form(
          // key: _formKey,
          // child: searchRoom(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 1100,
              // maxWidth: 1100,
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    // color: Colors.blue,
                    width: 1100,
                    child: Stack(
                      children: [
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            Container(
                              // color: Colors.amber,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 475,
                                    maxWidth: 1100,
                                  ),
                                  child: Container(
                                    // color: Colors.greenAccent,
                                    height: 475,
                                    width: 1100,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            width: 1100,
                                            height: 400,
                                            decoration: BoxDecoration(
                                              color: graySand,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              // image: DecorationImage(
                                              //   image:
                                              //       AssetImage('assets/social_hub.jpg'),
                                              //   fit: BoxFit.cover,
                                              // ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 185,
                                          right: 0,
                                          child: Container(
                                            // color: Colors.black,
                                            decoration: const BoxDecoration(
                                              color: eerieBlack,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5),
                                              ),
                                            ),
                                            padding: const EdgeInsets.only(
                                              right: 15,
                                              left: 25,
                                              top: 10,
                                              bottom: 10,
                                            ),
                                            // height: 30,
                                            // width: 30,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Social Hub',
                                                  style: TextStyle(
                                                    fontFamily: 'Helvetica',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: culturedWhite,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '- Head Office',
                                                  style: TextStyle(
                                                    fontFamily: 'Helvetica',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w300,
                                                    color: culturedWhite,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 50,
                                          child: GestureDetector(
                                            onTap: () {
                                              resetAllVisibleStatus(false);
                                              // setDatePickerVisible(false);
                                              // setAmenitiesStatus(false);
                                            },
                                            child: SearchContainer(
                                              key: searchContainerKey,
                                              dateNode: dateNode,
                                              getPositionDatePicker:
                                                  getPositionDatePicker,
                                              getPositionAmenities:
                                                  getPositionAmenities,
                                              getPositionparticipant:
                                                  getPositionParticipant,
                                              setPickerStatus:
                                                  setDatePickerVisible,
                                              setAmenitiesStatus:
                                                  setAmenitiesStatus,
                                              setParticipantStatus:
                                                  setParticipantStatus,
                                              setTimeStatus:
                                                  setTimePickerStatus,
                                              setStartTimeStatus:
                                                  setStartTimeStatus,
                                              setEndTimeStatus:
                                                  setEndTimeStatus,
                                              setOpacityOn: setOpacityOn,
                                              pickerStatus: datePickerVisible,
                                              amenitiesStatus:
                                                  amenitiesContainerVisible,
                                              participantStatus:
                                                  participantContainerVisible,
                                              timePickerStatus:
                                                  timePickerContainerVisible,
                                              dateController: _dateController,
                                              facilityController:
                                                  _facilityController,
                                              timeController: _timeController,
                                              participantController:
                                                  _participantController,
                                              meetingTypeSelected:
                                                  meetingTypeValue,
                                              meetingTypeName: meetingTypeName,
                                              meetingTypeStatus:
                                                  meetingTypeContainerVisible,
                                              setMeetingTypeStatus:
                                                  setMeetingTypeContainerStatus,
                                              dateKey: dateKey,
                                              timeKey: timeKey,
                                              amenitiesKey: amenitiesKey,
                                              meetingTypeKey: meetingTypeKey,
                                              participantKey: participantKey,
                                              datakey: dataKey,
                                              searchRoom: searchRoom,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // color: Colors.green,
                              child: Stack(
                                children: [
                                  Center(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 600,
                                        // maxHeight: MediaQuery.of(context).size.width,
                                        minWidth: 1000,
                                        // maxWidth: 1000,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 35,
                                        ),
                                        width: 1000,
                                        // decoration: BoxDecoration(
                                        //   border: Border.all(
                                        //     color: eerieBlack,
                                        //   ),
                                        // ),
                                        // height: double.infinity,
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  // color: Colors.amber,
                                                  width: 235,
                                                  // height: 1000,
                                                  // child: Text('Filter'),
                                                  child: Visibility(
                                                    visible: searchResult
                                                                .isEmpty &&
                                                            submitFilter.isEmpty
                                                        ? false
                                                        : true,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SortingContainer(
                                                          listSorting:
                                                              listSorting,
                                                          selectedSorting:
                                                              selectedSorting,
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        FilterContainer(
                                                          key: dataKey,
                                                          listFilter:
                                                              listFilter,
                                                          onChangeFilter:
                                                              onChangeFilter,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 35,
                                                ),
                                                Expanded(
                                                  child: isSearching
                                                      ? const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: eerieBlack,
                                                          ),
                                                        )
                                                      : searchResult.isEmpty
                                                          ? SizedBox()
                                                          : Container(
                                                              child: ListView
                                                                  .builder(
                                                                // physics: NeverScrollableScrollPhysics,
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    searchResult
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return ListRoomContainer(
                                                                    roomID: searchResult[
                                                                            index]
                                                                        [
                                                                        'RoomID'],
                                                                    roomName: searchResult[
                                                                            index]
                                                                        [
                                                                        'RoomName'],
                                                                    duration: searchResult[
                                                                            index]
                                                                        [
                                                                        'Duration'],
                                                                    amenities: searchResult[
                                                                            index]
                                                                        [
                                                                        'Amenities'],
                                                                    endTime: searchResult[
                                                                            index]
                                                                        [
                                                                        'EndTime'],
                                                                    startTime: searchResult[
                                                                            index]
                                                                        [
                                                                        'StartTime'],
                                                                    minCapacity:
                                                                        searchResult[index]['MinCapacity']
                                                                            .toString(),
                                                                    maxCapacity:
                                                                        searchResult[index]['MaxCapacity']
                                                                            .toString(),
                                                                    photo: searchResult[
                                                                            index]
                                                                        [
                                                                        'Photo'],
                                                                    date:
                                                                        selectedDateFormatted,
                                                                    selectedStartTime:
                                                                        startTime,
                                                                    selectedEndTime:
                                                                        endTime,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                ),

                                                // RegularButton(
                                                //   text: 'Start Time',
                                                //   disabled: false,
                                                //   onTap: () {
                                                //     setStartTime();
                                                //   },
                                                // ),
                                                // SizedBox(
                                                //   height: 10,
                                                // ),
                                                // RegularButton(
                                                //   text: 'End Time',
                                                //   disabled: false,
                                                //   onTap: () {
                                                //     setEndTime("09:45");
                                                //   },
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 35,
                                            ),
                                            WhiteBannerLandscape(
                                              title: 'Link your Google account',
                                              subtitle:
                                                  '& enjoy your benefits.',
                                              imagePath:
                                                  'assets/banner_pict_google.png',
                                            ),
                                            const SizedBox(
                                              height: 100,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  opacityOn
                                      ? Center(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: 1000,
                                              minWidth: 1366,
                                              // minWidth: 1000,
                                              // maxWidth: 1366,
                                            ),
                                            child: Container(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),

                            // Center(
                            //   child: Text(
                            //     datePicked,
                            //   ),
                            // ),
                            // Container(
                            //   height: 1000,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: meetingTypeContainerVisible,
                  child: Positioned(
                    top: 360,
                    left: 330,
                    child: MeetingTypeContainer(
                      meetingTypeStatus: meetingTypeContainerVisible,
                      setMeetingType: onMeetingTypeSelected,
                      selectedMeetingType: meetingTypeValue,
                      setMeetingTypeStatus: setMeetingTypeContainerStatus,
                      meetingType: roomType,
                    ),
                  ),
                ),
                Visibility(
                  visible: datePickerVisible,
                  child: Positioned(
                    // bottom: 0,
                    top: 485,
                    left: 183,
                    child: CustomDatePicker(
                      controller: datePickerControl,
                      changeDate: onDateChanged,
                      setPickerStatus: setDatePickerVisible,
                      currentDate: selectedDate,
                    ),
                  ),
                ),
                Visibility(
                  visible: amenitiesContainerVisible,
                  child: Positioned(
                    // bottom: 0,
                    top: 485,
                    right: 370,
                    child: AmenitiesContainer(
                      tvOnChange: (value) {
                        if (checkBoxTv) {
                          checkBoxTv = false;
                          facilitySelected
                              .removeWhere((element) => element == 'TV');
                        } else {
                          checkBoxTv = true;
                          facilitySelected.add('TV');
                        }
                        if (facilitySelected.isNotEmpty) {
                          if (facilitySelected.length > 1) {
                            _facilityController.text = "TV & Camera";
                          } else if (facilitySelected.length == 1) {
                            _facilityController.text =
                                facilitySelected[0].toString();
                          }
                        } else {
                          _facilityController.text = "None";
                        }
                        print(facilitySelected);
                        setState(() {});
                      },
                      cameraOnChange: (value) {
                        if (checkBoxCamera) {
                          checkBoxCamera = false;
                          facilitySelected
                              .removeWhere((element) => element == 'Camera');
                        } else {
                          checkBoxCamera = true;
                          facilitySelected.add('Camera');
                        }
                        if (facilitySelected.isNotEmpty) {
                          if (facilitySelected.length > 1) {
                            _facilityController.text = "TV & Camera";
                          } else if (facilitySelected.length == 1) {
                            _facilityController.text = facilitySelected[0];
                          }
                        } else {
                          _facilityController.text = "None";
                        }
                        print(facilitySelected);

                        setState(() {});
                      },
                      cameraValue: checkBoxCamera,
                      tvValue: checkBoxTv,
                    ),
                  ),
                ),
                Visibility(
                  visible: participantContainerVisible,
                  child: Positioned(
                    top: 485,
                    right: 575,
                    child: ParticipantContainer(
                      setParticipantStatus: setParticipantStatus,
                      onChangeParticipant: onParticipanSelected,
                    ),
                  ),
                ),
                Visibility(
                  visible: timePickerContainerVisible,
                  child: Positioned(
                    top: 485,
                    left: 408,
                    child: TimePickerContainer(
                      startTimeStatus: startTimeContainerVisible,
                      endTimeStatus: endTimeContainerVisible,
                      setTime: setTime,
                      startTime: startTime,
                      endTime: endTime,
                      setTimePickerStatus: setTimePickerStatus,
                      setListStartTime: setStartTimeList,
                      setEndTimeStatus: setEndTimeStatus,
                      setListEndTime: setEndTimeList,
                      setStartTimeStatus: setStartTimeStatus,
                      initialEndTime: initialEndTime,
                      selectedDate: selectedDate,
                    ),
                  ),
                ),
                Visibility(
                  visible: startTimeContainerVisible,
                  child: Positioned(
                    top: 595,
                    left: 425,
                    child: StartTimeContainer(
                      items: startTimeList,
                      setStartTime: setStartTime,
                      setStartTimeStatus: setStartTimeStatus,
                      setInitialEndTime: setInitialEndTime,
                    ),
                  ),
                ),
                Visibility(
                  visible: endTimeContainerVisible,
                  child: Positioned(
                    top: 595,
                    left: 545,
                    child: EndTimeContainer(
                      items: endTimeList,
                      setEndTime: setEndTime,
                      setEndTimeStatus: setEndTimeStatus,
                      startTime: startTime,
                      setTime: setTime,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    // return Consumer<MainModel>(builder: (context, model, child) {
    //   return Scaffold(
    //     body: Center(
    //       child: ConstrainedBox(
    //         constraints: pageConstraints,
    //         child: Align(
    //           alignment: Alignment.topCenter,
    //           child: Stack(
    //             children: [
    //               Column(
    //                 children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                       boxShadow: [
    //                         // model.navbarShadow
    //                         BoxShadow(
    //                           blurRadius: !model.shadowActive ? 0 : 40,
    //                           offset: !model.shadowActive
    //                               ? Offset(0, 0)
    //                               : Offset(0, 0),
    //                           color: Color.fromRGBO(29, 29, 29, 0.1),
    //                         )
    //                       ],
    //                     ),
    //                     child: NavigationBarWeb(
    //                       index: 1,
    //                       popUpProfile: popUpProfile,
    //                     ),
    //                   ),
    //                   // Container(
    //                   //   color: Color.fromRGBO(29, 29, 29, 0.1),
    //                   //   height: 1,
    //                   // ),
    //                   Expanded(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 5),
    //                       child: CustomScrollView(
    //                         controller: _scrollController,
    //                         slivers: [
    //                           SliverList(
    //                             delegate: SliverChildListDelegate(
    //                               [
    //                                 SizedBox(
    //                                   height: 20,
    //                                 ),
    //                                 Form(
    //                                   key: _formKey,
    //                                   child: searchRoom(),
    //                                 ),
    //                                 SizedBox(
    //                                   height: 20,
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           // const SliverFillRemaining(
    //                           //   hasScrollBody: false,
    //                           //   child: Align(
    //                           //     alignment: Alignment.bottomCenter,
    //                           //     child: FooterWeb(),
    //                           //   ),
    //                           // )
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Positioned(
    //                 right: 20,
    //                 top: 65,
    //                 child: Visibility(
    //                   visible: profileVisible,
    //                   child: Container(
    //                     // color: Colors.amber,
    //                     child: PopUpProfile(
    //                       name: 'Luthfi',
    //                       email: 'luthfiizhar@gmail.com',
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // });
  }

  // Widget searchRoom() {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(10),
  //         width: 450,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(7),
  //           border: Border.all(color: eerieBlack),
  //         ),
  //         child: Column(
  //           // mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   // flex: 6,
  //                   child: bookingDateInput(),
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 Expanded(
  //                   // flex: 6,
  //                   child: checkBoxAmenities(),
  //                 )
  //               ],
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Expanded(
  //                   child: bookingTimeInput(),
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 Expanded(
  //                   child: participantInput(),
  //                 )
  //               ],
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: RegularButton(
  //                 text: 'Search',
  //                 onTap: () {
  //                   if (_formKey.currentState!.validate()) {}
  //                 },
  //                 disabled: true,
  //                 padding: ButtonSize().longSize(),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: RegularButton(
  //                 text: 'Dialog test',
  //                 onTap: () {
  //                   // if (_formKey.currentState!.validate()) {}
  //                   // _showProfileLayer();
  //                 },
  //                 disabled: false,
  //                 padding: ButtonSize().longSize(),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: WhiteRegularButton(
  //                 text: 'White Version',
  //                 onTap: () {
  //                   if (_formKey.currentState!.validate()) {}
  //                 },
  //                 disabled: true,
  //                 padding: ButtonSize().longSize(),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: TransparentButtonBlack(
  //                 text: 'Transparent Black Version',
  //                 onTap: () {
  //                   if (_formKey.currentState!.validate()) {}
  //                 },
  //                 disabled: true,
  //                 padding: ButtonSize().longSize(),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: TransparentButtonBlack(
  //                 padding: ButtonSize().longSize(),
  //                 text: 'Black pop up small',
  //                 onTap: () {
  //                   showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) {
  //                       return const ConfirmDialogBlack(
  //                         title: 'Confirmation',
  //                         contentText: 'Are you sure to change visit time?',
  //                       );
  //                     },
  //                   );
  //                 },
  //                 disabled: false,
  //                 // backgroundColor: cardBg,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: TransparentButtonBlack(
  //                 padding: ButtonSize().longSize(),
  //                 text: 'white pop up small',
  //                 onTap: () {
  //                   showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) {
  //                       return const ConfirmDialogWhite(
  //                         title: 'Confirmation',
  //                         contentText: 'Are you sure to change visit time?',
  //                       );
  //                     },
  //                   ).then((value) {});
  //                 },
  //                 disabled: false,
  //                 // backgroundColor: cardBg,
  //               ),
  //             ),
  //             SizedBox(
  //               height: 20,
  //             ),
  //             SizedBox(
  //               // height: 40,
  //               // width: 250,
  //               child: TransparentButtonBlack(
  //                 padding: ButtonSize().longSize(),
  //                 text: 'Alert pop Up small',
  //                 onTap: () {
  //                   showDialog(
  //                     context: context,
  //                     builder: (BuildContext context) {
  //                       return const AlertDialogBlack(
  //                         title: 'Success',
  //                         contentText: 'Your changes has been saved.',
  //                       );
  //                     },
  //                   ).then((value) {});
  //                 },
  //                 disabled: false,
  //                 // backgroundColor: cardBg,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 20,
  //       ),
  //       Container(
  //         padding: EdgeInsets.all(10),
  //         // height: 300,
  //         width: 500,
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(7),
  //           border: Border.all(color: eerieBlack),
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(
  //               width: 250,
  //               child: BlackInputField(
  //                 enabled: true,
  //                 controller: _testInputField!,
  //                 hintText: 'Please input here',
  //                 focusNode: _testInputNode,
  //                 obsecureText: false,
  //                 suffixIcon: _testInputNode.hasFocus
  //                     ? IconButton(
  //                         onPressed: () {
  //                           _testInputField!.text = "";
  //                         },
  //                         icon: const Icon(
  //                           Icons.close,
  //                           color: eerieBlack,
  //                         ),
  //                       )
  //                     : SizedBox(),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 50,
  //             ),
  //             Container(
  //               padding: EdgeInsets.zero,
  //               // decoration: BoxDecoration(
  //               //   borderRadius: BorderRadius.circular(5),
  //               //   boxShadow: _testInputNode.hasFocus
  //               //       ? const [
  //               //           BoxShadow(
  //               //             blurRadius: 40,
  //               //             offset: Offset(0, 10),
  //               //             // blurStyle: BlurStyle.outer,
  //               //             color: Color.fromRGBO(29, 29, 29, 0.2),
  //               //           )
  //               //         ]
  //               //       : null,
  //               // ),
  //               child: SizedBox(
  //                 width: 250,
  //                 child: BlackInputField(
  //                   enabled: true,
  //                   controller: _testInputField!,
  //                   hintText: 'Password',
  //                   focusNode: _testInputNode,
  //                   obsecureText: isPassword,
  //                   suffixIcon: _testInputNode.hasFocus
  //                       ? IconButton(
  //                           onPressed: () {
  //                             if (isPassword) {
  //                               isPassword = false;
  //                             } else {
  //                               isPassword = true;
  //                             }
  //                             setState(() {});
  //                           },
  //                           icon: isPassword
  //                               ? Icon(
  //                                   FontAwesomeIcons.eyeSlash,
  //                                   color: eerieBlack,
  //                                   size: 18,
  //                                 )
  //                               : Icon(
  //                                   FontAwesomeIcons.eye,
  //                                   color: eerieBlack,
  //                                   size: 18,
  //                                 ),
  //                         )
  //                       : SizedBox(),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 50,
  //             ),
  //             Container(
  //               padding: EdgeInsets.zero,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(5),
  //                 // boxShadow: _testInputNode.hasFocus
  //                 //     ? const [
  //                 //         BoxShadow(
  //                 //           blurRadius: 40,
  //                 //           offset: Offset(0, 10),
  //                 //           // blurStyle: BlurStyle.outer,
  //                 //           color: Color.fromRGBO(29, 29, 29, 0.2),
  //                 //         )
  //                 //       ]
  //                 //     : null,
  //               ),
  //               child: SizedBox(
  //                 width: 250,
  //                 child: BlackInputField(
  //                   enabled: false,
  //                   controller: _testInputFieldDisabled!,
  //                   hintText: 'Please input here',
  //                   focusNode: _testInput2Node,
  //                   obsecureText: false,
  //                   suffixIcon: SizedBox(),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 50,
  //             ),
  //             Container(
  //               padding: EdgeInsets.zero,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(5),
  //                 boxShadow: _dropdownBlackNode.hasFocus
  //                     ? const [
  //                         BoxShadow(
  //                           blurRadius: 40,
  //                           offset: Offset(0, 10),
  //                           // blurStyle: BlurStyle.outer,
  //                           color: Color.fromRGBO(29, 29, 29, 0.2),
  //                         )
  //                       ]
  //                     : null,
  //               ),
  //               child: SizedBox(
  //                 width: 250,
  //                 child: BlackDropdown(
  //                   // value: dropdownBlackValue,
  //                   focusNode: _dropdownBlackNode,
  //                   items: addDividerItem(items),
  //                   // items: items.map((e) {
  //                   //   return DropdownMenuItem(
  //                   //     child: Text(e),
  //                   //     value: e,
  //                   //   );
  //                   // }).toList(),
  //                   customHeights: _getCustomItemsHeights(items),
  //                   enabled: true,
  //                   hintText: 'Choose',
  //                   suffixIcon: Icon(
  //                     Icons.keyboard_arrow_down_outlined,
  //                     color: eerieBlack,
  //                   ),
  //                   onChanged: (value) {
  //                     dropdownBlackValue = value;
  //                     _dropdownBlackNode.unfocus();
  //                     setState(() {});
  //                   },
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 50,
  //             ),
  //             Container(
  //               width: 250,
  //               padding: EdgeInsets.zero,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(5),
  //                 boxShadow: _blackDateNode.hasFocus
  //                     ? const [
  //                         BoxShadow(
  //                           blurRadius: 40,
  //                           offset: Offset(0, 10),
  //                           // blurStyle: BlurStyle.outer,
  //                           color: Color.fromRGBO(29, 29, 29, 0.2),
  //                         )
  //                       ]
  //                     : null,
  //               ),
  //               child: BlackInputField(
  //                 controller: _bookDate!,
  //                 focusNode: _blackDateNode,
  //                 obsecureText: false,
  //                 enabled: true,
  //                 onTap: () {
  //                   _selectStartDate();
  //                 },
  //                 hintText: 'Select date',
  //                 suffixIcon: const Icon(
  //                   FontAwesomeIcons.calendarDays,
  //                   size: 16,
  //                   color: eerieBlack,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 50,
  //             ),
  //             BlackCheckBox(
  //               selectedValue: checkBoxAmenTv,
  //               onChanged: (value) {
  //                 if (checkBoxAmenTv) {
  //                   checkBoxAmenTv = false;
  //                   selectedAmen!.removeWhere((element) => element == 'tv');
  //                 } else {
  //                   checkBoxAmenTv = true;
  //                   selectedAmen!.add('tv');
  //                 }
  //                 setState(() {});
  //               },
  //               label: 'Enabled',
  //               filled: true,
  //             ),
  //           ],
  //         ),
  //       ),
  //       SizedBox(
  //         height: 20,
  //       ),
  //       Container(
  //         padding: EdgeInsets.all(8),
  //         // height: 300,
  //         width: 500,
  //         color: Colors.black,
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SizedBox(
  //                 width: 250,
  //                 child: WhiteCheckbox(
  //                   selectedValue: checkBoxAmenTv,
  //                   onChanged: (value) {
  //                     if (checkBoxAmenTv) {
  //                       checkBoxAmenTv = false;
  //                       selectedAmen!.removeWhere((element) => element == 'tv');
  //                     } else {
  //                       checkBoxAmenTv = true;
  //                       selectedAmen!.add('tv');
  //                     }
  //                     setState(() {});
  //                   },
  //                   label: 'Enabled',
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               SizedBox(
  //                 width: 250,
  //                 child: WhiteInputField(
  //                   controller: _testInputWhiteField!,
  //                   enabled: false,
  //                   focusNode: _testInputWhiteNode,
  //                   hintText: 'Placeholder',
  //                   obsecureText: false,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 10,
  //               ),
  //               SizedBox(
  //                 width: 250,
  //                 child: Container(
  //                   padding: EdgeInsets.zero,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     boxShadow: _testInputWhiteNode.hasFocus
  //                         ? [
  //                             BoxShadow(
  //                               // spreadRadius: 40,
  //                               blurRadius: 40,
  //                               offset: Offset(0, 10),
  //                               // blurStyle: BlurStyle.outer,
  //                               color: Color.fromRGBO(243, 243, 243, 0.2),
  //                             )
  //                           ]
  //                         : null,
  //                   ),
  //                   child: WhiteInputField(
  //                     enabled: true,
  //                     focusNode: _testInputWhiteNode,
  //                     controller: _testInputWhiteField!,
  //                     hintText: 'Please input here',
  //                     obsecureText: false,
  //                     suffixIcon: _testInputWhiteNode.hasFocus
  //                         ? IconButton(
  //                             onPressed: () {
  //                               _testInputWhiteField!.text = "";
  //                             },
  //                             icon: Icon(
  //                               Icons.close,
  //                               color: culturedWhite,
  //                               size: 18,
  //                             ),
  //                           )
  //                         : SizedBox(),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 60,
  //               ),
  //               SizedBox(
  //                 width: 250,
  //                 child: Container(
  //                   padding: EdgeInsets.zero,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(5),
  //                     boxShadow: _testInputWhiteNode.hasFocus
  //                         ? const [
  //                             BoxShadow(
  //                               blurRadius: 40,
  //                               offset: Offset(0, 10),
  //                               color: Color.fromRGBO(243, 243, 243, 0.2),
  //                             )
  //                           ]
  //                         : null,
  //                   ),
  //                   child: WhiteInputField(
  //                     enabled: true,
  //                     focusNode: _testInputWhiteNode,
  //                     controller: _testInputWhiteField!,
  //                     hintText: 'Password',
  //                     obsecureText: isPassword,
  //                     suffixIcon: _testInputWhiteNode.hasFocus
  //                         ? IconButton(
  //                             onPressed: () {
  //                               if (isPassword) {
  //                                 isPassword = false;
  //                               } else {
  //                                 isPassword = true;
  //                               }
  //                               setState(() {});
  //                             },
  //                             icon: isPassword
  //                                 ? Icon(
  //                                     FontAwesomeIcons.eye,
  //                                     color: culturedWhite,
  //                                     size: 18,
  //                                   )
  //                                 : Icon(
  //                                     FontAwesomeIcons.eyeSlash,
  //                                     color: culturedWhite,
  //                                     size: 18,
  //                                   ),
  //                           )
  //                         : SizedBox(),
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 40,
  //               ),
  //               Container(
  //                 padding: EdgeInsets.zero,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(5),
  //                   boxShadow: _dropdownWhiteNode.hasFocus
  //                       ? const [
  //                           BoxShadow(
  //                             blurRadius: 40,
  //                             offset: Offset(0, 10),
  //                             // blurStyle: BlurStyle.outer,
  //                             color: Color.fromRGBO(243, 243, 243, 0.2),
  //                           )
  //                         ]
  //                       : null,
  //                 ),
  //                 child: SizedBox(
  //                   width: 250,
  //                   child: WhiteDropdown(
  //                     focusNode: _dropdownWhiteNode,
  //                     items: addDividerItemWhite(items),
  //                     customHeights: _getCustomItemsHeights(items),
  //                     enabled: true,
  //                     hintText: 'Choose',
  //                     suffixIcon: const Icon(
  //                       Icons.keyboard_arrow_down_outlined,
  //                       color: culturedWhite,
  //                     ),
  //                     onChanged: (value) {
  //                       dropdownBlackValue = value;
  //                       _dropdownWhiteNode.unfocus();
  //                       setState(() {});
  //                     },
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 50,
  //               ),
  //               SizedBox(
  //                 // width: 250,
  //                 child: WhiteRegularButton(
  //                   padding: ButtonSize().longSize(),
  //                   text: 'Black pop up big',
  //                   onTap: () {
  //                     showDialog(
  //                       context: context,
  //                       builder: (BuildContext context) {
  //                         return const ConfirmDialogBlack(
  //                           title: 'Confirmation',
  //                           contentText:
  //                               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed semper ligula quam, id pretium ligula euismod non',
  //                         );
  //                       },
  //                     );
  //                   },
  //                   disabled: false,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               SizedBox(
  //                 // width: 250,
  //                 child: WhiteRegularButton(
  //                   padding: ButtonSize().longSize(),
  //                   text: 'White pop up big',
  //                   onTap: () {
  //                     showDialog(
  //                       context: context,
  //                       builder: (BuildContext context) {
  //                         return const ConfirmDialogWhite(
  //                           title: 'Confirmation',
  //                           contentText:
  //                               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed semper ligula quam, id pretium ligula euismod non',
  //                         );
  //                       },
  //                     );
  //                   },
  //                   disabled: false,
  //                 ),
  //               ),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               SizedBox(
  //                 child: TransparentButtonWhite(
  //                   padding: ButtonSize().mediumSize(),
  //                   text: 'Transparent White Version',
  //                   onTap: () {},
  //                   disabled: true,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //         height: 20,
  //       ),
  //       Container(
  //         child: Align(
  //           alignment: Alignment.center,
  //           child: Column(
  //             // crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text('Available Rooms'),
  //               SizedBox(
  //                 height: 20,
  //               ),
  //               ListView.builder(
  //                 scrollDirection: Axis.vertical,
  //                 shrinkWrap: true,
  //                 itemCount: roomList.length,
  //                 itemBuilder: (context, index) {
  //                   // var list = roomList;
  //                   return LayoutBuilder(builder: (context, constraints) {
  //                     return Align(
  //                       alignment: Alignment.center,
  //                       child: Container(
  //                         width: 400,
  //                         // height: 100,
  //                         decoration: BoxDecoration(
  //                           color: cardBg,
  //                           borderRadius: BorderRadius.circular(7),
  //                           border: Border.all(color: eerieBlack),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             Container(
  //                               width: 175,
  //                               // height: double.infinity,
  //                               // decoration: BoxDecoration(),
  //                               // clipBehavior: Clip.hardEdge,
  //                               child: Image.asset(
  //                                 'assets/persistance_1.png',
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               // child: SizedBox(),
  //                             ),
  //                             SizedBox(
  //                               width: 5,
  //                             ),
  //                             Expanded(
  //                               child: Container(
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Text(
  //                                       roomList[index].roomName!,
  //                                       style: cardHeaderText,
  //                                     ),
  //                                     SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     Row(
  //                                       crossAxisAlignment:
  //                                           CrossAxisAlignment.center,
  //                                       // mainAxisAlignment: MainAxisAlignment.start,
  //                                       children: [
  //                                         Expanded(
  //                                           child: Column(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.center,
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text.rich(
  //                                                 TextSpan(
  //                                                   children: [
  //                                                     const WidgetSpan(
  //                                                       child: Icon(
  //                                                         Icons
  //                                                             .watch_later_outlined,
  //                                                         size: 16,
  //                                                       ),
  //                                                     ),
  //                                                     const WidgetSpan(
  //                                                       child: SizedBox(
  //                                                         width: 1,
  //                                                       ),
  //                                                     ),
  //                                                     TextSpan(
  //                                                       text: roomList[index]
  //                                                               .availability!
  //                                                           ? "Available"
  //                                                           : "Not Available",
  //                                                       style: cardContentText
  //                                                           .copyWith(
  //                                                         color: roomList[index]
  //                                                                 .availability!
  //                                                             ? Colors.green
  //                                                             : orangeRed,
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                               SizedBox(
  //                                                 height: 1,
  //                                               ),
  //                                               Text.rich(
  //                                                 TextSpan(
  //                                                   children: [
  //                                                     const WidgetSpan(
  //                                                       child: Icon(
  //                                                         Icons.person,
  //                                                         size: 16,
  //                                                       ),
  //                                                     ),
  //                                                     const WidgetSpan(
  //                                                       child: SizedBox(
  //                                                         width: 1,
  //                                                       ),
  //                                                     ),
  //                                                     TextSpan(
  //                                                       text:
  //                                                           '${roomList[index].capacity} Person',
  //                                                       style: cardContentText,
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                               SizedBox(
  //                                                 height: 1,
  //                                               ),
  //                                               Text.rich(
  //                                                 TextSpan(
  //                                                   children: [
  //                                                     const WidgetSpan(
  //                                                       child: Icon(
  //                                                         Icons
  //                                                             .corporate_fare_sharp,
  //                                                         size: 16,
  //                                                       ),
  //                                                     ),
  //                                                     const WidgetSpan(
  //                                                       child: SizedBox(
  //                                                         width: 1,
  //                                                       ),
  //                                                     ),
  //                                                     TextSpan(
  //                                                       text:
  //                                                           '${roomList[index].areaId} Floor',
  //                                                       style: cardContentText,
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         SizedBox(
  //                                           width: 5,
  //                                         ),
  //                                         Expanded(
  //                                           child: Column(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment.center,
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.start,
  //                                             children: [
  //                                               Text(
  //                                                 'Amenities :',
  //                                                 style: cardContentText,
  //                                               ),
  //                                               const SizedBox(
  //                                                 height: 1,
  //                                               ),
  //                                               Text.rich(
  //                                                 TextSpan(
  //                                                   children: [
  //                                                     const WidgetSpan(
  //                                                       child: Icon(
  //                                                         Icons.tv_sharp,
  //                                                         size: 16,
  //                                                       ),
  //                                                     ),
  //                                                     const WidgetSpan(
  //                                                       child: SizedBox(
  //                                                         width: 1,
  //                                                       ),
  //                                                     ),
  //                                                     TextSpan(
  //                                                       text: 'TV',
  //                                                       style: cardContentText,
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                               const SizedBox(
  //                                                 height: 1,
  //                                               ),
  //                                               Text.rich(
  //                                                 TextSpan(
  //                                                   children: [
  //                                                     const WidgetSpan(
  //                                                       child: Icon(
  //                                                         Icons.videocam_sharp,
  //                                                         size: 16,
  //                                                       ),
  //                                                     ),
  //                                                     const WidgetSpan(
  //                                                       child: SizedBox(
  //                                                         width: 1,
  //                                                       ),
  //                                                     ),
  //                                                     TextSpan(
  //                                                       text: 'Camera',
  //                                                       style: cardContentText,
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                     RegularButton(
  //                                       text: 'Book',
  //                                       // fontSize: 12,
  //                                       onTap: () {},
  //                                       disabled: false,
  //                                       padding: ButtonSize().smallSize(),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 10,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   });
  //                 },
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget bookingTimeInput() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('Time Start'),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     _selectTime(_startTime!);
  //                   },
  //                   child: InputSearch(
  //                     controller: _startTime,
  //                     enabled: false,
  //                     suffix: Icon(
  //                       Icons.keyboard_arrow_down_sharp,
  //                       color: scaffoldBg,
  //                       size: 20,
  //                     ),
  //                     validator: (value) {
  //                       if (value == "") {
  //                         return "Required";
  //                       }
  //                       if (_endTime!.text == "") {
  //                         return "";
  //                       } else {
  //                         return null;
  //                       }
  //                     },
  //                     onTap: () {
  //                       _selectTime(_startTime!);
  //                     },
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('Time End'),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 GestureDetector(
  //                   onTap: (() {
  //                     _selectTime(_endTime!);
  //                   }),
  //                   child: InputSearch(
  //                     controller: _endTime,
  //                     enabled: false,
  //                     suffix: Icon(
  //                       Icons.keyboard_arrow_down_sharp,
  //                       color: scaffoldBg,
  //                       size: 20,
  //                     ),
  //                     validator: (value) {
  //                       if (value == "") {
  //                         return "Required";
  //                       }
  //                       if (_startTime!.text == "") {
  //                         return "";
  //                       } else {
  //                         return null;
  //                       }
  //                     },
  //                     onTap: () {
  //                       _selectTime(_endTime!);
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       )
  //     ],
  //   );
  // }

  // Widget participantInput() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Participant (total person)'),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Row(
  //         children: [
  //           SizedBox(
  //             width: 130,
  //             child: InputSearch(
  //               controller: _participant,
  //               enabled: false,
  //               suffix: Icon(
  //                 Icons.people_sharp,
  //                 size: 20,
  //                 color: scaffoldBg,
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 5,
  //           ),
  //           SizedBox(
  //             height: 40,
  //             child: Column(children: [
  //               InkWell(
  //                 onTap: () {
  //                   participant = participant! + 1;
  //                   _participant!.text = participant.toString();
  //                   setState(() {});
  //                 },
  //                 child: Icon(
  //                   Icons.keyboard_arrow_up_sharp,
  //                   size: 20,
  //                 ),
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   participant = participant! - 1;
  //                   if (participant! <= 0) {
  //                     participant = 1;
  //                   }
  //                   _participant!.text = participant.toString();
  //                   setState(() {});
  //                 },
  //                 child: Icon(
  //                   Icons.keyboard_arrow_down_sharp,
  //                   size: 20,
  //                 ),
  //               )
  //             ]),
  //           )
  //           // Expanded(
  //           //   child: SizedBox(
  //           //     height: 40,
  //           //     child: ElevatedButton(
  //           //       child: Icon(Icons.search_sharp),
  //           //       onPressed: () {
  //           //         if (_formKey.currentState!.validate()) {}
  //           //       },
  //           //       style: ButtonStyle(
  //           //         foregroundColor:
  //           //             MaterialStateProperty.resolveWith(getColor),
  //           //         backgroundColor:
  //           //             MaterialStateProperty.resolveWith<Color>((states) {
  //           //           return spanishGray;
  //           //         }),
  //           //         shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
  //           //             (Set<MaterialState> states) {
  //           //           if (states.contains(MaterialState.pressed))
  //           //             return RoundedRectangleBorder(
  //           //                 borderRadius: BorderRadius.circular(10),
  //           //                 side: BorderSide(color: eerieBlack, width: 5));
  //           //           return RoundedRectangleBorder(
  //           //               borderRadius: BorderRadius.circular(10));
  //           //         }),
  //           //         overlayColor: MaterialStateProperty.resolveWith<Color?>(
  //           //           (Set<MaterialState> states) {
  //           //             if (states.contains(MaterialState.pressed))
  //           //               return Colors.white; //<-- SEE HERE
  //           //             return null; // Defer to the widget's default.
  //           //           },
  //           //         ),
  //           //       ),
  //           //     ),
  //           //   ),
  //           // ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget bookingDateInput() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Booking For'),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       InputSearch(
  //         controller: _bookDate,
  //         enabled: true,
  //         prefix: Icon(
  //           Icons.calendar_month_outlined,
  //           color: scaffoldBg,
  //           size: 20,
  //         ),
  //         onTap: () {
  //           _selectStartDate();
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Future _selectTime(TextEditingController controller) async {
  //   final TimeOfDay? picked_s = await showTimePicker(
  //       context: context,
  //       initialTime: selectedTime,
  //       initialEntryMode: TimePickerEntryMode.inputOnly,
  //       builder: (context, child) {
  //         return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: const ColorScheme.light(
  //               primary: eerieBlack,
  //               onPrimary: silver,
  //               onSurface: eerieBlack,
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 foregroundColor: eerieBlack,
  //               ),
  //             ),
  //           ),
  //           child: MediaQuery(
  //             data:
  //                 MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
  //             child: child!,
  //           ),
  //         );
  //       });

  //   if (picked_s != null) {
  //     final hour = picked_s.hour.toString().padLeft(2, '0');
  //     final minute = picked_s.minute.toString().padLeft(2, '0');
  //     setState(() {
  //       selectedTime = picked_s;
  //       controller.text = "$hour:$minute";
  //     });
  //   }
  // }

  // Future _selectStartDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: eerieBlack,
  //             onPrimary: silver,
  //             onSurface: eerieBlack,
  //           ),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(
  //               foregroundColor: eerieBlack,
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //   String formattedDate = DateFormat('d MMMM yyyy').format(picked!);
  //   if (picked != null)
  //     setState(() {
  //       _bookDate!.text = formattedDate;
  //     });
  // }

  // Widget checkBoxAmenities() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('Amenities'),
  //       SizedBox(
  //         height: 10,
  //       ),
  //       Container(
  //         child: Column(
  //           // crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             CheckBoxAmenities(
  //               selectedValue: checkBoxAmenTv,
  //               onChanged: (value) {
  //                 print('check');
  //                 if (checkBoxAmenTv) {
  //                   checkBoxAmenTv = false;
  //                   selectedAmen!.removeWhere((element) => element == 'tv');
  //                 } else {
  //                   checkBoxAmenTv = true;
  //                   selectedAmen!.add('tv');
  //                 }
  //                 setState(() {});
  //                 print(selectedAmen);
  //               },
  //               label: 'Enabled',
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             CheckBoxAmenities(
  //               selectedValue: checkBoxAmenCam,
  //               onChanged: (value) {
  //                 if (checkBoxAmenCam) {
  //                   checkBoxAmenCam = false;
  //                   selectedAmen!.removeWhere((element) => element == 'cam');
  //                 } else {
  //                   checkBoxAmenCam = true;
  //                   selectedAmen!.add('cam');
  //                 }
  //                 setState(() {});
  //                 print(selectedAmen);
  //               },
  //               label: 'Camera',
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }
}
