import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';

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
                    ),
                  ),
                ),
                //DATE
                Expanded(
                  child: Text(
                    widget.date,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
                //LOCATION
                Expanded(
                  flex: 2,
                  child: Text(
                    widget.location,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
                //TIME
                Expanded(
                  child: Text(
                    widget.time,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
                //STATUS
                Expanded(
                  child: widget.status != "Approval"
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(builder: (context) {
                              switch (widget.status) {
                                case 'Checked In':
                                  return const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: greenAcent,
                                  );
                                case 'Checked Out':
                                  return const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: greenAcent,
                                  );
                                case 'Approved':
                                  return const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: greenAcent,
                                  );
                                case 'Impromptu':
                                  return const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: greenAcent,
                                  );
                                case 'Canceled':
                                  return const Icon(
                                    Icons.remove_circle_sharp,
                                    size: 16,
                                    color: orangeAccent,
                                  );
                                case 'Auto Released':
                                  return const Icon(
                                    Icons.remove_circle_sharp,
                                    size: 16,
                                    color: orangeAccent,
                                  );
                                case 'Declined':
                                  return const Icon(
                                    Icons.remove_circle_sharp,
                                    size: 16,
                                    color: orangeAccent,
                                  );
                                case 'Rejected':
                                  return const Icon(
                                    Icons.remove_circle_sharp,
                                    size: 16,
                                    color: orangeAccent,
                                  );
                                case 'Waiting Check In':
                                  return const Icon(
                                    MdiIcons.alertCircleOutline,
                                    size: 16,
                                    color: orangeAccent,
                                  );
                                case 'Waiting Approval':
                                  return const Icon(
                                    MdiIcons.alertCircleOutline,
                                    size: 16,
                                    color: orangeAccent,
                                  );
                                default:
                                  return const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: greenAcent,
                                  );
                              }
                            }),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.status,
                              style: helveticaText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                                height: 1.3,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                approveAuditorium(widget.bookingId)
                                    .then((value) {
                                  if (value['Status'] == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                        isSuccess: true,
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
                                      title: 'Can\'t connect to API',
                                      contentText: error.toString(),
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              },
                              child: const Icon(
                                Icons.check_circle,
                                size: 20,
                                color: greenAcent,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                rejectAuditorium(widget.bookingId)
                                    .then((value) {
                                  if (value['Status'] == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                        isSuccess: true,
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
                                      title: 'Can\'t connect to API',
                                      contentText: error.toString(),
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              },
                              child: const Icon(
                                Icons.remove_circle_sharp,
                                size: 20,
                                color: orangeAccent,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            )
                          ],
                        ),
                ),
                InkWell(
                  onTap: () {
                    context.goNamed(
                      'detail_approval',
                      params: {
                        'eventId': widget.bookingId,
                      },
                    );
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
