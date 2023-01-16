import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class SearchInputField extends StatelessWidget {
  SearchInputField({
    required this.controller,
    this.hintText,
    this.focusNode,
    this.obsecureText = false,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
    this.maxLines,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.fontSize = 16,
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
  ValueChanged<String>? onFieldSubmitted;
  int? maxLines;
  Widget? prefixIcon;
  double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: focusNode!.hasFocus
            ? const [
                BoxShadow(
                  blurRadius: 40,
                  offset: Offset(0, 10),
                  // blurStyle: BlurStyle.outer,
                  color: Color.fromRGBO(29, 29, 29, 0.2),
                )
              ]
            : null,
      ),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        obscureText: obsecureText!,
        cursorColor: eerieBlack,
        maxLines: maxLines,
        onTap: onTap,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: grayx11,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: grayx11,
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
          fillColor: enabled!
              ? focusNode!.hasFocus
                  ? culturedWhite
                  : Colors.transparent
              : platinum,
          filled: true,
          // isDense: true,
          isCollapsed: true,
          focusColor: culturedWhite,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
          contentPadding: const EdgeInsets.only(
            right: 15,
            left: 15,
            top: 17,
            bottom: 15,
          ),
          suffixIcon: suffixIcon,
          suffixIconColor: eerieBlack,
          prefixIcon: prefixIcon,
        ),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
      ),
    );
  }
}
