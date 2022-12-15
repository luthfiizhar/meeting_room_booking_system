import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/pages/user/rooms_page.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';

class DetailAppointmentContainer extends StatefulWidget {
  DetailAppointmentContainer({
    super.key,
    this.event,
    this.closeDetail,
    this.bookingDetail,
  });

  RoomEvent? event;
  String? floor;
  Function? closeDetail;
  BookingDetail? bookingDetail;

  @override
  State<DetailAppointmentContainer> createState() =>
      _DetailAppointmentContainerState();
}

class _DetailAppointmentContainerState
    extends State<DetailAppointmentContainer> {
  String eventName = "";
  String location = "";
  String floor = "";
  String eventTime = "";
  String eventDate = "";
  String duration = "";
  String host = "";
  String email = "";
  String avaya = "";
  String attendantsNumber = "";
  String bookingType = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.event!.bookingID!);
    // getBookingDetail(widget.event!.bookingID!).then((value) {
    //   print(value['Data']);
    //   setState(() {
    //     eventName = value['Data']['Summary'];
    //     attendantsNumber = value['Data']['AttendantsNumber'].toString();
    //     location = value['Data']['RoomName'];
    //     // floor = value['Data']['Room']
    //     eventTime =
    //         "${value['Data']['BookingStartTime']} - ${value['Data']['BookingEndTime']}";
    //     eventDate = value['Data']['BookingDate'];
    //     duration = value['Data']['Duration'];
    //     host = value['Data']['EmpName'];
    //   });
    // });
    eventName = widget.bookingDetail!.summary;
    attendantsNumber = widget.bookingDetail!.attendatsNumber;
    location = widget.bookingDetail!.location;
    // floor = value['Data']['Room']
    eventTime = widget.bookingDetail!.eventTime;
    eventDate = widget.bookingDetail!.eventDate;
    duration = widget.bookingDetail!.duration;
    host = widget.bookingDetail!.host;
    email = widget.bookingDetail!.email;
    avaya = widget.bookingDetail!.avaya;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: MediaQuery.of(context).size.height - 80,
      decoration: BoxDecoration(
        color: culturedWhite,
      ),
      child: SingleChildScrollView(
        primary: false,
        // physics: const PageScrollPhysics(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$eventName ($attendantsNumber Person)',
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  rowDetail(
                    'Location',
                    location,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    child: Divider(
                      color: lightGray,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Floor',
                    '2nd Floor',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    child: Divider(
                      color: lightGray,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Event Time',
                    eventTime,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    child: Divider(
                      color: lightGray,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Event Date',
                    eventDate,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    child: Divider(
                      color: lightGray,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Duration',
                    duration,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'User Info',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: blueAccent,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Divider(
                      color: blueAccent,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Host',
                    host,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    child: Divider(
                      color: lightGray,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Email',
                    email,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    child: Divider(
                      color: lightGray,
                      thickness: 0.5,
                    ),
                  ),
                  rowDetail(
                    'Avaya',
                    avaya,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            MdiIcons.informationOutline,
                            color: blueAccent,
                            size: 26,
                          ),
                          onPressed: () {
                            context.goNamed('detail_event', params: {
                              'eventId': widget.event!.bookingID!,
                            });
                          },
                          tooltip: 'Detail Info',
                        ),
                        IconButton(
                          icon: const Icon(
                            MdiIcons.emailOutline,
                            color: blueAccent,
                            size: 26,
                          ),
                          onPressed: () {},
                          tooltip: 'Email',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.sync_alt,
                            color: blueAccent,
                            size: 26,
                          ),
                          onPressed: () {},
                          tooltip: 'Trade',
                        ),
                        IconButton(
                          icon: const Icon(
                            MdiIcons.closeCircleOutline,
                            color: blueAccent,
                            size: 26,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ConfirmDialogBlack(
                                title: 'Cancel Booking',
                                contentText:
                                    'Are you sure want cancel this booking?',
                              ),
                            ).then((value) {
                              setState(() {
                                // isCancelLoading = true;
                              });
                              if (value) {
                                if (bookingType == "SINGLE") {
                                  deleteBooking(widget.event!.bookingID!)
                                      .then((value) {
                                    print(value);
                                    setState(() {
                                      // isCancelLoading = false;
                                    });
                                    if (value['Status'] == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                          title: value['Title'],
                                          contentText: value['Message'],
                                        ),
                                      ).then((value) {
                                        context.go('/rooms');
                                      });
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
                                }
                                if (bookingType == "RECURRENT") {
                                  deleteBookingRecurrent(
                                          widget.event!.bookingID!)
                                      .then((value) {
                                    print(value);
                                    if (value['Status'] == "200") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialogBlack(
                                          title: value['Title'],
                                          contentText: value['Message'],
                                        ),
                                      ).then((value) {
                                        context.go('/rooms');
                                      });
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
                                }
                              }
                            });
                          },
                          tooltip: 'Cancel',
                        ),
                      ],
                    ),
                  )
                  // Text(widget.event!.resourceIds![0].toString()),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                onPressed: () {
                  widget.closeDetail!();
                },
                icon: Icon(Icons.close_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowDetail(String label, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
              height: 1.3,
            ),
          ),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: [
              Text(
                content,
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
                  height: 1.3,
                ),
                textAlign: TextAlign.right,
                // textDirection: TextDirection.ltr,
              ),
            ],
          ),
        )),
      ],
    );
  }
}
