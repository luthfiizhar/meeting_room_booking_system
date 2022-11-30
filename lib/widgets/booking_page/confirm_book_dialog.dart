import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';

class ConfirmBookDialog extends StatefulWidget {
  ConfirmBookDialog({
    super.key,
    this.booking,
  });

  Booking? booking;

  @override
  State<ConfirmBookDialog> createState() => _ConfirmBookDialogState();
}

class _ConfirmBookDialogState extends State<ConfirmBookDialog> {
  String summary = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Booking booking = widget.booking!;
    summary = booking.summary!;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Text(summary),
      ),
    );
  }
}
