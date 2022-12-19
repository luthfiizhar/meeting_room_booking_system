import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';

class BookingRoomDialog extends StatefulWidget {
  BookingRoomDialog({
    super.key,
    this.roomId,
    this.startDate,
    this.nip,
    this.bookingDetail,
  });

  String? roomId;
  DateTime? startDate;
  String? nip;
  Booking? bookingDetail;

  @override
  State<BookingRoomDialog> createState() => _BookingRoomDialogState();
}

class _BookingRoomDialogState extends State<BookingRoomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: culturedWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 500,
          minWidth: 500,
        ),
        child: Column(
          children: [
            // Text(widget.roomId!),
            // Text(
            //     '${widget.startDate!.day.toString().padLeft(2, '0')}-${widget.startDate!.month.toString().padLeft(2, '0')}-${widget.startDate!.year.toString()}'),
            // Text(
            //     '${widget.startDate!.hour.toString().padLeft(2, '0')}:${widget.startDate!.minute.toString().padLeft(2, '0')}'),
            Text(widget.nip!),
            Text(widget.bookingDetail!.roomId!),
            Text(
                '${widget.bookingDetail!.startDate!.day.toString().padLeft(2, '0')}-${widget.bookingDetail!.startDate!.month.toString().padLeft(2, '0')}-${widget.bookingDetail!.startDate!.year.toString()}'),
            Text(
                '${widget.bookingDetail!.startDate!.hour.toString().padLeft(2, '0')}:${widget.bookingDetail!.startDate!.minute.toString().padLeft(2, '0')}'),

            RegularButton(
              text: 'Test Insert',
              disabled: false,
              onTap: () {
                // widget.bookingDetail!.endDate! = widget.bookingDetail!.startDate!.add(Duration(hours: 2));
                // print(widget.bookingDetail!.toJson());
                // bookingRoom(widget.bookingDetail!).then((value) {
                //   print(value);
                // });
              },
            )
          ],
        ),
      ),
    );
  }
}
