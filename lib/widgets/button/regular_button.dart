import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class RegularButton extends StatelessWidget {
  RegularButton(
      {required this.text,
      this.fontSize,
      this.onTap,
      required this.disabled,
      this.padding});

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  bool? disabled = false;
  final EdgeInsetsGeometry? padding;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return eerieBlack;
    }
    return culturedWhite;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? grayx11 : eerieBlack;
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
                side: BorderSide(color: eerieBlack, width: 1),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.5),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return culturedWhite;
            if (states.contains(MaterialState.hovered)) return davysGray;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
      ),
      child: Text(text!),
    );
  }
}
