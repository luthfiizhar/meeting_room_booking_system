import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class SearchContainer extends StatelessWidget {
  SearchContainer({
    super.key,
    this.dateNode,
    this.setPickerStatus,
    this.setAmenitiesStatus,
    this.setParticipantStatus,
    this.getPositionDatePicker,
    this.getPositionAmenities,
    this.getPositionparticipant,
    this.pickerStatus,
    this.amenitiesStatus,
    this.participantStatus,
    this.dateController,
    this.facilityController,
    this.timeController,
    this.participantController,
  });

  FocusNode? dateNode;
  TextEditingController? dateController;
  TextEditingController? facilityController;
  TextEditingController? timeController;
  TextEditingController? participantController;
  Function? setPickerStatus;
  Function? setAmenitiesStatus;
  Function? setParticipantStatus;
  Function? getPositionDatePicker;
  Function? getPositionAmenities;
  Function? getPositionparticipant;
  bool? pickerStatus;
  bool? amenitiesStatus;
  bool? participantStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: 1000,
      decoration: BoxDecoration(
        color: culturedWhite,
        borderRadius: BorderRadius.circular(10),
      ),
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
                  } else {
                    getPositionDatePicker!();
                    setAmenitiesStatus!(false);
                    setParticipantStatus!(false);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    right: 30,
                  ),
                  // color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.amber,
                        child: Row(
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
                          mouseCursor: SystemMouseCursors.click,
                          enabled: false,
                          onTap: () {},
                          // focusNode: dateNode,
                          controller: dateController,
                          style: const TextStyle(
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
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 25,
                    right: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.amber,
                        child: Row(
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
                      TextFormField(
                        mouseCursor: SystemMouseCursors.click,
                        enabled: false,
                        controller: timeController,
                        style: const TextStyle(
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
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (participantStatus!) {
                    setParticipantStatus!(false);
                  } else {
                    getPositionparticipant!();
                    setAmenitiesStatus!(false);
                    setPickerStatus!(false);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    right: 20,
                    top: 8,
                    left: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: Colors.amber,
                        child: Row(
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
                        // width: 120,
                        child: TextFormField(
                          mouseCursor: SystemMouseCursors.click,
                          enabled: false,
                          // onTap: () {},
                          controller: participantController,
                          style: const TextStyle(
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
                  } else {
                    getPositionAmenities!();
                    setPickerStatus!(false);
                    setParticipantStatus!(false);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    left: 25,
                    right: 10,
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
                          mouseCursor: SystemMouseCursors.click,
                          controller: facilityController,
                          enabled: false,
                          style: const TextStyle(
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
              width: 50,
            ),
            SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return eerieBlack;
                    },
                  ),
                ),
                child: const Icon(
                  MdiIcons.magnify,
                  color: culturedWhite,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
