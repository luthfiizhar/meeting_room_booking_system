import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class BlackCheckBox extends StatelessWidget {
  BlackCheckBox({
    required this.selectedValue,
    required this.onChanged,
    this.label,
    this.filled = false,
  });

  final bool? selectedValue;
  final ValueChanged? onChanged;
  final String? label;
  bool? filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          color: !filled! ? culturedWhite : eerieBlack,
          width: 17,
          height: 17,
          child: Transform.scale(
            scale: 1.1,
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
                if (filled! == false) {
                  return culturedWhite;
                }
                return culturedWhite;
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
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            label!,
            style: helveticaText.copyWith(
              fontSize: 18, // 16,
              fontWeight: FontWeight.w300,
              color: eerieBlack,
            ),
          ),
        ),
      ],
    );
  }
}

class CheckBoxModel {
  CheckBoxModel({
    this.selected,
    this.value,
    this.name,
  });

  bool? selected;
  String? value;
  String? name;

  @override
  String toString() {
    // TODO: implement toString
    return "{$value}";
  }
}
