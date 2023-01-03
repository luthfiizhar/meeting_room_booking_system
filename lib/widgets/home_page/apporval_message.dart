import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';

class ApprovalMessage extends StatefulWidget {
  ApprovalMessage({super.key});

  @override
  State<ApprovalMessage> createState() => _ApprovalMessageState();
}

class _ApprovalMessageState extends State<ApprovalMessage> {
  ReqAPI apiReq = ReqAPI();
  String countApproval = "";

  @override
  void initState() {
    super.initState();
    apiReq.approvalListBookingCount().then((value) {
      print(value);
      if (value['Status'].toString() == "200") {
        List result = value['Data'];
        result =
            result.where((element) => element['Title'] == 'Requested').toList();
        setState(() {
          countApproval = result.first['Count'].toString();
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
        minWidth: 350,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: platinum,
            width: 1,
          ),
          color: white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              countApproval,
              style: helveticaText.copyWith(
                color: orangeAccent,
                fontWeight: FontWeight.w700,
                fontSize: 64,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Total request to approve',
              style: helveticaText.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: TransparentBorderedBlackButton(
                      text: 'Check',
                      disabled: false,
                      onTap: () {
                        context.goNamed('admin_list');
                      },
                      fontWeight: FontWeight.w700,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
