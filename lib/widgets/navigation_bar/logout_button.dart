import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class LogoutButton extends StatelessWidget {
  LogoutButton({
    required this.label,
    required this.onPressed,
  });

  final String? label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            // if (states.contains(MaterialState.hovered)) return scaffoldBg;
            return eerieBlack;
          },
        ),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
          (states) {
            return const EdgeInsets.symmetric(horizontal: 20, vertical: 15);
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (states) {
            // if (states.contains(MaterialState.hovered))
            //   return const TextStyle(
            //       fontSize: 16, fontWeight: FontWeight.w300, color: eerieBlack);
            return const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w300, color: scaffoldBg);
          },
        ),
        shape: MaterialStateProperty.resolveWith(
          (states) {
            // if (states.contains(MaterialState.hovered))
            //   return RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(2),
            //     side: BorderSide(color: eerieBlack),
            //   );
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            );
          },
        ),
      ),
      child: Text(label!),
    );
  }
}
