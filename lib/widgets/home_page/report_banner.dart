import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/bug_report_dialog.dart';

class ReportBanner extends StatelessWidget {
  ReportBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 350,
        maxWidth: 350,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: eerieBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'System Error?',
              style: helveticaText.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: white,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Bugs?',
              style: helveticaText.copyWith(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: orangeAccent,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Let us know!',
              style: helveticaText.copyWith(
                  fontSize: 20, fontWeight: FontWeight.w300, color: white),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TransparentBorderedWhiteButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    text: 'Report Now',
                    fontWeight: FontWeight.w700,
                    disabled: false,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const BugReportDialog(),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
