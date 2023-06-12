import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';

class PhoneReminderDialog extends StatefulWidget {
  const PhoneReminderDialog({super.key});

  @override
  State<PhoneReminderDialog> createState() => _PhoneReminderDialogState();
}

class _PhoneReminderDialogState extends State<PhoneReminderDialog> {
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
            minWidth: 1000, maxWidth: 1000, maxHeight: 600, minHeight: 600),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: graySand,
                image: DecorationImage(
                  image: Image.asset("assets/phone_reminder.png").image,
                  fit: BoxFit.contain,
                ),
              ),
              height: 600,
              width: 470,
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
                      "Reminder",
                      style: helveticaText.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Publish your phone number",
                      style: helveticaText.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: eerieBlack,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      message,
                      style: helveticaText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: davysGray,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: RegularButton(
                        text: "OK",
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          reqApi
                              .userEvents("PhoneBookingTutorial")
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
