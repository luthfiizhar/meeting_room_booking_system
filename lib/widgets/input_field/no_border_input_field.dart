import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class NoBorderInputField extends StatelessWidget {
  NoBorderInputField({
    this.controller,
    this.focusNode,
    this.onTap,
    this.onSaved,
    this.validator,
    this.enable = false,
    this.fontSize = 18,
  });

  TextEditingController? controller;
  FocusNode? focusNode;
  VoidCallback? onTap;
  FormFieldSetter<String>? onSaved;
  FormFieldValidator? validator;
  bool enable;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      mouseCursor: SystemMouseCursors.click,
      enabled: enable,
      onTap: onTap,
      onSaved: onSaved,
      // focusNode: dateNode,
      controller: controller,
      style: TextStyle(
        fontFamily: 'Helvetica',
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        height: 1.3,
        color: davysGray,
      ),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          right: 5,
        ),
        // isCollapsed: true,
        isDense: true,
        suffixIconConstraints: BoxConstraints(
          minWidth: 10,
          maxWidth: 24,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_sharp,
          size: 22,
          color: eerieBlack,
        ),
        // contentPadding: EdgeInsets.only(
        //   top: 17,
        //   bottom: 15,
        // ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
