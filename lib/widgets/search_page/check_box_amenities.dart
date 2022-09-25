import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class CheckBoxAmenities extends StatelessWidget {
  const CheckBoxAmenities({
    @required this.selectedValue,
    @required this.onChanged,
    this.label,
  });

  final bool? selectedValue;
  final ValueChanged? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: BorderSide(width: 0.5),
          ),
          activeColor: eerieBlack,
          checkColor: scaffoldBg,
          value: selectedValue,
          onChanged: onChanged,
        ),
        Text(label!),
      ],
    );
  }
}
