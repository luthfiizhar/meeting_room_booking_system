import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/widgets/button/search_page_button.dart';
import 'package:provider/provider.dart';

class SearchContainer extends StatelessWidget {
  SearchContainer({
    super.key,
    this.dateNode,
    this.setPickerStatus,
    this.setAmenitiesStatus,
    this.setParticipantStatus,
    this.setTimeStatus,
    this.setStartTimeStatus,
    this.setEndTimeStatus,
    this.setOpacityOn,
    this.getPositionDatePicker,
    this.getPositionAmenities,
    this.getPositionparticipant,
    this.pickerStatus,
    this.amenitiesStatus,
    this.participantStatus,
    this.timePickerStatus,
    this.dateController,
    this.facilityController,
    this.timeController,
    this.participantController,
    this.meetingTypeStatus,
    this.setMeetingTypeStatus,
    this.meetingTypeSelected,
    this.amenitiesKey,
    this.dateKey,
    this.meetingTypeKey,
    this.participantKey,
    this.timeKey,
    this.datakey,
    this.searchRoom,
    this.meetingTypeName,
  });

  FocusNode? dateNode;
  TextEditingController? dateController;
  TextEditingController? facilityController;
  TextEditingController? timeController;
  TextEditingController? participantController;
  Function? setPickerStatus;
  Function? setAmenitiesStatus;
  Function? setParticipantStatus;
  Function? setTimeStatus;
  Function? setStartTimeStatus;
  Function? setEndTimeStatus;
  Function? setMeetingTypeStatus;
  Function? setOpacityOn;
  Function? getPositionDatePicker;
  Function? getPositionAmenities;
  Function? getPositionparticipant;
  Function? searchRoom;
  bool? pickerStatus;
  bool? amenitiesStatus;
  bool? participantStatus;
  bool? timePickerStatus;
  bool? meetingTypeStatus;
  String? meetingTypeSelected;
  String? meetingTypeName;
  GlobalKey? dateKey;
  GlobalKey? timeKey;
  GlobalKey? participantKey;
  GlobalKey? amenitiesKey;
  GlobalKey? meetingTypeKey;
  GlobalKey? datakey;

  Future autoScroll(BuildContext context) async {
    Provider.of<MainModel>(context, listen: false).setAutoScrollSearch(true);
    // Scrollable.ensureVisible(
    //   datakey!.currentContext!,
    //   duration: Duration(seconds: 1),
    //   curve: Curves.easeInOut,
    // );
  }

