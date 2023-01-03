import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
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
  ReqAPI apiReq = ReqAPI();
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
  String bookingStep = "";

  @override
  void initState() {
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
    floor = widget.bookingDetail!.floor;
    eventTime = widget.bookingDetail!.eventTime;
    eventDate = widget.bookingDetail!.eventDate;
    duration = widget.bookingDetail!.duration;
    host = widget.bookingDetail!.host;
    email = widget.bookingDetail!.email;
    avaya = widget.bookingDetail!.avaya;
    bookingStep = widget.bookingDetail!.stepBooking;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 500,
      ),
      child: Container(
        width: 350,
        decoration: const BoxDecoration(
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      eventName,
                      style: helveticaText.copyWith(
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
                      floor,
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
                    Text(
                      'User Info',
                      style: helveticaText.copyWith(
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
                    rowDetailEmail(
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
                                'eventId': widget.bookingDetail!.bookingId,
                              });
                            },
                            tooltip: 'Detail Info',
                          ),
                          // IconButton(
                          //   icon: const Icon(
                          //     MdiIcons.emailOutline,
                          //     color: blueAccent,
                          //     size: 26,
                          //   ),
                          //   onPressed: () {},
                          //   tooltip: 'Email',
                          // ),
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.sync_alt,
                          //     color: blueAccent,
                          //     size: 26,
                          //   ),
                          //   onPressed: () {},
                          //   tooltip: 'Trade',
                          // ),
                          Visibility(
                            visible: bookingStep == "3" || bookingStep == "4"
                                ? false
                                : true,
                            child: IconButton(
                              icon: const Icon(
                                MdiIcons.closeCircleOutline,
                                color: blueAccent,
                                size: 26,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      const ConfirmDialogBlack(
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
                                      apiReq
                                          .deleteBooking(
                                              widget.event!.bookingID!)
                                          .then((value) {
                                        // print(value);
                                        setState(() {
                                          // isCancelLoading = false;
                                        });
                                        if (value['Status'] == "200") {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialogBlack(
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
                                          builder: (context) =>
                                              AlertDialogBlack(
                                            title: 'Failed connect to API',
                                            contentText: error.toString(),
                                            isSuccess: false,
                                          ),
                                        );
                                      });
                                    }
                                    if (bookingType == "RECURRENT") {
                                      apiReq
                                          .deleteBookingRecurrent(
                                              widget.event!.bookingID!)
                                          .then((value) {
                                        // print(value);
                                        if (value['Status'] == "200") {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AlertDialogBlack(
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
                                          builder: (context) =>
                                              AlertDialogBlack(
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
                  icon: const Icon(
                    Icons.close_sharp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowDetailEmail(String label, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
            ),
          ),
        ),
        Expanded(
            child: Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            children: [
              InkWell(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                        'Email copied.',
                        maxLines: 1,
                      ),
                    ),
                  );
                },
                child: Text(
                  content,
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: davysGray,
                  ),
                  textAlign: TextAlign.right,
                  // textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        )),
      ],
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
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
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
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
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
