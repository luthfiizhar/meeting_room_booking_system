import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class WhiteInputField extends StatelessWidget {
  const WhiteInputField({
    required this.controller,
    this.hintText,
    this.focusNode,
    this.obsecureText,
    this.onSaved,
    this.validator,
    this.suffixIcon,
    required this.enabled,
  });

  final TextEditingController controller;
  final String? hintText;
  final FocusNode? focusNode;
  final bool? obsecureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      cursorColor: culturedWhite,
      focusNode: focusNode,
      obscureText: obsecureText!,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: lightGray,
            width: 1,
          ),
        ),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: orangeAccent,
            width: 1,
          ),
        ),
        errorStyle: const TextStyle(
          color: orangeAccent,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        fillColor: eerieBlack,
        filled: true,
        isCollapsed: true,
        // isDense: true,
        focusColor: eerieBlack,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
        // conte
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 18,
          bottom: 15,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: culturedWhite,
      ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: lightGray,
      ),
      onSaved: onSaved,
      validator: validator,
    );
  }
}
