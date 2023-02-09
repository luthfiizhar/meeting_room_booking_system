import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/constant/custom_scroll_behavior.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/booking_detail_picture.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/confirm_book_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/food_item.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/pick_end_time_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/pick_start_time_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/room_facility_item.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_amenities_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_food_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_layout_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/suggestion_email_container.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/no_border_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class BookingRoomPage extends StatefulWidget {
  BookingRoomPage({
    super.key,
    this.roomId = "",
    this.date = "",
    this.startTime = "",
    this.endTime = "",
    this.roomType = "MeetingRoom",
    this.facilities = "[]",
    this.participant = "1",
    this.index = 2,
    this.isEdit = "false",
    this.foodAmenities = "[]",
    this.summary = "",
    this.description = "",
    this.floor = "",
    this.recurrent,
    this.invitedGuest,
    this.edit,
    this.queryParameter,
  });

  String? roomId;
  String? date;
  String? startTime;
  String? endTime;
  String? roomType;
  String? facilities;
  String? participant;
  int? index;
  String isEdit;
  dynamic foodAmenities;
  String summary;
  String description;
  String floor;
  dynamic recurrent;
  List? invitedGuest;
  dynamic edit;
  dynamic queryParameter;

  @override
  State<BookingRoomPage> createState() => _BookingRoomPageState();
}

class _BookingRoomPageState extends State<BookingRoomPage> {
  ReqAPI apiReq = ReqAPI();
  TextEditingController _eventName = TextEditingController();
  TextEditingController _eventDesc = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _startTime = TextEditingController();
  TextEditingController _endTime = TextEditingController();
  TextEditingController _totalParticipant = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _repeatEnd = TextEditingController();
  TextEditingController _repeatInterval = TextEditingController();
  TextEditingController _additionalNote = TextEditingController();
  TextEditingController _repeatOnMonthly = TextEditingController();

  FocusNode eventNameNode = FocusNode();
  FocusNode eventDescNode = FocusNode();
  FocusNode dateNode = FocusNode();
  FocusNode startTimeNode = FocusNode();
  FocusNode endTimeNode = FocusNode();
  FocusNode totalParticipantNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode repeatNode = FocusNode();
  FocusNode repeatIntervalNode = FocusNode();
  FocusNode repeatEndNode = FocusNode();
  FocusNode repeatOnNode = FocusNode();
  FocusNode additionalNoteNode = FocusNode();
  OverlayEntry? _overlayEntry;

  String eventName = "";
  String eventDesc = "";
  String date = "";
  String startTime = "";
  String endTime = "";
  String totalParticipant = "";
  double participantValue = 1;
  String additionalNote = "";
  String repeatInterval = "0";
  String repeatValue = 'NONE';
  List invitedGuest = [];
  String monthAbsolute = "";

  String roomName = "";
  String floor = "";

  String filterContact = "";
  String messageEmptyContact = "";
  List contactList = [];
  List filterContactList = [];
  bool isContactEmpty = true;

  bool emptyLayout = true;
  String layoutId = "";
  String layoutName = "";
  String layoutImageUrl = "";
  String layoutBase64 = "";
  Uint8List? layoutImageBytes = Uint8List(8);

  final formKey = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  DateTime? selectedDate = DateTime.now();
  DateTime? selectedRepeatDate = DateTime.now();

  DateRangePickerController datePickerControl = DateRangePickerController();
  DateRangePickerController repeatDatePickerControl =
      DateRangePickerController();

  List? repeatItems = [
    {'value': 'NONE', 'displayName': 'None'},
    {'value': 'DAILY', 'displayName': 'Daily'},
    {'value': 'WEEKLY', 'displayName': 'Weekly'},
    {'value': 'MONTHLY', 'displayName': 'Monthly'}
  ];
  String repeatEnd = "";

  List<RadioModel>? listEventType = [];
  String? selectedEventType = "Internal";
  String? roomType = "MeetingRoom";

  double participantMin = 0;
  double participantMax = 5;

  List<Amenities> listAmenities = [];
  List<FoodAmenities> listFoods = [];
  List roomDetail = [];
  List resultPicture = [];
  List<Amenities> resultAmenities = [];
  List resultFoodAmenities = [];

  bool timeContainerActive = false;
  bool datePickerVisible = false;
  bool datePickerRepeatVisible = false;
  bool layoutSectionVisible = false;
  bool repeatSectionVisible = true;
  bool layoutFromupload = false;
  bool emailSuggestionVisible = false;
  bool isAdditionalNotesVisible = true;
  late bool isEdit;

  final LayerLink _layerLink = LayerLink();

  bool isPictEmpty = true;

  DateTime dateRefresh = DateTime.now();
  String areaRefresh = "";
  List dataRoomRefresh = [];
  List eventRoomRefresh = [];

  List weeklyOptions = [
    {'value': '0', 'name': 'Sunday', 'initial': 'S', 'isSelected': false},
    {'value': '1', 'name': 'Monday', 'initial': 'M', 'isSelected': false},
    {'value': '2', 'name': 'Tuesday', 'initial': 'T', 'isSelected': false},
    {'value': '3', 'name': 'Wednesday', 'initial': 'W', 'isSelected': false},
    {'value': '4', 'name': 'Thursday', 'initial': 'T', 'isSelected': false},
    {'value': '5', 'name': 'Friday', 'initial': 'F', 'isSelected': false},
    {'value': '6', 'name': 'Saturday', 'initial': 'S', 'isSelected': false},
  ];

  GlobalKey emailKey = GlobalKey();

  bool pictureLoading = true;
  bool isSubmitLoading = false;

  // Future getBookingListRoom(String area, String date, MainModel model) async {
  //   model.events.appointments!.clear();
  //   var box = await Hive.openBox('userLogin');
  //   var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

  //   var url = Uri.https(
  //       apiUrlGlobal, '/MRBS_Backend/public/api/room/booking/list/$area');
  //   Map<String, String> requestHeader = {
  //     'Authorization': 'Bearer $jwt',
  //     // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
  //     'Content-Type': 'application/json',
  //   };
  //   var bodySend = """
  // {
  //   "StartDate" : "$date",
  //   "EndDate" : "$date"
  // }
  // """;
  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: requestHeader,
  //       body: bodySend,
  //     );

  //     var data = json.decode(response.body);
  //     // print(data);

  //     // List dataRoom = data['Data'];
  //     // int length = dataRoom.length;
  //     // print(dataRoom);
  //     // roomEvents.clear();
  //     // for (var i = 0; i < length; i++) {
  //     //   List eventRoom = dataRoom[i]['Bookings'];
  //     //   if (eventRoom.isEmpty) {
  //     //     break;
  //     //   }
  //     //   for (var j = 0; j < eventRoom.length; j++) {
  //     //     roomEvents.add(
  //     //       Appointment(
  //     //         // subject: ,
  //     //         resourceIds: [dataRoom[i]['RoomID']],
  //     //         startTime: DateTime.parse(eventRoom[j]['StartDateTime']),
  //     //         endTime: DateTime.parse(eventRoom[j]['EndDateTime']),
  //     //       ),
  //     //     );
  //     //   }
  //     // }
  //     return data;
  //   } on Error catch (e) {
  //     return e;
  //   }
  // }

