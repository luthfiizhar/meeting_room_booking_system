import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class WhiteInputField extends StatelessWidget {
  const WhiteInputField({
    required this.controller,
    this.hintText,
  });

  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: culturedWhite,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: lightGray,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: lightGray,
            width: 2,
          ),
        ),
        fillColor: eerieBlack,
        filled: true,
        focusColor: eerieBlack,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
      ),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: lightGray,
      ),
    );
  }
}
