import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class InputSearch extends StatelessWidget {
  InputSearch({
    required this.controller,
    this.validator,
    this.onSaved,
    this.onTap,
    this.prefix,
    this.suffix,
    this.fontSize,
    required this.enabled,
  });

  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final double? fontSize;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      validator: validator,
      onSaved: onSaved,
      cursorColor: scaffoldBg,
      style: TextStyle(fontSize: fontSize ?? 16, color: scaffoldBg),
      decoration: InputDecoration(
          filled: true,
          enabled: enabled!,
          fillColor: eerieBlack,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: EdgeInsets.only(
            top: 17,
            bottom: 10,
            left: 10,
            right: 5,
          ),
          isCollapsed: true,
          isDense: true,
          prefixIcon: prefix,
          suffixIcon: suffix,
          iconColor: scaffoldBg,
          prefixIconColor: scaffoldBg,
          errorStyle: TextStyle(
            fontSize: 12,
            color: orangeRed,
          )),
    );
  }
}