  Future assignDataToCalendar(dynamic data) async {
    // _events!.appointments!.clear();
    Provider.of<MainModel>(context, listen: false).events.appointments!.clear();
    List dataRoom = data;
    int length = dataRoom.length;
    // print(dataRoom);
    for (var i = 0; i < length; i++) {
      List eventRoom = dataRoom[i]['Bookings'];

      for (var j = 0; j < eventRoom.length; j++) {
        // _events!.appointments!.add(
        //   RoomEvent(
        //     // subject: ,
        //     resourceIds: [dataRoom[i]['RoomID']],
        //     from: DateTime.parse(eventRoom[j]['StartDateTime']),
        //     to: DateTime.parse(eventRoom[j]['EndDateTime']),
        //     background: eventRoom[j]['MeetingType'] == "EXTERNAL"
        //         ? yellowAccent
        //         : davysGray,
        //     capacity: 5,
        //     contactID: "1111",
        //     isAllDay: false,
        //     eventName: eventRoom[j]['Summary'] ?? "-",
        //     organizer: "",
        //     recurrenceRule: "NONE",
        //     endTimeZone: "",
        //     startTimeZone: "",
        //     bookingID: eventRoom[j]['BookingID'],
        //     type: eventRoom[j]['Type'],
        //     googleID: eventRoom[j]['GoogleCalendarEventID'],
        //     roomId: dataRoom[i]['RoomID'],
        //     meetingType: eventRoom[j]['MeetingType'],
        //   ),
        // );
        Provider.of<MainModel>(context, listen: false).events.appointments!.add(
              RoomEvent(
                // subject: ,
                resourceIds: [dataRoom[i]['RoomID']],
                from: DateTime.parse(eventRoom[j]['StartDateTime']),
                to: DateTime.parse(eventRoom[j]['EndDateTime']),
                background: eventRoom[j]['MeetingType'] == "EXTERNAL"
                    ? yellowAccent
                    : davysGray,
                capacity: 5,
                contactID: "1111",
                isAllDay: false,
                eventName: eventRoom[j]['Summary'] ?? "-",
                organizer: "",
                recurrenceRule: "NONE",
                endTimeZone: "",
                startTimeZone: "",
                bookingID: eventRoom[j]['BookingID'],
                type: eventRoom[j]['Type'],
                googleID: eventRoom[j]['GoogleCalendarEventID'],
                roomId: dataRoom[i]['RoomID'],
                meetingType: eventRoom[j]['MeetingType'],
              ),
            );
      }
    }
    // _events!.notifyListeners(
    //     CalendarDataSourceAction.reset, _events!.appointments!);
    Provider.of<MainModel>(context, listen: false).events.notifyListeners(
        CalendarDataSourceAction.reset,
        Provider.of<MainModel>(context, listen: false).events.appointments!);
    // setState(() {});
    setState(() {
      // loadingGetCalendar = false;
    });
  }

  Future forRefreshCalendar() async {
    var box = await Hive.openBox('calendarInfo');

    dateRefresh = box.get('selectedDate');
    areaRefresh = box.get('selectedArea');
    dataRoomRefresh = box.get('dataRoom');
    eventRoomRefresh = box.get('eventRoom');
  }

  Future updateEvent(MainModel model) async {
    // print(model.selectedArea);
    // print(model.selectedDate);
    // getBookingListRoom(model.selectedArea, model.selectedDate, model)
    //     .then((value) {
    //   model.setEvents(value['Data'], model.dataRoom, model.eventRoom);
    // });
  }

  setDatePickerStatus(bool value) {
    setState(() {
      datePickerVisible = value;
      datePickerRepeatVisible = value;
      emailNode.unfocus();
      emailSuggestionVisible = false;

      // filterContactList = contactList;
    });
  }

  setDatePickerVisible(bool value) {
    setState(() {
      datePickerVisible = value;
    });
  }

  setDatePickerRepeatVisible(bool value) {
    setState(() {
      datePickerRepeatVisible = value;
    });
  }

  setLayout(String name, String id, String base64, String url, bool isUpload) {
    setState(() {
      emptyLayout = false;
      if (isUpload) {
        layoutName = "";
        layoutId = "";
        layoutBase64 = base64;
        layoutFromupload = true;
      } else {
        layoutImageUrl = url;
        layoutId = id;
        layoutName = name;
        layoutFromupload = false;
      }
    });
  }

  DateTime today = DateTime.now();

