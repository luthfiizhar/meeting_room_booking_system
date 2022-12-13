import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class ApprovalListContainer extends StatefulWidget {
  ApprovalListContainer({
    super.key,
    this.index = 0,
    this.eventName = "",
    this.date = "",
    this.location = "",
    this.time = "",
    this.status = "",
    this.bookingId = "",
  });

  int index;
  String eventName;
  String date;
  String location;
  String time;
  String status;
  String bookingId;

  @override
  State<ApprovalListContainer> createState() => _ApprovalListContainerState();
}

class _ApprovalListContainerState extends State<ApprovalListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index != 0
            ? const Divider(
                color: grayx11,
                thickness: 0.5,
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(
            top: 17,
            bottom: 17,
          ),
          child: Container(
            child: Row(
              children: [
                //EVENT NAME
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.eventName,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                      height: 1.3,
                    ),
                  ),
                ),
                //DATE
                Expanded(
                  child: Text(
                    widget.date,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                      height: 1.3,
                    ),
                  ),
                ),
                //LOCATION
                Expanded(
                  child: Text(
                    widget.location,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                      height: 1.3,
                    ),
                  ),
                ),
                //TIME
                Expanded(
                  child: Text(
                    widget.time,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                      height: 1.3,
                    ),
                  ),
                ),
                //STATUS
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: greenAcent,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.status,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: davysGray,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.goNamed('detail_event', params: {
                      'eventId': widget.bookingId,
                    });
                  },
                  child: const SizedBox(
                    width: 20,
                    child: Icon(
                      Icons.chevron_right_sharp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
