import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
import 'package:meeting_room_booking_system/widgets/booking_page/booking_detail_picture.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/confirm_book_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/food_item.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/pick_end_time_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/pick_start_time_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/room_facility_item.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_amenities_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_food_dialog.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_layout_dialog.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/custom_date_picker.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/no_border_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class BookingRoomPageDialog extends StatefulWidget {
  BookingRoomPageDialog({
    super.key,
    this.roomId = "",
    this.date = "",
    this.startTime = "",
    this.endTime = "",
    this.roomType = "MeetingRoom",
    this.facilities,
    this.foodAmenities,
    this.participant = "1",
    this.index = 2,
  });

  String? roomId;
  String? date;
  String? startTime;
  String? endTime;
  String? roomType;
  dynamic facilities;
  dynamic foodAmenities;
  String? participant;
  int? index;

  @override
  State<BookingRoomPageDialog> createState() => _BookingRoomPageDialogState();
}

class _BookingRoomPageDialogState extends State<BookingRoomPageDialog> {
  TextEditingController _eventName = TextEditingController();
  TextEditingController _eventDesc = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _startTime = TextEditingController();
  TextEditingController _endTime = TextEditingController();
  TextEditingController _totalParticipant = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _repeatEnd = TextEditingController();
  TextEditingController _additionalNote = TextEditingController();

  FocusNode eventNameNode = FocusNode();
  FocusNode eventDescNode = FocusNode();
  FocusNode dateNode = FocusNode();
  FocusNode startTimeNode = FocusNode();
  FocusNode endTimeNode = FocusNode();
  FocusNode totalParticipantNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode repeatNode = FocusNode();
  FocusNode repeatEndNode = FocusNode();
  FocusNode additionalNoteNode = FocusNode();

  String eventName = "";
  String eventDesc = "";
  String date = "";
  String startTime = "";
  String endTime = "";
  String totalParticipant = "";
  String additionalNote = "";
  String repeatValue = 'NONE';
  List invitedGuest = [];

  String roomName = "";
  String floor = "";

  final formKey = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  DateTime? selectedDate = DateTime.now();
  DateTime? selectedRepeatDate = DateTime.now();

  DateRangePickerController datePickerControl = DateRangePickerController();
  DateRangePickerController repeatDatePickerControl =
      DateRangePickerController();

  List<String>? repeatItems = ['NONE', 'DAILY', 'WEEKLY', 'MONTHLY'];
  String repeatEnd = "";

  List<RadioModel>? listEventType = [];
  String? selectedEventType = "";

  List<Amenities> listAmenities = [];
  List<FoodAmenities> listFoods = [];
  List roomDetail = [];
  List resultPicture = [];
  List resultAmenities = [];
  List resultFoodAmenities = [];

  bool timeContainerActive = false;
  bool datePickerVisible = false;
  bool datePickerRepeatVisible = false;
  bool layoutSectionVisible = false;
  bool repeatSectionVisible = true;

  DateTime dateRefresh = DateTime.now();
  String areaRefresh = "";
  List dataRoomRefresh = [];
  List eventRoomRefresh = [];

  bool pictureLoading = true;

  Future getBookingListRoom(String area, String date, MainModel model) async {
    model.events.appointments!.clear();
    var box = await Hive.openBox('userLogin');
    var jwt = box.get('jwTtoken') != "" ? box.get('jwtToken') : "";

    var url = Uri.https(
        apiUrlGlobal, '/MRBS_Backend/public/api/room/booking/list/$area');
    Map<String, String> requestHeader = {
      'Authorization': 'Bearer $jwt',
      // 'AppToken': 'mDMgDh4Eq9B0KRJLSOFI',
      'Content-Type': 'application/json',
    };
    var bodySend = """
  {
    "StartDate" : "$date",
    "EndDate" : "$date"
  }
  """;
    try {
      var response = await http.post(
        url,
        headers: requestHeader,
        body: bodySend,
      );

      var data = json.decode(response.body);
      // print(data);

      // List dataRoom = data['Data'];
      // int length = dataRoom.length;
      // print(dataRoom);
      // roomEvents.clear();
      // for (var i = 0; i < length; i++) {
      //   List eventRoom = dataRoom[i]['Bookings'];
      //   if (eventRoom.isEmpty) {
      //     break;
      //   }
      //   for (var j = 0; j < eventRoom.length; j++) {
      //     roomEvents.add(
      //       Appointment(
      //         // subject: ,
      //         resourceIds: [dataRoom[i]['RoomID']],
      //         startTime: DateTime.parse(eventRoom[j]['StartDateTime']),
      //         endTime: DateTime.parse(eventRoom[j]['EndDateTime']),
      //       ),
      //     );
      //   }
      // }
      return data;
    } on Error catch (e) {
      return e;
    }
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
    getBookingListRoom(model.selectedArea, model.selectedDate, model)
        .then((value) {
      model.setEvents(value['Data'], model.dataRoom, model.eventRoom);
    });
  }