  List<DropdownMenuItem<String>> addDividerItem(List items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['value'],
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

  List<double> _getCustomItemsHeights(List items) {
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

  setStartTime(String value) {
    setState(() {
      startTime = value;

      _startTime.text = startTime;

      var hour = int.parse(value.split(':').first);
      var minute = int.parse(value.split(':').last);
      var minuteEnd = minute;
      var hourEnd = hour + 1;
      if (minuteEnd == 60) {
        hourEnd = hourEnd + 1;
        minuteEnd = 0;
      }

      endTime =
          "${hourEnd.toString().padLeft(2, '0')}:${minuteEnd.toString().padLeft(2, '0')}";
      _endTime.text = endTime;
    });
  }

  setEndTime(String value) {
    setState(() {
      endTime = value;
      _endTime.text = endTime;
    });
  }

  setDate(String value, DateTime date) {
    setState(() {
      _date.text = value;
      selectedDate = date;
      //   if (DateFormat('yyyy-MM-dd').format(date) !=
      //       DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      //     startTime = '07:00';
      //     endTime = '07:15';
      //   } else {
      //     dynamic hour = TimeOfDay.now().hour;
      //     dynamic minute = TimeOfDay.now().minute;
      //     dynamic endMinute = minute;
      //     dynamic endHour = hour + 1;
      //     if (TimeOfDay.now().minute >= 0 && TimeOfDay.now().minute < 15) {
      //       minute = TimeOfDay.now().replacing(minute: 15).minute;
      //     } else if (TimeOfDay.now().minute > 15 &&
      //         TimeOfDay.now().minute <= 30) {
      //       minute = TimeOfDay.now().replacing(minute: 30).minute;
      //     } else if (TimeOfDay.now().minute > 30 &&
      //         TimeOfDay.now().minute <= 45) {
      //       minute = TimeOfDay.now().replacing(minute: 45).minute;
      //     } else if (TimeOfDay.now().minute > 45 &&
      //         TimeOfDay.now().minute <= 60) {
      //       minute = TimeOfDay.now().replacing(minute: 0).minute;
      //       hour = hour + 1;
      //     }
      //     // endMinute = minute + 15;
      //     // endHour = endHour + 1;
      //     if (endMinute == 60) {
      //       endHour = hour;
      //       endMinute = 0;
      //     }
      //     hour = hour.toString().padLeft(2, '0');
      //     minute = minute.toString().padLeft(2, '0');

      //     endHour = endHour.toString().padLeft(2, '0');
      //     endMinute = endMinute.toString().padLeft(2, '0');

      //     startTime = "$hour:$minute";
      //     endTime = "$endHour:$endMinute";
      //   }
    });
  }

  setRepeatDate(String value, DateTime date) {
    setState(() {
      _repeatEnd.text = value;
      selectedRepeatDate = date;
    });
  }

  setListFacility(List<Amenities> value) {
    // print('value');
    // print(value);
    // setState(() {
    for (var i = 0; i < resultAmenities.length; i++) {
      for (var j = 0; j < value.length; j++) {
        if (resultAmenities[i].amenitiesId == value[j].amenitiesId) {
          setState(() {
            resultAmenities[i].qty = value[j].qty;
            resultAmenities[i].defaultAmount = value[j].defaultAmount;
          });
        }
      }
    }
    listAmenities = value;
    // });
    // print("resultAmenities ---> $resultAmenities");
  }

  setListFood(List<FoodAmenities> value) {
    setState(() {
      for (var i = 0; i < resultFoodAmenities.length; i++) {
        for (var j = 0; j < value.length; j++) {
          if (resultFoodAmenities[i]['FoodAmenitiesID'].toString() ==
              value[j].amenitiesId.toString()) {
            resultFoodAmenities[i]['Amount'] = value[j].qty;
          }
        }
      }
      listFoods = value;
    });
  }

  selectGuest(String value) {
    setState(() {
      print("select");
      emailSuggestionVisible = false;
      emailNode.unfocus();
      invitedGuest.add(value);
      _email.text = "";
    });
  }

  OverlayEntry emailOverlay() {
    RenderBox? renderBox =
        emailKey.currentContext!.findRenderObject() as RenderBox?;
    var size = renderBox!.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              // left: offset.dx,
              // top: offset.dy + size.height + 10,
              width: size.width,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                link: _layerLink,
                child: Material(
                  elevation: 4.0,
                  child: EmailSuggestionContainer(
                    contactList: contactList,
                    emptyMessage: messageEmptyContact,
                    isEmpty: isContactEmpty,
                    filter: filterContact,
                    selectGuest: selectGuest,
                  ),
                ),
              ),
            ));
  }

  initContactList() {
    print(_email.text);
    apiReq.getContactList(_email.text).then((value) {
      print(value);
      // emailSuggestionVisible = true;
      if (value['Status'].toString() == "200") {
        if (value['Data'].toString() == "[]") {
          contactList = [];
          isContactEmpty = true;
          messageEmptyContact = value['Message'];
          setState(() {});
        } else {
          contactList = value['Data'];
          filterContactList = contactList;
          isContactEmpty = false;
          setState(() {});
        }
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text(
      //       'Error fetching contact data!',
      //       maxLines: 1,
      //     ),
      //   ),
      // );
    });
  }

  checkEndTime() {
    int hour = int.parse(widget.endTime!.toString().split(":")[0].toString());
    int minute = int.parse(widget.endTime!.toString().split(":")[1].toString());

    if (hour >= 19) {
      endTime = '19:00';
      if (minute != 00) {
        endTime = '19:00';
      }
    } else {
      endTime = widget.endTime!;
    }

    _endTime.text = endTime;
  }

  @override
  void initState() {
    super.initState();
    // String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());

    // if (widget.isEdit) {
    //   dynamic recurrent = widget.recurrent[0];
    //   _eventName.text = widget.summary;
    //   _eventDesc.text = widget.description;
    //   // _additionalNote.text = widget.additionalNote;f
    //   _totalParticipant.text = widget.participant!;
    //   List tempGuest = widget.invitedGuest!;
    //   for (var element in tempGuest) {
    //     invitedGuest.add(element['AttendantsEmail']);
    //   }
    //   // invitedGuest = widget.invitedGuest!;
    //   repeatValue = recurrent['repeatType'];
    //   String formattedDate =
    //       DateFormat('d MMM yyyy').format(DateTime.parse(widget.date!));
    //   _date.text = formattedDate;
    //   // _date.text = widget.date!;
    //   startTime = widget.startTime!;
    //   endTime = widget.endTime!;
    //   _startTime.text = widget.startTime!;
    //   _endTime.text = widget.endTime!;
    //   repeatEnd = recurrent['repeatEndDate'].toString().substring(0, 10);
    //   repeatInterval = recurrent['interval'].toString();
    //   monthAbsolute = recurrent['montAbs'].toString();
    //   _repeatInterval.text = repeatInterval;
    //   _repeatEnd.text =
    //       DateFormat('d MMM yyyy').format(recurrent['repeatEndDate']);
    //   _totalParticipant.text = widget.participant!;
    //   if (widget.roomType != 'MeetingRoom') {
    //     layoutSectionVisible = true;
    //     repeatSectionVisible = false;
    //   }
    //   if (widget.facilities != "[]") {
    //     print('widget facilities');
    //     print(widget.facilities!);

    //     for (var element in widget.facilities!) {
    //       if (element['Amount'] > 0) {
    //         listAmenities.add(Amenities(
    //           amenitiesId: element['AmenitiesID'],
    //           amenitiesName: element['AmenitiesName'],
    //           photo: element['ImageURL'],
    //           qty: element['Amount'],
    //         ));
    //       }
    //     }
    //     for (var element in widget.foodAmenities!) {
    //       if (element['Amount'] > 0) {
    //         listFoods.add(FoodAmenities(
    //           amenitiesId: element['AmenitiesID'],
    //           amenitiesName: element['AmenitiesName'],
    //           photo: element['ImageURL'],
    //           qty: element['Amount'],
    //         ));
    //       }
    //     }
    //   }
    // }

    if (widget.roomId!.startsWith('AU')) {
      roomType = "Auditorium";
    }
    if (widget.roomId!.startsWith('SH')) {
      roomType = "SocialHub";
    }
    if (widget.roomId!.startsWith('MR')) {
      roomType = "MeetingRoom";
      setState(() {
        isAdditionalNotesVisible = false;
      });
    }
    if (widget.roomId!.startsWith('CA')) {
      roomType = "Canteen";
    }
    selectedDate = DateTime.parse(widget.date!);
    apiReq.getRoomDetail(widget.roomId!).then((value) {
      if (value['Status'].toString() == "200") {
        setState(() {
          participantValue = double.parse(widget.participant!);
          pictureLoading = false;
          roomName = value['Data']['RoomName'];
          floor = value['Data']['AreaName'];
          participantMax = value['Data']['MaxCapacity'];
          participantMin = value['Data']['MinCapacity'];

          List tempResultAmenities = value['Data']['Amenities'];
          for (var element in tempResultAmenities) {
            if (element['Default'] > 0) {
              listAmenities.add(
                Amenities(
                  amenitiesId: element['AmenitiesID'],
                  amenitiesName: element['AmenitiesName'],
                  photo: element['ImageURL'],
                  qty: element['Amount'],
                  defaultAmount: element['Default'],
                ),
              );
            }
            resultAmenities.add(
              Amenities(
                amenitiesId: element['AmenitiesID'],
                amenitiesName: element['AmenitiesName'],
                photo: element['ImageURL'],
                qty: element['Amount'],
                defaultAmount: element['Default'],
              ),
            );
          }
          resultFoodAmenities = value['Data']['FoodAmenities'];
          if (value['Data']['Photos'] != []) {
            isPictEmpty = false;
            resultPicture = value['Data']['Photos'];
          } else {
            isPictEmpty = true;
            resultPicture.add({
              'ImageType': 'NOTFOUND',
              'ImageUrl':
                  'https://media.istockphoto.com/id/1357365823/vector/default-image-icon-vector-missing-picture-page-for-website-design-or-mobile-app-no-photo.jpg?b=1&s=170667a&w=0&k=20&c=LEhQ7Gji4-gllQqp80hLpQsLHlHLw61DoiVf7XJsSx0='
            });
          }

          String formattedDate =
              DateFormat('d MMM yyyy').format(DateTime.parse(widget.date!));
          _date.text = formattedDate;
          startTime = widget.startTime!;
          checkEndTime();
          // endTime = widget.endTime!;
          _startTime.text = widget.startTime!;
          // _endTime.text = widget.endTime!;
          _repeatEnd.text = DateFormat('d MMM yyyy').format(DateTime.now());
          _totalParticipant.text = widget.participant!;
          if (widget.participant == "25" || widget.participant == "0") {
            // _totalParticipant.text = participantMin.toString();
            _totalParticipant.text = "";
          }

          // if (widget.participant == "0") {
          //   _totalParticipant.text = participantMin.toString();
          // }
          if (roomType != 'MeetingRoom') {
            _totalParticipant.text = "";
            // layoutSectionVisible = true;
            repeatSectionVisible = false;
            // _totalParticipant.text = participantMin.toString();
          }
          if (roomType == "Auditorium") {
            layoutSectionVisible = true;
          }
          _repeatOnMonthly.text = selectedDate!.day.toString();
          apiReq.getMeetingType().then((value) {
            // print(value['Data']);
            if (value['Status'].toString() == "200") {
              List result = value['Data'];
              setState(() {
                for (var element in result) {
                  listEventType!.add(
                    RadioModel(
                      isSelected: false,
                      text: element['Name'],
                      value: element['Value'],
                    ),
                  );
                }
                // selectedEventType = value['Data'][0]['Value'];
              });
            } else if (value['Status'].toString() == "401") {
              showDialog(
                context: context,
                builder: (context) => TokenExpiredDialog(
                  title: value['Title'],
                  contentText: value['Message'],
                  isSuccess: false,
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialogBlack(
                  title: value['Title'],
                  contentText: value['Message'],
                  isSuccess: false,
                ),
              );
              if (value['Status'].toString() == "401") {
                context.go('/login');
              }
            }
          }).onError((error, stackTrace) {
            showDialog(
              context: context,
              builder: (context) => AlertDialogBlack(
                title: 'Failed connect to API',
                contentText: error.toString(),
                isSuccess: false,
              ),
            );
          });
          if (widget.isEdit == "true") {
            isEdit = true;
            dynamic editData = widget.edit;
            // print(editData['guestInvited']);
            // selectedDate = DateTime.parse(widget.date!);
            dynamic guest = editData['guestInvited'];
            dynamic amenities = editData['facilities'];

            // print(guest);
            print('bahan edit');
            print(editData);
            selectedEventType = editData['meetingType'];
            _eventName.text = editData['summary'];
            _eventDesc.text = editData['description'];
            _additionalNote.text = editData['additionalNote'];
            repeatValue = editData['repeatType'];
            List tempGuesList = json.decode(guest);
            // print("Guest -> $tempGuesList");
            for (var element in tempGuesList) {
              invitedGuest.add(element);
            }
            // invitedGuest = guest.toList();
            List tempAmenities = json.decode(amenities);
            listAmenities.clear();
            for (var element in tempAmenities) {
              listAmenities.add(Amenities(
                amenitiesId: element['AmenitiesID'],
                amenitiesName: element['AmenitiesName'],
                defaultAmount: int.parse(element['DefaultAmount']),
                qty: int.parse(element['Amount']),
                photo: element['ImageURL'],
              ));
            }
            if (editData['bookingType'] == "RECURRENT") {
              _repeatEnd.text = DateFormat('d MMM yyyy')
                  .format(DateTime.parse(editData['repeatEndDate']));
              _repeatInterval.text = editData['interval'];
              _repeatOnMonthly.text = editData['montAbs'];
            }
            layoutImageUrl = editData['layoutImage'];
            layoutName = editData['layoutName'];
            layoutId = editData['layoutId'];
            layoutFromupload = false;
            if (layoutImageUrl != "" || layoutId != "") {
              emptyLayout = false;
            }
            participantValue = double.parse(editData['participant'].toString());
            _totalParticipant.text = participantValue.toString();
            setState(() {});
          } else {
            isEdit = false;
          }
        });
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
        if (value['Status'].toString() == "401") {
          context.go('/login');
        }
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });

    _email.addListener(() {
      filterContact = _email.text;
      if (_email.text != "") {
        // filterContactList.clear();
        setState(() {
          emailSuggestionVisible = true;
          initContactList();
        });
      }
      if (_email.text == "") {
        setState(() {
          initContactList();
          emailSuggestionVisible = false;
          isContactEmpty = true;
        });
      }
    });
    eventDescNode.addListener(
      () {
        setState(() {});
      },
    );
    eventNameNode.addListener(
      () {
        setState(() {});
      },
    );
    repeatEndNode.addListener(
      () {
        setState(() {});
      },
    );
    repeatNode.addListener(
      () {
        setState(() {});
      },
    );
    totalParticipantNode.addListener(
      () {
        setState(() {});
        // if (!totalParticipantNode.hasFocus) {
        //   if (int.parse(_totalParticipant.text) < participantMin) {
        //     _totalParticipant.text = participantMin.toString();
        //   }
        // }
      },
    );
    dateNode.addListener(
      () {
        setState(() {});
      },
    );
    startTimeNode.addListener(
      () {
        setState(() {});
      },
    );
    endTimeNode.addListener(
      () {
        setState(() {});
      },
    );
    emailNode.addListener(() async {
      setState(() {
        if (emailNode.hasFocus) {
          if (_email.text != "") {
            initContactList();
          } else {
            initContactList();
            setState(() {
              // _overlayEntry = emailOverlay();
              // Overlay.of(context)!.insert(_overlayEntry!);
              isContactEmpty = true;
              emailSuggestionVisible = false;
            });
          }
        } else {
          // emailSuggestionVisible = false;
          // _overlayEntry!.remove();
        }
      });
    });
    additionalNoteNode.addListener(() {
      setState(() {});
    });
    scrollController.addListener(() {
      // print('test');
      // if (roomType != "MeetingRoom") {
      if (scrollController.offset >
          scrollController.position.maxScrollExtent - 75) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent - 75);
      }
      // }
    });
    // _totalParticipant.addListener(() {
    //   if (int.parse(_totalParticipant.text) < participantMin) {
    //     _totalParticipant.text = participantMin.toString();
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _date.dispose();
    _endTime.dispose();
    _eventDesc.dispose();
    _eventName.dispose();
    _repeatEnd.dispose();
    _startTime.dispose();
    _totalParticipant.dispose();
    _email.dispose();
    _additionalNote.dispose();

    dateNode.removeListener(() {});
    eventDescNode.removeListener(() {});
    eventNameNode.removeListener(() {});
    repeatEndNode.removeListener(() {});
    repeatNode.removeListener(() {});
    totalParticipantNode.removeListener(() {});
    dateNode.removeListener(() {});
    startTimeNode.removeListener(() {});
    endTimeNode.removeListener(() {});
    emailNode.removeListener(() {});
    additionalNoteNode.removeListener(() {});

    eventDescNode.dispose();
    eventNameNode.dispose();
    repeatEndNode.dispose();
    repeatNode.dispose();
    totalParticipantNode.dispose();
    dateNode.dispose();
    startTimeNode.dispose();
    endTimeNode.dispose();
    emailNode.dispose();
    additionalNoteNode.dispose();
  }

  resetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        LayoutPageWeb(
          resetState: resetState,
          index: widget.index,
          scrollController: scrollController,
          setDatePickerStatus: setDatePickerStatus,
          child: Consumer<MainModel>(builder: (context, model, child) {
            return ConstrainedBox(
              constraints: pageConstraints,
              child: Container(
                width: 1366,
                // height: MediaQuery.of(context).size.height - (60 + 115 + 5 + 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 500,
                        ),
                        child: Container(
                          width: 600,
                          // height: 1000,
                          // color: Colors.green,
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'Booking Details',
                                  style: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                inputField(
                                  'Event Name:',
                                  Expanded(
                                    child: BlackInputField(
                                      controller: _eventName,
                                      enabled: true,
                                      focusNode: eventNameNode,
                                      hintText: 'Name here ...',
                                      obsecureText: false,
                                      onTap: () {},
                                      onSaved: (newValue) {
                                        eventName = newValue!;
                                      },
                                      // validator: (value) => value == ""
                                      //     ? 'This field is required'
                                      //     : null,
                                      validator: (value) {
                                        if (value == "") {
                                          return 'This field is required';
                                        } else {
                                          if (value.toString().contains("\"") ||
                                              value.toString().contains("'")) {
                                            return 'Can\'t contains " or \' symbols.';
                                          } else {
                                            return null;
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                descriptionField(
                                  'Event Description:',
                                  Expanded(
                                    child: BlackInputField(
                                      controller: _eventDesc,
                                      enabled: true,
                                      focusNode: eventDescNode,
                                      hintText: 'Desc here ...',
                                      obsecureText: false,
                                      onSaved: (newValue) {
                                        eventDesc = newValue!;
                                      },
                                      // inputFormatters: [
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter,
                                      // ],
                                      maxLines: 4,
                                      // validator: (value) {
                                      //   if (value != "") {
                                      //     if (value.toString().contains("\"") ||
                                      //         value.toString().contains("'")) {
                                      //       return 'Can\'t contains " or \' symbols.';
                                      //     }
                                      //     else {
                                      //       return null;
                                      //     }
                                      //   }
                                      // },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //DATE SECTION
                                inputField(
                                  'Date:',
                                  SizedBox(
                                    width: 150,
                                    child: InkWell(
                                      onTap: () {
                                        if (datePickerVisible) {
                                          setDatePickerVisible(false);
                                        } else {
                                          setDatePickerVisible(true);
                                          setDatePickerRepeatVisible(false);
                                        }
                                      },
                                      child: NoBorderInputField(
                                        controller: _date,
                                        focusNode: dateNode,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //TIME START SECTION
                                inputField(
                                  'Time Start:',
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (context) =>
                                            PickStartTimeDialog(
                                          selectedTime: startTime,
                                          setStartTime: setStartTime,
                                          selectedDate: selectedDate,
                                          roomId: widget.roomId,
                                          roomName: roomName,
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 80,
                                      child: NoBorderInputField(
                                        controller: _startTime,
                                        focusNode: startTimeNode,
                                        enable: false,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //END TIME SECTION
                                inputField(
                                  'Time End:',
                                  InkWell(
                                    onTap: startTime == ""
                                        ? () {}
                                        : () {
                                            showDialog(
                                              barrierDismissible: true,
                                              context: context,
                                              builder: (context) =>
                                                  PickEndTimeDialog(
                                                selectedTime: startTime,
                                                startTime: startTime,
                                                endTime: endTime,
                                                setEndTime: setEndTime,
                                                selectedDate: selectedDate,
                                                roomId: widget.roomId,
                                                roomName: roomName,
                                              ),
                                            ).then((value) {
                                              // print(startTime);
                                            });
                                          },
                                    child: SizedBox(
                                      width: 80,
                                      child: NoBorderInputField(
                                        controller: _endTime,
                                        focusNode: endTimeNode,
                                        onSaved: (newValue) {
                                          endTime = newValue!;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                inputField(
                                  'Total Participant:',
                                  // Expanded(
                                  //   child: Align(
                                  //     alignment: Alignment.centerLeft,
                                  //     child: Slider(
                                  //       thumbColor: davysGray,
                                  //       value: participantValue,
                                  //       onChanged: (value) {
                                  //         setState(() {
                                  //           participantValue = value;
                                  //           participantValue =
                                  //               participantValue
                                  //                   .round()
                                  //                   .toDouble();
                                  //         });
                                  //       },
                                  //       min: 1,
                                  //       max: participantMax,
                                  //       divisions: participantMax.toInt(),
                                  //       label:
                                  //           '${participantValue.round()} Person',
                                  //       activeColor: eerieBlack,
                                  //       inactiveColor: platinum,
                                  //       // divisions: 1,
                                  //     ),
                                  //   ),
                                  // )
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: BlackInputField(
                                          controller: _totalParticipant,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          // validator: (value) => value == ""
                                          //     ? "Min. $participantMin"
                                          //     : null,
                                          // validator: (value) {
                                          //   if (value.toString() != "") {
                                          //     if (int.parse(value) >=
                                          //             participantMin.toInt() &&
                                          //         int.parse(value) <=
                                          //             participantMax.toInt()) {
                                          //       return null;
                                          //     } else {
                                          //       return "$participantMin - $participantMax";
                                          //     }
                                          //   } else {
                                          //     return "$participantMin - $participantMax";
                                          //   }
                                          // },
                                          focusNode: totalParticipantNode,
                                          onSaved: (newValue) {
                                            totalParticipant = newValue!;
                                          },
                                          // onEditingComplete: () {
                                          //   if (int.parse(
                                          //           _totalParticipant.text) <
                                          //       participantMin) {
                                          //     _totalParticipant.text =
                                          //         participantMin.toString();
                                          //   }
                                          // },
                                          enabled: true,
                                          hintText: 'Total',
                                          obsecureText: false,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Person',
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                inputField(
                                  'Invite Guest:',
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CompositedTransformTarget(
                                            link: _layerLink,
                                            child: SizedBox(
                                              key: emailKey,
                                              // width: 100,
                                              child: BlackInputField(
                                                controller: _email,
                                                focusNode: emailNode,
                                                enabled: true,
                                                hintText: 'Email here..',
                                                maxLines: 1,
                                                obsecureText: false,
                                                onFieldSubmitted: (x) {
                                                  if (_email.text != "") {
                                                    setState(() {
                                                      if (EmailValidator
                                                          .validate(x)) {
                                                        invitedGuest
                                                            .add(_email.text);
                                                        _email.text = "";
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              const AlertDialogBlack(
                                                            title:
                                                                'Email not valid',
                                                            contentText:
                                                                "Please check the email address.",
                                                            isSuccess: false,
                                                          ),
                                                        );
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (EmailValidator.validate(
                                                _email.text)) {
                                              if (_email.text != "") {
                                                setState(() {
                                                  invitedGuest.add(_email.text);
                                                  _email.text = "";
                                                });
                                              }
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    const AlertDialogBlack(
                                                  title: 'Email not valid',
                                                  contentText:
                                                      "Please check the email address.",
                                                  isSuccess: false,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                inputField(
                                  '',
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: invitedGuest.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding:
                                                index < invitedGuest.length - 1
                                                    ? const EdgeInsets.only(
                                                        bottom: 7)
                                                    : const EdgeInsets.only(
                                                        bottom: 2),
                                            child: Chip(
                                              label: Text(invitedGuest[index]),
                                              padding: const EdgeInsets.only(
                                                  right: 0, left: 15),
                                              labelStyle: const TextStyle(
                                                fontFamily: 'Helvetica',
                                                color: culturedWhite,
                                                fontSize: 16,
                                                height: 1.3,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7.5),
                                              ),
                                              backgroundColor: davysGray,
                                              deleteIcon: const Icon(
                                                Icons.close,
                                                size: 18,
                                              ),
                                              deleteIconColor: culturedWhite,
                                              labelPadding:
                                                  const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                              ),
                                              onDeleted: () {
                                                invitedGuest.removeAt(index);
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                inputField(
                                  'Event Type',
                                  // ListView.builder(
                                  //   itemCount: listEventType!.length,
                                  //   scrollDirection: Axis.horizontal,
                                  //   shrinkWrap: true,
                                  //   itemBuilder: (context, index) {
                                  //     return CustomRadioButton(
                                  //       group: selectedEventType!,
                                  //       value: listEventType![index].value,
                                  //       label: listEventType![index].text,
                                  //       onChanged: (value) {
                                  //         selectedEventType = value;
                                  //         setState(() {});
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                  Expanded(
                                    child: Container(
                                      height: 20,
                                      width: 500,
                                      child: ScrollConfiguration(
                                        behavior: MyCustomScrollBehavior(),
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          children: listEventType!.map((e) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 30,
                                              ),
                                              child: CustomRadioButton(
                                                group: selectedEventType!,
                                                value: e.value,
                                                label: e.text,
                                                onChanged: (value) {
                                                  selectedEventType = value;
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          }).toList(),
                                          // children: [
                                          //   CustomRadioButton(
                                          //     group: selectedEventType,
                                          //     value: 'Internal',
                                          //     onChanged: (value) {
                                          //       selectedEventType = value;
                                          //       setState(() {});
                                          //     },
                                          //     label: 'Internal',
                                          //   ),
                                          //   const SizedBox(
                                          //     width: 30,
                                          //   ),
                                          //   CustomRadioButton(
                                          //     group: selectedEventType,
                                          //     value: 'External',
                                          //     onChanged: (value) {
                                          //       selectedEventType = value;
                                          //       setState(() {});
                                          //     },
                                          //     label: 'External',
                                          //   ),
                                          // ],
                                        ),
                                      ),
                                    ),
                                    // child: ListView.builder(
                                    //   itemCount: listEventType!.length,
                                    //   scrollDirection: Axis.horizontal,
                                    //   shrinkWrap: true,
                                    //   itemBuilder: (context, index) {
                                    //     return CustomRadioButton(
                                    //       group: selectedEventType!,
                                    //       value: listEventType![index].text,
                                    //       label: listEventType![index].text,
                                    //       onChanged: (value) {
                                    //         selectedEventType = value;
                                    //         setState(() {});
                                    //       },
                                    //     );
                                    //   },
                                    // ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                //REPEAT SECTION
                                Visibility(
                                  // visible:
                                  //     roomType == "MeetingRoom" ? true : false,
                                  visible: false,
                                  child: Column(
                                    children: [
                                      inputField(
                                        'Repeat:',
                                        SizedBox(
                                          width: 250,
                                          child: BlackDropdown(
                                            focusNode: repeatNode,
                                            customHeights:
                                                _getCustomItemsHeights(
                                                    repeatItems!),
                                            items: addDividerItem(repeatItems!),
                                            enabled: true,
                                            hintText: '',
                                            onChanged: (value) {
                                              repeatValue = value;
                                              if (repeatValue != "NONE") {
                                                _repeatInterval.text = "1";
                                              } else {
                                                _repeatInterval.text = "0";
                                              }

                                              if (repeatValue == "MONTHLY") {
                                                selectedRepeatDate =
                                                    selectedDate!.add(
                                                        const Duration(
                                                            days: 30));
                                                _repeatEnd.text = DateFormat(
                                                        'dd MMM yyy')
                                                    .format(
                                                        selectedRepeatDate!);
                                              }

                                              if (repeatValue == "WEEKLY") {
                                                selectedRepeatDate =
                                                    selectedDate!.add(
                                                        const Duration(
                                                            days: 7));
                                                _repeatEnd.text = DateFormat(
                                                        'dd MMM yyy')
                                                    .format(
                                                        selectedRepeatDate!);
                                              }
                                            },
                                            value: repeatValue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),

                                //REPEAT OPTIONS
                                Visibility(
                                  visible: repeatValue == "NONE" ? false : true,
                                  child: Column(
                                    children: [
                                      //MONTHLY OPTIONS
                                      Visibility(
                                        visible: repeatValue == "MONTHLY"
                                            ? true
                                            : false,
                                        child: Column(
                                          children: [
                                            inputField(
                                              'Repeat On:',
                                              SizedBox(
                                                width: 100,
                                                child: BlackInputField(
                                                  controller: _repeatOnMonthly,
                                                  enabled: true,
                                                  focusNode: repeatOnNode,
                                                  onSaved: (newValue) {
                                                    monthAbsolute = newValue!;
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                      //END MONTHLY OPTIONS
                                      //WEEKLY OPTIONS
                                      Visibility(
                                        visible: repeatValue == "WEEKLY"
                                            ? true
                                            : false,
                                        child: Column(
                                          children: [
                                            inputField(
                                              '',
                                              SizedBox(
                                                height: 30,
                                                width: 400,
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      weeklyOptions.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var todayDay = DateFormat(
                                                            'EEEE')
                                                        .format(selectedDate!);
                                                    for (var element
                                                        in weeklyOptions) {
                                                      if (element['name'] ==
                                                          todayDay) {
                                                        element['isSelected'] =
                                                            true;
                                                      }
                                                    }
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 10,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (weeklyOptions[
                                                                    index][
                                                                'isSelected']) {
                                                              weeklyOptions[
                                                                          index]
                                                                      [
                                                                      'isSelected'] =
                                                                  false;
                                                            } else {
                                                              weeklyOptions[
                                                                          index]
                                                                      [
                                                                      'isSelected'] =
                                                                  true;
                                                            }
                                                            if (weeklyOptions
                                                                .any((element) =>
                                                                    element[
                                                                        'isSelected'] ==
                                                                    false)) {
                                                              var todayDay =
                                                                  DateFormat(
                                                                          'EEEE')
                                                                      .format(
                                                                          selectedDate!);
                                                              for (var element
                                                                  in weeklyOptions) {
                                                                if (element[
                                                                        'name'] ==
                                                                    todayDay) {
                                                                  element['isSelected'] =
                                                                      true;
                                                                }
                                                              }
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          // padding:
                                                          //     const EdgeInsets.all(
                                                          //         10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: weeklyOptions[
                                                                        index][
                                                                    'isSelected']
                                                                ? greenAcent
                                                                : platinum,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              weeklyOptions[
                                                                      index]
                                                                  ['initial'],
                                                              style:
                                                                  helveticaText
                                                                      .copyWith(
                                                                fontSize: 12,
                                                                height: 1.3,
                                                                color: weeklyOptions[
                                                                            index]
                                                                        [
                                                                        'isSelected']
                                                                    ? culturedWhite
                                                                    : davysGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                      //END WEEKLY OPTIONS
                                      inputField(
                                        'Interval',
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: BlackInputField(
                                                enabled: true,
                                                controller: _repeatInterval,
                                                focusNode: repeatIntervalNode,
                                                onSaved: (newValue) {
                                                  repeatInterval = newValue!;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              repeatValue == "DAILY"
                                                  ? 'Day'
                                                  : repeatValue == "WEEKLY"
                                                      ? 'Week'
                                                      : repeatValue == "MONTHLY"
                                                          ? 'Month'
                                                          : '',
                                              style: const TextStyle(
                                                fontFamily: 'Helvetica',
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      inputField(
                                        'Repeat End:',
                                        InkWell(
                                          onTap: () {
                                            if (datePickerRepeatVisible) {
                                              setDatePickerRepeatVisible(false);
                                            } else {
                                              setDatePickerRepeatVisible(true);
                                              setDatePickerVisible(false);
                                            }
                                          },
                                          child: SizedBox(
                                            width: 145,
                                            child: NoBorderInputField(
                                              controller: _repeatEnd,
                                              focusNode: repeatEndNode,
                                              enable: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(
                                  color: spanishGray,
                                  thickness: 0.5,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                facilitySection(),
                                const SizedBox(
                                  height: 20,
                                ),
                                Visibility(
                                  visible: layoutSectionVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(
                                        color: spanishGray,
                                        thickness: 0.5,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      foodSection(),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: layoutSectionVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Divider(
                                        color: spanishGray,
                                        thickness: 0.5,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      layoutSection(),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: isAdditionalNotesVisible,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Divider(
                                        color: spanishGray,
                                        thickness: 0.5,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      additionalNoteSection(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                isSubmitLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: eerieBlack,
                                        ),
                                      )
                                    : RegularButton(
                                        text: 'Confirm',
                                        disabled: false,
                                        padding: ButtonSize().longSize(),
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            formKey.currentState!.save();
                                            setState(() {
                                              isSubmitLoading = true;
                                            });
                                            List selectedDay = [];
                                            Booking booking = Booking();
                                            if (widget.isEdit == "true") {
                                              booking.bookingId =
                                                  widget.edit['bookingId'];
                                            }
                                            booking.roomId = widget.roomId;
                                            booking.roomType = roomType;
                                            booking.summary = eventName
                                                .replaceAll('"', '\\"');
                                            booking.description = eventDesc
                                                .replaceAll('\n', '\\n')
                                                .replaceAll('"', '\\"');
                                            booking.additionalNote =
                                                additionalNote
                                                    .replaceAll('\n', '\\n')
                                                    .replaceAll('"', '\\"');
                                            booking.startDate = DateTime.parse(
                                                "${DateFormat('yyyy-MM-dd').format(selectedDate!)} $startTime:00");
                                            booking.endDate = DateTime.parse(
                                                "${DateFormat('yyyy-MM-dd').format(selectedDate!)} $endTime:00");
                                            List tempAmen = [];

                                            for (var element in listAmenities) {
                                              tempAmen.add({
                                                '"AmenitiesID"':
                                                    element.amenitiesId,
                                                '"Amount"': element.qty
                                              });
                                            }
                                            List tempFood = [];
                                            for (var element in listFoods) {
                                              tempFood.add({
                                                '"FoodAmenitiesID"':
                                                    element.amenitiesId,
                                                '"Amount"': element.qty
                                              });
                                            }

                                            List tempGuest = [];
                                            for (var element in invitedGuest) {
                                              tempGuest.add('"$element"');
                                            }

                                            // totalParticipant =
                                            //     participantValue.toString();
                                            booking.amenities = tempAmen;
                                            booking.foodAmenities = tempFood;
                                            booking.recursive = repeatValue;
                                            booking.attendantsNumber =
                                                totalParticipant;
                                            booking.attendants = tempGuest;
                                            booking.meetingType =
                                                selectedEventType;
                                            booking.repeatInterval =
                                                int.parse(repeatInterval);
                                            booking.repeatEndDate =
                                                DateFormat('yyyy-M-dd').format(
                                                    selectedRepeatDate!);
                                            // _repeatEnd.text;
                                            if (repeatValue == "WEEKLY") {
                                              weeklyOptions
                                                  .where((element) =>
                                                      element['isSelected'] ==
                                                      true)
                                                  .forEach((element) {
                                                selectedDay.add(
                                                    '"${element['value']}"');
                                              });
                                              booking.daysWeek = selectedDay;
                                            }
                                            if (repeatValue == "MONTHLY") {
                                              booking.monthAbs =
                                                  int.parse(monthAbsolute);
                                            }
                                            // debugPrint(
                                            //     booking.toJson().toString());
                                            // print(booking.toJson());
                                            // context.pop();
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (context) => ConfirmBookDialog(
                                            //     booking: booking,
                                            //   ),
                                            // );
                                            // print(
                                            //     'Selected Area -> ${Provider.of<MainModel>(context, listen: false).selectedArea}');
                                            // print(
                                            //     'Selected Date -> ${Provider.of<MainModel>(context, listen: false).selectedDate}');
                                            // print(
                                            //     'Data Room -> ${Provider.of<MainModel>(context, listen: false).dataRoom}');
                                            // print(
                                            // 'Event Room -> ${Provider.of<MainModel>(context, listen: false).eventRoom}');
                                            // print(
                                            //     'Selected Area -> ${model.selectedArea}');
                                            // print(
                                            //     'Selected Date -> ${model.selectedDate}');
                                            // print('Data Room -> ${model.dataRoom}');
                                            // print('Event Room -> ${model.eventRoom}');
                                            // forRefreshCalendar();
                                            // print('Selected Area -> $areaRefresh');
                                            // print('Selected Date -> $dateRefresh');
                                            // print('Data Room -> $dataRoomRefresh');
                                            // print('Event Room -> $eventRoomRefresh');
                                            if (roomType == "MeetingRoom") {
                                              if (!isEdit) {
                                                print(booking.toJson());
                                                //BOOKING FUNCTION
                                                apiReq
                                                    .bookingRoom(booking)
                                                    .then((value) {
                                                  // print(value);
                                                  if (value['Status'] ==
                                                      "200") {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialogBlack(
                                                              title: value[
                                                                  'Title'],
                                                              contentText: value[
                                                                  'Message']),
                                                    ).then((value) {
                                                      // updateEvent(model).then((value) {
                                                      //   context.go('/rooms');
                                                      // });
                                                      if (widget.floor == "") {
                                                        setState(() {
                                                          isSubmitLoading =
                                                              false;
                                                        });
                                                        context
                                                            .goNamed('rooms');
                                                      } else {
                                                        apiReq
                                                            .getBookingListRoom(
                                                                widget.floor,
                                                                widget.date!)
                                                            .then((value) {
                                                          setState(() {
                                                            isSubmitLoading =
                                                                false;
                                                          });
                                                          if (value['Status']
                                                                  .toString() ==
                                                              "200") {
                                                            assignDataToCalendar(
                                                                    value[
                                                                        'Data'])
                                                                .then((value) {
                                                              context.goNamed(
                                                                  'rooms');
                                                            });
                                                            setState(() {});
                                                          } else {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  AlertDialogBlack(
                                                                title: value[
                                                                    'Title'],
                                                                contentText: value[
                                                                    'Message'],
                                                              ),
                                                            );
                                                          }
                                                        });
                                                      }

                                                      // context.pop();
                                                      // Navigator.of(context).pop();
                                                    });
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialogBlack(
                                                        title: value['Title'],
                                                        contentText:
                                                            value['Message'],
                                                        isSuccess: false,
                                                      ),
                                                    ).then((value) {
                                                      setState(() {
                                                        isSubmitLoading = false;
                                                      });
                                                      // context.go('/rooms');
                                                    });
                                                  }
                                                  // context.pop();
                                                }).onError((error, stackTrace) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialogBlack(
                                                      title: 'Failed',
                                                      contentText:
                                                          error.toString(),
                                                      isSuccess: false,
                                                    ),
                                                  ).then((value) {
                                                    setState(() {
                                                      isSubmitLoading = false;
                                                    });
                                                    // context.go('/rooms');
                                                  });
                                                });
                                                //END BOOOKING FUNCTION
                                              } else {
                                                //EDIT BOOKING FUNCTION
                                                apiReq
                                                    .updateBooking(booking)
                                                    .then((value) {
                                                  // print(value);
                                                  if (value['Status'] ==
                                                      "200") {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialogBlack(
                                                              title: value[
                                                                  'Title'],
                                                              contentText: value[
                                                                  'Message']),
                                                    ).then((value) {
                                                      setState(() {
                                                        isSubmitLoading = false;
                                                      });
                                                      // updateEvent(model).then((value) {
                                                      //   context.go('/rooms');
                                                      // });
                                                      context.go('/rooms');
                                                      // context.pop();
                                                      // Navigator.of(context).pop();
                                                    });
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialogBlack(
                                                        title: value['Title'],
                                                        contentText:
                                                            value['Message'],
                                                        isSuccess: false,
                                                      ),
                                                    ).then((value) {
                                                      setState(() {
                                                        isSubmitLoading = false;
                                                      });
                                                      // context.go('/rooms');
                                                    });
                                                  }
                                                  // context.pop();
                                                }).onError((error, stackTrace) {
                                                  // print(error);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialogBlack(
                                                      title: 'Failed',
                                                      contentText:
                                                          error.toString(),
                                                      isSuccess: false,
                                                    ),
                                                  ).then((value) {
                                                    setState(() {
                                                      isSubmitLoading = false;
                                                    });
                                                    // context.go('/rooms');
                                                  });
                                                });
                                                //END EDIT BOOOKING FUNCTION
                                              }
                                            }
                                            //BOOKING AUDI
                                            else {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) =>
                                                    const ConfirmDialogBlack(
                                                  title: "Confirm Booking?",
                                                  contentText:
                                                      "After this, your event needs to be approved by admin. (Admin: Ridwan / +62 812-9430-5206)",
                                                ),
                                              ).then((value) {
                                                if (value) {
                                                  // if (int.parse(
                                                  //         totalParticipant) <
                                                  //     participantMin) {
                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder: (context) =>
                                                  //       AlertDialogBlack(
                                                  //     title: 'Warning',
                                                  //     contentText:
                                                  //         'Total participants less then $participantMin person.',
                                                  //     isSuccess: false,
                                                  //   ),
                                                  // ).then((value) {
                                                  //   setState(() {
                                                  //     isSubmitLoading = false;
                                                  //   });
                                                  // });
                                                  // } else {
                                                  booking.layoutId = layoutId;
                                                  booking.layoutName =
                                                      layoutName;
                                                  booking.layoutImage =
                                                      layoutImageUrl;
                                                  if (layoutFromupload) {
                                                    booking.layoutImage =
                                                        layoutBase64;
                                                  }
                                                  // print(booking.toJson());
                                                  if (!isEdit) {
                                                    //BOOKING AUDI FUNCTION
                                                    apiReq
                                                        .bookingAudi(booking)
                                                        .then((value) {
                                                      // print(value);
                                                      if (value['Status'] ==
                                                          "200") {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialogBlack(
                                                                  title: value[
                                                                      'Title'],
                                                                  contentText:
                                                                      value[
                                                                          'Message']),
                                                        ).then((value) {
                                                          setState(() {
                                                            isSubmitLoading =
                                                                false;
                                                          });
                                                          // updateEvent(model).then((value) {
                                                          //   context.go('/rooms');
                                                          // });
                                                          context.go('/rooms');
                                                          // context.pop();
                                                          // Navigator.of(context).pop();
                                                        });
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialogBlack(
                                                            title:
                                                                value['Title'],
                                                            contentText: value[
                                                                'Message'],
                                                            isSuccess: false,
                                                          ),
                                                        ).then((value) {
                                                          setState(() {
                                                            isSubmitLoading =
                                                                false;
                                                          });
                                                          // context.go('/rooms');
                                                        });
                                                      }
                                                      // context.pop();
                                                    }).onError((error,
                                                            stackTrace) {
                                                      // print(error);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialogBlack(
                                                          title: 'Failed',
                                                          contentText:
                                                              error.toString(),
                                                          isSuccess: false,
                                                        ),
                                                      ).then((value) {
                                                        setState(() {
                                                          isSubmitLoading =
                                                              false;
                                                        });
                                                        // context.go('/rooms');
                                                      });
                                                    });
                                                    //END BOOKING AUDI FUNCTION
                                                  } else {
                                                    //EDIT AUDI FUNCTION
                                                    apiReq
                                                        .updateBookingAudi(
                                                            booking)
                                                        .then((value) {
                                                      // print(value);
                                                      if (value['Status'] ==
                                                          "200") {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialogBlack(
                                                                  title: value[
                                                                      'Title'],
                                                                  contentText:
                                                                      value[
                                                                          'Message']),
                                                        ).then((value) {
                                                          setState(() {
                                                            isSubmitLoading =
                                                                false;
                                                          });
                                                          // updateEvent(model).then((value) {
                                                          //   context.go('/rooms');
                                                          // });
                                                          context.go('/rooms');
                                                          // context.pop();
                                                          // Navigator.of(context).pop();
                                                        });
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialogBlack(
                                                            title:
                                                                value['Title'],
                                                            contentText: value[
                                                                'Message'],
                                                            isSuccess: false,
                                                          ),
                                                        ).then((value) {
                                                          setState(() {
                                                            isSubmitLoading =
                                                                false;
                                                          });
                                                          // context.go('/rooms');
                                                        });
                                                      }
                                                      // context.pop();
                                                    }).onError((error,
                                                            stackTrace) {
                                                      // print(error);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialogBlack(
                                                          title: 'Failed',
                                                          contentText:
                                                              error.toString(),
                                                          isSuccess: false,
                                                        ),
                                                      ).then((value) {
                                                        setState(() {
                                                          isSubmitLoading =
                                                              false;
                                                        });
                                                        // context.go('/rooms');
                                                      });
                                                    });
                                                    //END EDIT AUDI FUNCTION
                                                  }
                                                  // }
                                                } else {
                                                  setState(() {
                                                    isSubmitLoading = false;
                                                  });
                                                }
                                              });
                                              // print('selain meeting room');
                                              // print(roomType);
                                            }

                                            // debugPrint("""
                                            //   {
                                            //     Event Name = $eventName,
                                            //     Event Desc = $eventDesc,
                                            //     Time Start = $startTime,
                                            //     Time End = $endTime,
                                            //     Date = $date,
                                            //     Room ID = ${widget.roomId},
                                            //     Amenities = ${listAmenities.toString()},
                                            //     Food = ${listFoods.toString()},
                                            //   }
                                            // """);
                                          } //END IF VALIDATE
                                          else {
                                            scrollController.animateTo(0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.linear);
                                          }
                                        },
                                      ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: emailSuggestionVisible,
                      child: Positioned(
                        top: 475,
                        right: 0,
                        child: EmailSuggestionContainer(
                          contactList: contactList,
                          emptyMessage: messageEmptyContact,
                          isEmpty: isContactEmpty,
                          filter: filterContact,
                          selectGuest: selectGuest,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: datePickerVisible,
                      child: Positioned(
                        top: 275,
                        right: 125,
                        child: CustomDatePicker(
                          controller: datePickerControl,
                          currentDate: selectedDate,
                          changeDate: setDate,
                          setPickerStatus: setDatePickerVisible,
                          canPickPastDay: false,
                          maxDate: DateTime.now().add(const Duration(days: 30)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: datePickerRepeatVisible,
                      child: Positioned(
                        top: 760,
                        right: 125,
                        child: CustomDatePicker(
                          controller: repeatDatePickerControl,
                          currentDate: selectedRepeatDate,
                          changeDate: setRepeatDate,
                          canPickPastDay: false,
                          setPickerStatus: setDatePickerRepeatVisible,
                        ),
                      ),
                    )
                    // Positioned(
                    //   // top:  model.isScrollAtEdge ? null : model.scrollPosition + 20,
                    //   // bottom: model.isScrollAtEdge ? 0 : null,
                    //   top: 20,
                    //   left: 20,
                    //   child: ConstrainedBox(
                    //     constraints: BoxConstraints(
                    //       minHeight: 500,
                    //       minWidth: 500,
                    //       maxWidth: 500,
                    //       maxHeight: MediaQuery.of(context).size.height,
                    //     ),
                    //     child: Container(
                    //       height: MediaQuery.of(context).size.height,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //             height: 380,
                    //             width: double.infinity,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10),
                    //               color: Colors.blue,
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   height: 300,
                    //                   decoration: const BoxDecoration(
                    //                     borderRadius: BorderRadius.only(
                    //                       topLeft: Radius.circular(10),
                    //                       topRight: Radius.circular(10),
                    //                     ),
                    //                     // image: DecorationImage(
                    //                     //   image: AssetImage('assets/103.jpg'),
                    //                     //   fit: BoxFit.cover,
                    //                     // ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   height: 80,
                    //                   width: 500,
                    //                   decoration: const BoxDecoration(
                    //                     borderRadius: BorderRadius.only(
                    //                       bottomLeft: Radius.circular(10),
                    //                       bottomRight: Radius.circular(10),
                    //                     ),
                    //                   ),
                    //                   // child: ListView.builder(
                    //                   //   scrollDirection: Axis.horizontal,
                    //                   //   shrinkWrap: true,
                    //                   //   itemCount: 5,
                    //                   //   itemBuilder: (context, index) {
                    //                   //     var borderRadius = index == 0
                    //                   //         ? BorderRadius.only(
                    //                   //             bottomLeft: Radius.circular(10),
                    //                   //           )
                    //                   //         : index == 4
                    //                   //             ? BorderRadius.only(
                    //                   //                 bottomRight:
                    //                   //                     Radius.circular(10),
                    //                   //               )
                    //                   //             : null;
                    //                   //     return Container(
                    //                   //       width: 100,
                    //                   //       height: 80,
                    //                   //       decoration: BoxDecoration(
                    //                   //         borderRadius: borderRadius,
                    //                   //         image: DecorationImage(
                    //                   //           image: AssetImage(
                    //                   //             'assets/103.jpg',
                    //                   //           ),
                    //                   //           fit: BoxFit.cover,
                    //                   //         ),
                    //                   //       ),
                    //                   //     );
                    //                   //   },
                    //                   // ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             height: 25,
                    //           ),
                    //           Text(
                    //             'Persistance',
                    //             style: TextStyle(
                    //               fontFamily: 'Helvetica',
                    //               fontSize: 32,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             height: 10,
                    //           ),
                    //           Text(
                    //             '2nd Floor',
                    //             style: TextStyle(
                    //               fontFamily: 'Helvetica',
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.w300,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1366,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 50,
                          top: 90,
                        ),
                        child: ConstrainedBox(
                          constraints: pageConstraints,
                          child: pictureLoading
                              ? Shimmer(
                                  gradient: const LinearGradient(
                                    colors: [platinum, grayx11, davysGray],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  direction: ShimmerDirection.rtl,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 450,
                                      minWidth: 500,
                                      maxWidth: 500,
                                      maxHeight: 450,
                                    ),
                                    child: const SizedBox(),
                                  ),
                                )
                              : BookingRoomPicture(
                                  pictures: resultPicture,
                                  name: roomName,
                                  area: floor,
                                  pictNotFound: isPictEmpty,
                                  minCapacity: participantMin.toString(),
                                  maxCapacity: participantMax.toString(),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 600,
                  )
                ],
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: 85,
        //   left: 120,
        //   child: ConstrainedBox(
        //     constraints: pageConstraints,
        //     child: pictureLoading
        //         ? const SizedBox(
        //             width: 100,
        //             height: 100,
        //             child: CircularProgressIndicator(
        //               color: eerieBlack,
        //             ),
        //           )
        //         : BookingRoomPicture(
        //             pictures: resultPicture,
        //             name: roomName,
        //             area: floor,
        //             pictNotFound: isPictEmpty,
        //           ),
        //   ),
        // ),
      ],
    );
    ;
  }

  Widget inputField(String label, Widget field) {
    return SizedBox(
      // height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          field,
        ],
      ),
    );
  }

  Widget descriptionField(String label, Widget field) {
    return SizedBox(
      // height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          field,
        ],
      ),
    );
  }

  Widget facilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room Facilities',
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: listAmenities.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 125 / 165,
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            if (index == listAmenities.length) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                  bottom: 15,
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SelectAmenitiesDialog(
                        setListAmenities: setListFacility,
                        roomId: widget.roomId,
                        listAmen: resultAmenities,
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Center(
                    child: Container(
                      height: 165,
                      width: 125,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: spanishGray,
                        padding: EdgeInsets.zero,
                        radius: const Radius.circular(7.5),
                        dashPattern: const [4, 5],
                        strokeWidth: 2,
                        strokeCap: StrokeCap.round,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/add_circle.png'),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Add Facility',
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 16,
                                  color: spanishGray,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return RoomFacilityItem(
              result: listAmenities[index],
              onDelete: () {
                setState(() {
                  var tempID = listAmenities[index].amenitiesId;
                  // print(tempID);
                  for (var i = 0; i < resultAmenities.length; i++) {
                    if (resultAmenities[i].amenitiesId ==
                        listAmenities[index].amenitiesId) {
                      resultAmenities[i].qty = 0;
                    }
                  }
                  listAmenities.removeAt(index);
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget foodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Food & Beverages',
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 13,
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: listFoods.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 125 / 145,
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            if (index == listFoods.length) {
              return Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                  bottom: 15,
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SelectFoodDialog(
                        setListFood: setListFood,
                        listFood: resultFoodAmenities,
                      ),
                    ).then((value) {});
                  },
                  child: Container(
                    height: 145,
                    width: 125,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: spanishGray,
                      padding: EdgeInsets.zero,
                      radius: const Radius.circular(7.5),
                      dashPattern: const [4, 5],
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/add_circle.png'),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Add F&B',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                color: spanishGray,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return FoodItem(
              listFood: listFoods[index],
              onDelete: () {
                setState(() {
                  for (var i = 0; i < resultFoodAmenities.length; i++) {
                    if (resultFoodAmenities[i]['AmenitiesID'].toString() ==
                        listFoods[index].amenitiesId.toString()) {
                      resultFoodAmenities[i]['Amount'] = 0;
                    }
                  }
                  listFoods.removeAt(index);
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget additionalNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Note',
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        BlackInputField(
          controller: _additionalNote,
          enabled: true,
          obsecureText: false,
          focusNode: additionalNoteNode,
          maxLines: 4,
          hintText: 'Additional Notes ...',
          // inputFormatters: [
          //   FilteringTextInputFormatter.singleLineFormatter,
          // ],
          onSaved: (newValue) {
            additionalNote = newValue!;
          },
          // validator: (value) {
          //   if (value != "") {
          //     if (value.toString().contains("\"") ||
          //         value.toString().contains("'")) {
          //       return 'Can\'t contains " or \' symbols.';
          //     } else {
          //       return null;
          //     }
          //   }
          // },
        )
      ],
    );
  }

  Widget layoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room Layout',
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SelectLayoutDialog(
                setLayout: setLayout,
                imaegUrl: layoutImageUrl,
                imageBytes: layoutImageBytes,
                isUpload: layoutFromupload,
                roomId: widget.roomId!,
              ),
            );
          },
          child: emptyLayout
              ? DottedBorder(
                  borderType: BorderType.RRect,
                  color: spanishGray,
                  padding: EdgeInsets.zero,
                  radius: const Radius.circular(7.5),
                  dashPattern: const [10, 4],
                  strokeWidth: 2,
                  strokeCap: StrokeCap.round,
                  child: Container(
                    height: 187,
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/add_circle.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Add Layout',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 16,
                            color: spanishGray,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: davysGray,
                  ),
                  height: 187,
                  width: 250,
                  child: layoutFromupload
                      ? FittedBox(
                          fit: BoxFit.contain,
                          child: Image.memory(
                            Base64Decoder()
                                .convert(layoutBase64.split(',').last),
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.contain,
                          child: Image.network(layoutImageUrl),
                        ),
                ),
        ),
      ],
    );
  }
}
