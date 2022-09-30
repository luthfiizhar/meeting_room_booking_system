import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BlackInputField extends StatelessWidget {
  const BlackInputField({
    required this.controller,
    this.hintText,
    this.focusNode,
    this.obsecureText,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
  });

  final TextEditingController controller;
  final String? hintText;
  final FocusNode? focusNode;
  final bool? obsecureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      obscureText: obsecureText!,
      cursorColor: eerieBlack,
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: davysGray,
            width: 1,
          ),
        ),
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: grayx11,
            width: 1,
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
        fillColor: enabled! ? culturedWhite : platinum,
        filled: true,
        // isDense: true,
        isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 18,
          bottom: 15,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: eerieBlack,
      ),
    );
  }
}
