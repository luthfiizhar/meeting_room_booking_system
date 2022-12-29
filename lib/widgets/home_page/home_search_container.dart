import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/search_page_button.dart';
import 'package:shimmer/shimmer.dart';

class HomeRoomSearchContainer extends StatefulWidget {
  HomeRoomSearchContainer({
    super.key,
    this.dateController,
    this.participantController,
    this.timeController,
    this.facilityController,
    this.setDatePickerStatus,
    this.datePickerStatus,
    this.timePickerStatus,
    this.setTimeContainerStatus,
    this.setParticipantStatus,
    this.participantStatus,
    this.setAmenitiesStatus,
    this.amenitiesStatus,
    this.meetingTypeStatus,
    this.roomTypeName,
    this.roomTypeSelected,
    this.setMeetingTypeStatus,
    this.roomTypeUrl,
    this.searchRoom,
    this.initLoading = true,
  });

  TextEditingController? dateController;
  TextEditingController? facilityController;
  TextEditingController? timeController;
  TextEditingController? participantController;
  Function? setDatePickerStatus;
  Function? setAmenitiesStatus;
  Function? setParticipantStatus;
  Function? setTimeContainerStatus;
  Function? setStartTimeStatus;
  Function? setEndTimeStatus;
  Function? setMeetingTypeStatus;
  Function? setOpacityOn;
  Function? searchRoom;
  bool? datePickerStatus;
  bool? amenitiesStatus;
  bool? participantStatus;
  bool? timePickerStatus;
  bool? meetingTypeStatus;
  String? roomTypeSelected;
  String? roomTypeName;
  String? roomTypeUrl;
  bool initLoading;

  @override
  State<HomeRoomSearchContainer> createState() =>
      _HomeRoomSearchContainerState();
}

class _HomeRoomSearchContainerState extends State<HomeRoomSearchContainer> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // constraints: const BoxConstraints(
      //   maxWidth: 780,
      //   minWidth: 780,
      //   maxHeight: 200,
      //   minHeight: 200,
      // ),
      constraints: homeLeftSideConstrains,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 25,
        ),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platinum,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //COL 1
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Room Search',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack,
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                InkWell(
                  onTap: () {
                    if (widget.meetingTypeStatus!) {
                      widget.setMeetingTypeStatus!(false);
                    } else {
                      widget.setMeetingTypeStatus!(true);
                    }
                  },
                  child: widget.initLoading
                      ? Shimmer(
                          gradient: const LinearGradient(
                            colors: [platinum, grayx11, davysGray],
                          ),
                          direction: ShimmerDirection.rtl,
                          child: Container(
                            width: 175,
                            height: 112,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: widget.roomTypeUrl == ""
                                ? const SizedBox()
                                : CachedNetworkImage(
                                    imageUrl: widget.roomTypeUrl!,
                                    placeholder: (context, url) {
                                      return const SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(
                                          color: eerieBlack,
                                        ),
                                      );
                                    },
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: 175,
                                        height: 112,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            opacity: 0.4,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        )
                      : Container(
                          width: 175,
                          height: 112,
                          decoration: BoxDecoration(
                            color: eerieBlack,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.roomTypeUrl!,
                            placeholder: (context, url) {
                              return const SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  color: eerieBlack,
                                ),
                              );
                            },
                            imageBuilder: (context, imageProvider) {
                              return Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                      left: 15,
                                      right: 15,
                                    ),
                                    width: 175,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        // opacity: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 12,
                                      left: 15,
                                      right: 15,
                                    ),
                                    width: 175,
                                    height: 112,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: eerieBlack.withOpacity(0.4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type',
                                          style: helveticaText.copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: culturedWhite,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.roomTypeName!,
                                              style: helveticaText.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18,
                                                color: culturedWhite,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              size: 20,
                                              color: culturedWhite,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
            //END COL 1

            //COL 2
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7,
                ),
                inputField(
                  InkWell(
                    onTap: () {
                      if (widget.datePickerStatus!) {
                        widget.setDatePickerStatus!(false);
                      } else {
                        widget.setDatePickerStatus!(true);
                      }
                    },
                    child: SizedBox(
                      width: 145,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InputFieldSearchPage(
                              controller: widget.dateController,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 16,
                            color: davysGray,
                          ),
                        ],
                      ),
                    ),
                  ),
                  'Date',
                ),
                const SizedBox(
                  height: 30,
                ),
                inputField(
                  InkWell(
                    onTap: () {
                      if (widget.participantStatus!) {
                        widget.setParticipantStatus!(false);
                      } else {
                        widget.setParticipantStatus!(true);
                      }
                    },
                    child: SizedBox(
                      width: 70,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InputFieldSearchPage(
                              controller: widget.participantController,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 16,
                            color: davysGray,
                          ),
                        ],
                      ),
                    ),
                  ),
                  'Person',
                )
              ],
            ),
            //END COL 2

            //COL 3
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 7,
                ),
                inputField(
                  InkWell(
                    onTap: () {
                      if (widget.timePickerStatus!) {
                        widget.setTimeContainerStatus!(false);
                      } else {
                        widget.setTimeContainerStatus!(true);
                      }
                    },
                    child: SizedBox(
                      width: 155,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InputFieldSearchPage(
                              controller: widget.timeController,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 16,
                            color: davysGray,
                          ),
                        ],
                      ),
                    ),
                  ),
                  'Time',
                ),
                const SizedBox(
                  height: 30,
                ),
                inputField(
                  InkWell(
                    onTap: () {
                      if (widget.amenitiesStatus!) {
                        widget.setAmenitiesStatus!(false);
                      } else {
                        widget.setAmenitiesStatus!(true);
                      }
                    },
                    child: SizedBox(
                      width: 145,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InputFieldSearchPage(
                              controller: widget.facilityController,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 16,
                            color: davysGray,
                          ),
                        ],
                      ),
                    ),
                  ),
                  'Facility',
                )
              ],
            ),
            //END COL 3

            //COL 4
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: SearchPageButton(
                    onTap: () {
                      widget.searchRoom!();
                    },
                  ),
                ),
              ],
            )
            //END COL 4
          ],
        ),
      ),
    );
  }

  Widget inputField(
    Widget inputField,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputField,
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
        )
      ],
    );
  }
}

class InputFieldSearchPage extends StatelessWidget {
  InputFieldSearchPage({super.key, this.controller});

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      mouseCursor: SystemMouseCursors.click,
      enabled: false,
      onTap: () {},
      onSaved: (value) {},
      controller: controller,
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
        // suffixIcon: Container(
        //   color: Colors.amber,
        //   child: Icon(
        //     Icons.keyboard_arrow_down_sharp,
        //     size: 24,
        //     color: eerieBlack,
        //   ),
        // ),
        isCollapsed: true,
        isDense: false,
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
    );
  }
}
