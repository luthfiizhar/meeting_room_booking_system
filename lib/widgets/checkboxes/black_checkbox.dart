import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BlackCheckBox extends StatelessWidget {
  const BlackCheckBox({
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
          color: eerieBlack,
          width: 20,
          height: 20,
          child: Transform.scale(
            scale: 1.3,
            child: Checkbox(
              hoverColor: davysGray,
              splashRadius: 0,
              fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.selected)) {
                  return eerieBlack;
                }
                if (states.contains(MaterialState.hovered)) {
                  return davysGray;
                }
                if (states.contains(MaterialState.disabled)) {
                  return platinum;
                }
                return eerieBlack;
              }),
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.hovered)) {
                  return davysGray;
                }
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
              checkColor: culturedWhite,
              value: selectedValue,
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          label!,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: eerieBlack,
          ),
        ),
      ],
    );
  }
}
