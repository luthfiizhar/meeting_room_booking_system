import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';

class DetailAppointmentContainer extends StatefulWidget {
  DetailAppointmentContainer({
    super.key,
    this.event,
    this.closeDetail,
  });

  RoomEvent? event;
  String? floor;
  Function? closeDetail;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.event!.bookingID!);
    getBookingDetail(widget.event!.bookingID!).then((value) {
      print(value['Data']);
      setState(() {
        eventName = value['Data']['Summary'];
        attendantsNumber = value['Data']['AttendantsNumber'].toString();
        location = value['Data']['RoomName'];
        // floor = value['Data']['Room']
        eventTime =
            "${value['Data']['BookingStartTime']} - ${value['Data']['BookingEndTime']}";
        eventDate = value['Data']['BookingDate'];
        duration = value['Data']['Duration'];
        host = value['Data']['EmpName'];
      });
    });
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
                          onPressed: () {},
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