  Future autoScrollOff(BuildContext context) async {
    Provider.of<MainModel>(context, listen: false).setAutoScrollSearch(false);
  }

  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  if (meetingTypeStatus!) {
                    setMeetingTypeStatus!(false);
                    setOpacityOn!(false);
                  } else {
                    setMeetingTypeStatus!(true);
                    setOpacityOn!(true);
                    setPickerStatus!(false);
                    setAmenitiesStatus!(false);
                    setParticipantStatus!(false);
                    setTimeStatus!(false);
                    setStartTimeStatus!(false);
                    setEndTimeStatus!(false);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  width: 320,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: eerieBlack,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    key: meetingTypeKey,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: [
                          const Text(
                            'Area Type:',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Helvetica',
                              color: culturedWhite,
                              height: 1.3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            meetingTypeName!,
                            style: const TextStyle(
                              fontFamily: 'Helvetica',
                              fontSize: 20,
                              height: 1.3,
                              color: culturedWhite,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            MdiIcons.chevronDown,
                            size: 23,
                            color: culturedWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 125,
              width: 1000,
              decoration: BoxDecoration(
                  color: culturedWhite,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: lightGray,
                    width: 1,
                  )),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 23,
                  horizontal: 40,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        // mouseCursor: SystemMouseCursors.click,
                        onTap: () {
                          if (pickerStatus!) {
                            setPickerStatus!(false);
                            setOpacityOn!(false);
                          } else {
                            // getPositionDatePicker!();
                            setPickerStatus!(true);
                            setOpacityOn!(true);
                            setAmenitiesStatus!(false);
                            setParticipantStatus!(false);
                            setTimeStatus!(false);
                            setStartTimeStatus!(false);
                            setEndTimeStatus!(false);
                            setMeetingTypeStatus!(false);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 8,
                            right: 20,
                          ),
                          // color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    MdiIcons.calendarMonth,
                                    size: 18,
                                    color: davysGray,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                      ),
                                      // color: Colors.green,
                                      child: const Text(
                                        'Date',
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: davysGray,
                                          // height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              Container(
                                // color: Colors.amber,
                                // width: 140,
                                child: TextFormField(
                                  key: dateKey,
                                  mouseCursor: SystemMouseCursors.click,
                                  enabled: false,
                                  onTap: () {},
                                  onSaved: (value) {},
                                  // focusNode: dateNode,
                                  controller: dateController,
                                  style: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    height: 1.3,
                                    color: davysGray,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    // isCollapsed: true,
                                    suffixIconConstraints: BoxConstraints(
                                      minWidth: 10,
                                      maxWidth: 24,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 24,
                                      color: eerieBlack,
                                    ),
                                    // contentPadding: EdgeInsets.only(
                                    //   top: 17,
                                    //   bottom: 15,
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: davysGray,
                      thickness: 0.5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (timePickerStatus!) {
                          setTimeStatus!(false);
                          setStartTimeStatus!(false);
                          setEndTimeStatus!(false);
                          setOpacityOn!(false);
                        } else {
                          // getPositionDatePicker!();
                          setPickerStatus!(false);
                          setAmenitiesStatus!(false);
                          setParticipantStatus!(false);
                          setTimeStatus!(true);
                          setOpacityOn!(true);
                          setStartTimeStatus!(false);
                          setEndTimeStatus!(false);
                          setMeetingTypeStatus!(false);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 25,
                          right: 15,
                        ),
                        child: Container(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    MdiIcons.alarm,
                                    size: 18,
                                    color: davysGray,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                      ),
                                      // color: Colors.green,
                                      child: const Text(
                                        'Time',
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: davysGray,
                                          // height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              TextFormField(
                                key: timeKey,
                                mouseCursor: SystemMouseCursors.click,
                                enabled: false,
                                controller: timeController,
                                style: const TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  height: 1.3,
                                  color: davysGray,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    right: 5,
                                  ),
                                  // isCollapsed: true,
                                  suffixIconConstraints: BoxConstraints(
                                    minWidth: 10,
                                    maxWidth: 24,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 24,
                                    color: eerieBlack,
                                  ),
                                  // contentPadding: EdgeInsets.only(
                                  //   top: 17,
                                  //   bottom: 15,
                                  // ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: davysGray,
                      thickness: 0.5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (participantStatus!) {
                          setParticipantStatus!(false);
                          setOpacityOn!(false);
                        } else {
                          // getPositionparticipant!();
                          setParticipantStatus!(true);
                          setOpacityOn!(true);
                          setAmenitiesStatus!(false);
                          setPickerStatus!(false);
                          setTimeStatus!(false);
                          setStartTimeStatus!(false);
                          setEndTimeStatus!(false);
                          setMeetingTypeStatus!(false);
                        }
                      },
                      child: Container(
                        // width: 180,
                        padding: const EdgeInsets.only(
                          top: 8,
                          right: 15,
                          left: 25,
                        ),
                        child: Container(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    MdiIcons.accountMultipleOutline,
                                    size: 18,
                                    color: davysGray,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                      ),
                                      // color: Colors.green,
                                      child: const Text(
                                        'Participant',
                                        style: TextStyle(
                                          fontFamily: 'Helvetica',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: davysGray,
                                          // height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              SizedBox(
                                // width: 120,
                                child: TextFormField(
                                  key: participantKey,
                                  mouseCursor: SystemMouseCursors.click,
                                  enabled: false,
                                  // onTap: () {},
                                  controller: participantController,
                                  style: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    height: 1.3,
                                    color: davysGray,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    // isCollapsed: true,
                                    suffixIconConstraints: BoxConstraints(
                                      minWidth: 10,
                                      maxWidth: 24,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 24,
                                      color: eerieBlack,
                                    ),
                                    // contentPadding: EdgeInsets.only(
                                    //   top: 17,
                                    //   bottom: 15,
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: davysGray,
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: GestureDetector(
                        // mouseCursor: SystemMouseCursors.click,
                        onTap: () {
                          if (amenitiesStatus!) {
                            setAmenitiesStatus!(false);
                            setOpacityOn!(false);
                          } else {
                            // getPositionAmenities!();
                            setAmenitiesStatus!(true);
                            setOpacityOn!(true);
                            setPickerStatus!(false);
                            setParticipantStatus!(false);
                            setTimeStatus!(false);
                            setStartTimeStatus!(false);
                            setEndTimeStatus!(false);
                            setMeetingTypeStatus!(false);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 25,
                            right: 2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // color: Colors.amber,

                                child: Row(
                                  children: [
                                    const Icon(
                                      FontAwesomeIcons.tv,
                                      size: 14,
                                      color: davysGray,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                        ),
                                        // color: Colors.green,
                                        child: const Text(
                                          'Facility',
                                          style: TextStyle(
                                            fontFamily: 'Helvetica',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: davysGray,
                                            // height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 0,
                              ),
                              SizedBox(
                                // width: 140,
                                child: TextFormField(
                                  key: amenitiesKey,
                                  mouseCursor: SystemMouseCursors.click,
                                  controller: facilityController,
                                  enabled: false,
                                  style: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    height: 1.3,
                                    color: davysGray,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      right: 5,
                                    ),
                                    // isCollapsed: true,
                                    suffixIconConstraints: BoxConstraints(
                                      minWidth: 10,
                                      maxWidth: 24,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down_sharp,
                                      size: 24,
                                      color: eerieBlack,
                                    ),
                                    // contentPadding: EdgeInsets.only(
                                    //   top: 17,
                                    //   bottom: 15,
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        width: 60,
                        height: 60,
                        child: SearchPageButton(
                          onTap: () {
                            setAmenitiesStatus!(false);
                            setPickerStatus!(false);
                            setParticipantStatus!(false);
                            setTimeStatus!(false);
                            setStartTimeStatus!(false);
                            setEndTimeStatus!(false);
                            setMeetingTypeStatus!(false);
                            // Provider.of<MainModel>(context, listen: false)
                            //     .layoutController
                            //     .animateTo(
                            //       30,
                            //       duration: Duration(seconds: 1),
                            //       curve: Curves.fastOutSlowIn,
                            //     );
                            autoScroll(context).then((value) {
                              // Future.delayed(const Duration(seconds: 2));
                              // autoScrollOff(context);
                              searchRoom!();
                            });
                          },
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
