import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';

class TransparentBorderedBlackButton extends StatelessWidget {
  const TransparentBorderedBlackButton({
    super.key,
    this.text,
    this.fontSize,
    this.disabled = false,
    this.onTap,
    this.padding,
  });

  final String? text;
  final double? fontSize;
  final VoidCallback? onTap;
  final bool? disabled;
  final EdgeInsetsGeometry? padding;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed
    };
    if (states.any(interactiveStates.contains)) {
      return culturedWhite;
    }
    return disabled! ? platinum : eerieBlack;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled! ? null : onTap,
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.resolveWith(getColor),
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          return disabled! ? grayx11 : const Color.fromARGB(0, 0, 0, 0);
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
              side: BorderSide(
                color: eerieBlack,
                width: 1,
              ),
            );
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) return eerieBlack;
            // if (states.contains(MaterialState.hovered))
            //   return Colors.transparent;
            return null;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            return const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
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
