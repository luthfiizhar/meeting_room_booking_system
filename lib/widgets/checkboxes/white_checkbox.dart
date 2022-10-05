import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class WhiteCheckbox extends StatelessWidget {
  const WhiteCheckbox({
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: culturedWhite,
          width: 17,
          height: 17,
          child: Transform.scale(
            scale: 1.1,
            child: Checkbox(
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
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            label!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: culturedWhite,
            ),
          ),
        ),
      ],
    );
  }
}