  setDatePickerStatus(bool value) {
    setState(() {
      datePickerVisible = value;
      datePickerRepeatVisible = value;
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

  DateTime today = DateTime.now();

  List<DropdownMenuItem<String>> addDividerItem(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
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
            DropdownMenuItem<String>(
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
    setState(() {
      for (var i = 0; i < resultAmenities.length; i++) {
        for (var j = 0; j < value.length; j++) {
          if (resultAmenities[i]['AmenitiesID'] == value[j].amenitiesId) {
            resultAmenities[i]['Default'] = value[j].qty;
          }
        }
      }
      listAmenities = value;
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
    getRoomDetail(widget.roomId!).then((value) {
      setState(() {
        pictureLoading = false;
        print(value['Data']);
        // roomDetail = [value['Data']];
        // roomDetail = temp;
        roomName = value['Data']['RoomName'];
        floor = value['Data']['AreaName'];
        resultAmenities = value['Data']['Amenities'];
        // resultAmenities.add(value['Data']['Amenities'][0]);
        // resultAmenities = amen;
        resultFoodAmenities = value['Data']['FoodAmenities'];
        resultPicture = value['Data']['Photos'];
        String formattedDate =
            DateFormat('d MMM yyyy').format(DateTime.parse(widget.date!));
        _date.text = formattedDate;
        // _date.text = widget.date!;
        startTime = widget.startTime!;
        endTime = widget.endTime!;
        _startTime.text = widget.startTime!;
        _endTime.text = widget.endTime!;
        _repeatEnd.text = DateFormat('d MMM yyyy').format(DateTime.now());
        _totalParticipant.text = widget.participant!;
        if (widget.roomType != 'MeetingRoom') {
          layoutSectionVisible = true;
          repeatSectionVisible = false;
        }
        if (widget.facilities != "[]") {
          print('widget facilities');
          print(widget.facilities!);

          for (var element in widget.facilities!) {
            if (element['Amount'] > 0) {
              listAmenities.add(Amenities(
                amenitiesId: element['AmenitiesID'],
                amenitiesName: element['AmenitiesName'],
                photo: element['ImageURL'],
                qty: element['Amount'],
              ));
            }
          }
          for (var element in widget.foodAmenities!) {
            if (element['Amount'] > 0) {
              listFoods.add(FoodAmenities(
                amenitiesId: element['AmenitiesID'],
                amenitiesName: element['AmenitiesName'],
                photo: element['ImageURL'],
                qty: element['Amount'],
              ));
            }
          }
        }

        // listEventType!.add(RadioModel(isSelected: false, text: 'Internal'));
        // listEventType!.add(RadioModel(isSelected: false, text: 'External'));
        getMeetingType().then((value) {
          print(value['Data']);
          List result = value['Data'];

          for (var element in result) {
            setState(() {
              listEventType!.add(
                RadioModel(
                  isSelected: false,
                  text: element['Name'],
                  value: element['Value'],
                ),
              );
            });
          }
          selectedEventType = value['Data'][0]['Value'];
          // print(listEventType);
        });
      });
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
    emailNode.addListener(() {
      setState(() {});
    });
    additionalNoteNode.addListener(() {
      setState(() {});
    });
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      child: Stack(
        children: [
          SingleChildScrollView(
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
                                        validator: (value) => value == ""
                                            ? 'This field is required'
                                            : null,
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
                                        maxLines: 4,
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
                                          ),
                                        ).then((value) {
                                          print(startTime);
                                        });
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
                                                  setEndTime: setEndTime,
                                                  selectedDate: selectedDate,
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
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: BlackInputField(
                                            controller: _totalParticipant,
                                            focusNode: totalParticipantNode,
                                            onSaved: (newValue) {
                                              totalParticipant = newValue!;
                                            },
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
                                            child: SizedBox(
                                              // width: 100,
                                              child: BlackInputField(
                                                controller: _email,
                                                focusNode: emailNode,
                                                enabled: true,
                                                hintText: 'Email here..',
                                                obsecureText: false,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (_email.text != "") {
                                                invitedGuest.add(_email.text);
                                                setState(() {});
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
                                              padding: index <
                                                      invitedGuest.length - 1
                                                  ? const EdgeInsets.only(
                                                      bottom: 7)
                                                  : const EdgeInsets.only(
                                                      bottom: 2),
                                              child: Chip(
                                                label:
                                                    Text(invitedGuest[index]),
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
                                                      BorderRadius.circular(
                                                          7.5),
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
                                        height: 30,
                                        // color: Colors.amber,
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
                                    visible: repeatSectionVisible,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              items:
                                                  addDividerItem(repeatItems!),
                                              enabled: true,
                                              hintText: '',
                                              onChanged: (value) {
                                                repeatValue = value;
                                              },
                                              value: repeatValue,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Visibility(
                                          visible: repeatValue == "NONE"
                                              ? false
                                              : true,
                                          child: inputField(
                                            'Repeat End:',
                                            InkWell(
                                              onTap: () {
                                                if (datePickerRepeatVisible) {
                                                  setDatePickerRepeatVisible(
                                                      false);
                                                } else {
                                                  setDatePickerRepeatVisible(
                                                      true);
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
                                  const Divider(
                                    color: spanishGray,
                                    thickness: 0.5,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  foodSection(),
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
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  RegularButton(
                                    text: 'Book This Room',
                                    disabled: false,
                                    padding: ButtonSize().longSize(),
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        Booking booking = Booking();
                                        booking.roomId = widget.roomId;
                                        booking.summary = eventName;
                                        booking.description = eventDesc;
                                        booking.startDate = DateTime.parse(
                                            "${widget.date} $startTime:00");
                                        booking.endDate = DateTime.parse(
                                            "${widget.date} $endTime:00");
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

                                        booking.amenities = tempAmen;
                                        booking.foodAmenities = tempFood;
                                        booking.recursive = repeatValue;
                                        booking.attendantsNumber =
                                            totalParticipant;
                                        booking.attendants = tempGuest;
                                        booking.meetingType = selectedEventType;
                                        booking.repeatInterval = 0;
                                        booking.repeatEndDate =
                                            DateFormat('yyyy-M-dd')
                                                .format(selectedRepeatDate!);
                                        // _repeatEnd.text;

                                        debugPrint(booking.toJson().toString());
                                        print(booking.toJson());
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

                                        // forRefreshCalendar();
                                        // print('Selected Area -> $areaRefresh');
                                        // print('Selected Date -> $dateRefresh');
                                        // print('Data Room -> $dataRoomRefresh');
                                        // print('Event Room -> $eventRoomRefresh');
                                        //Booking Function
                                        bookingRoom(booking).then((value) {
                                          print(value);
                                          if (value['Status'] == "200") {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialogBlack(
                                                      title: value['Title'],
                                                      contentText:
                                                          value['Message']),
                                            ).then((value) {
                                              // updateEvent(model).then((value) {
                                              //   context.go('/rooms');
                                              // });
                                              // context.go('/rooms');
                                              Navigator.of(context).pop();
                                              // Navigator.of(context).pop();
                                            });
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertDialogBlack(
                                                title: value['Title'],
                                                contentText: value['Message'],
                                                isSuccess: false,
                                              ),
                                            ).then((value) {
                                              // context.go('/rooms');
                                            });
                                          }
                                          // context.pop();
                                        }).onError((error, stackTrace) {
                                          print(error);
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const AlertDialogBlack(
                                              title: 'Failed',
                                              contentText:
                                                  'Failed connect to API',
                                              isSuccess: false,
                                            ),
                                          ).then((value) {
                                            // context.go('/rooms');
                                          });
                                        });
                                        //END BOOOKING FUNCTION

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
                        visible: datePickerVisible,
                        child: Positioned(
                          top: 275,
                          right: 125,
                          child: CustomDatePicker(
                            controller: datePickerControl,
                            currentDate: selectedDate,
                            changeDate: setDate,
                            setPickerStatus: setDatePickerVisible,
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
          Positioned(
            // top:  model.isScrollAtEdge ? null : model.scrollPosition + 20,
            // bottom: model.isScrollAtEdge ? 0 : null,
            top: 85,
            left: MediaQuery.of(context).size.width <= 1366 ? 50 : 50,
            child: pictureLoading
                ? const SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      color: eerieBlack,
                    ),
                  )
                : BookingRoomPicture(
                    pictures: resultPicture,
                    name: roomName,
                    area: floor,
                  ),
          ),
        ],
      ),
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
                    if (resultAmenities[i]['AmenitiesID'] ==
                        listAmenities[index].amenitiesId) {
                      resultAmenities[i]['Default'] = 0;
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
        const Text(
          'Food & Beverages',
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
              listFOod: listFoods[index],
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
              builder: (context) => SelectLayoutDialog(),
            );
          },
          child: DottedBorder(
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
          ),
        ),
      ],
    );
  }
}
