import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';

class ScrollReminder extends StatefulWidget {
  const ScrollReminder({super.key});

  @override
  State<ScrollReminder> createState() => _ScrollReminderState();
}

class _ScrollReminderState extends State<ScrollReminder> {
  ReqAPI reqApi = ReqAPI();
  final String message =
      "Don’t forget to make your phone number available to public by checking this option when you create a room booking.\n\nThis could help people who wants to reach out about your booking.";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        constraints: const BoxConstraints(
            minWidth: 1100, maxWidth: 1100, maxHeight: 600, minHeight: 600),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: white,
              ),
              padding: const EdgeInsets.all(25),
              height: 600,
              width: 600,
              child: Center(
                child: SizedBox(
                  child: Image.asset(
                    "assets/scroll_reminder.gif",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Guide",
                      style: helveticaText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: davysGray,
                      ),
                    ),
                    Text(
                      "Room Horizontal List Scroll",
                      style: helveticaText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 300,
                      height: 165,
                      child: Image.asset(
                        "assets/scroll_reminder3.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 13),
                      child: Divider(
                        color: lightGray,
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 165,
                      child: Image.asset(
                        "assets/scroll_reminder2.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RegularButton(
                        text: "OK",
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          reqApi
                              .userEvents("BookingScrollTutorial")
                              .then((value) {
                            if (value["Status"].toString() == "200") {
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialogBlack(
                                  title: value["Title"],
                                  contentText: value["Message"],
                                  isSuccess: false,
                                ),
                              );
                            }
                          }).onError((error, stackTrace) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialogBlack(
                                title: "Error userEvents",
                                contentText: error.toString(),
                                isSuccess: false,
                              ),
                            );
                          });
                        },
                      ),
                    )
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
