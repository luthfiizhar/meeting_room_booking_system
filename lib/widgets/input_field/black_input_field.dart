import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BlackInputField extends StatelessWidget {
  const BlackInputField({
    required this.controller,
    this.hintText,
  });

  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: eerieBlack,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 2,
          ),
        ),
        fillColor: culturedWhite,
        filled: true,
        // isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: eerieBlack,
      ),
    );
  }
}
