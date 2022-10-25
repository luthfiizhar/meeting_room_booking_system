import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class CustomRadioButton extends StatelessWidget {
  CustomRadioButton({
    super.key,
    this.label,
    this.group,
    this.onChanged,
    this.value,
  });

  String? label;
  String? value;
  ValueChanged? onChanged;
  // RadioModel? group;
  String? group;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          // color: !filled! ? culturedWhite : eerieBlack,
          width: 17,
          height: 17,
          child: Transform.scale(
            scale: 1.1,
            child: Radio(
              value: value,
              groupValue: group!,
              onChanged: onChanged,
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
                // if (filled! == false) {
                //   return culturedWhite;
                // }
                return eerieBlack;
              }),
              overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.hovered)) {
                  return davysGray;
                }
                return culturedWhite;
              }),
            ),
            // child: Checkbox(
            //   hoverColor: davysGray,
            //   splashRadius: 0,
            //   fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            //     if (states.contains(MaterialState.selected)) {
            //       return eerieBlack;
            //     }
            //     if (states.contains(MaterialState.hovered)) {
            //       return davysGray;
            //     }
            //     if (states.contains(MaterialState.disabled)) {
            //       return platinum;
            //     }
            //     // if (filled! == false) {
            //     //   return culturedWhite;
            //     // }
            //     return eerieBlack;
            //   }),
            //   overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            //     if (states.contains(MaterialState.hovered)) {
            //       return davysGray;
            //     }
            //     return culturedWhite;
            //   }),
            //   side: MaterialStateBorderSide.resolveWith((states) {
            //     if (states.contains(MaterialState.hovered)) {
            //       return const BorderSide(
            //         color: davysGray,
            //         width: 1.5,
            //       );
            //     }
            //     return const BorderSide(
            //       color: eerieBlack,
            //       width: 1.5,
            //     );
            //   }),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(2.5),
            //   ),
            //   // activeColor: culturedWhite,
            //   checkColor: culturedWhite,
            //   value: selectedValue,
            //   onChanged: onChanged,
            // ),
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
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: eerieBlack,
            ),
          ),
        ),
      ],
    );
  }
}

class RadioModel {
  RadioModel({
    this.isSelected,
    this.text,
  });

  bool? isSelected;
  String? text;
}
