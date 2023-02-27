import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class TransparentButtonWhite extends StatelessWidget {
  const TransparentButtonWhite({
    required this.text,
    this.fontSize,
    this.onTap,
    this.backgroundColor,
    required this.disabled,
    this.fontWeight = FontWeight.w700,
    this.padding,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final bool? disabled;
  final EdgeInsetsGeometry? padding;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return eerieBlack;
    }
    return disabled! ? grayx11 : culturedWhite;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? platinum : const Color.fromARGB(0, 0, 0, 0);
        }),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
                side: BorderSide(color: culturedWhite, width: 1),
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
            // if (states.contains(MaterialState.hovered))
            //   return Colors.transparent;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return helveticaText.copyWith(
              fontSize: 16,
              fontWeight: fontWeight,
            );
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
          (states) {
            return padding;
          },
        ),
        elevation: MaterialStateProperty.resolveWith<double?>((states) {
          // if (states.contains(MaterialState.hovered)) {
          //   return 0.2;
          // }
          return 0;
        }),
      ),
      child: Text(text!),
    );
  }
}
