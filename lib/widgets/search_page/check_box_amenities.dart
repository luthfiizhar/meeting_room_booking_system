import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class CheckBoxAmenities extends StatelessWidget {
  const CheckBoxAmenities({
    required this.selectedValue,
    required this.onChanged,
    this.label,
  });

  final bool? selectedValue;
  final ValueChanged? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          splashRadius: 0,
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.selected)) {
              return culturedWhite;
            }
            if (states.contains(MaterialState.disabled)) {
              return platinum;
            }
            return culturedWhite;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            return culturedWhite;
          }),
          side: MaterialStateBorderSide.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return const BorderSide(
                color: davysGray,
                width: 1.5,
              );
            }
            return const BorderSide(
              color: eerieBlack,
              width: 1.5,
            );
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.5),
          ),
          // activeColor: culturedWhite,
          checkColor: eerieBlack,
          value: selectedValue,
          onChanged: onChanged,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          label!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
