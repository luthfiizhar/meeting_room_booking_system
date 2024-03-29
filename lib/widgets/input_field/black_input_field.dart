import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BlackInputField extends StatelessWidget {
  BlackInputField({
    required this.controller,
    this.hintText,
    this.focusNode,
    this.obsecureText = false,
    this.onSaved,
    this.suffixIcon,
    this.validator,
    required this.enabled,
    this.onTap,
    this.maxLines = 1,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.fontSize = 16,
    this.textInputAction,
    this.inputFormatters,
    this.onEditingComplete,
    this.onChanged,
    this.contentPadding =
        const EdgeInsets.only(right: 15, left: 15, top: 18, bottom: 15),
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
  ValueChanged<String>? onChanged;
  int? maxLines;
  Widget? prefixIcon;
  VoidCallback? onEditingComplete;
  TextInputAction? textInputAction;
  double fontSize;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry contentPadding;

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
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        onChanged: onChanged,
        validator: validator,
        onSaved: onSaved,
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        obscureText: obsecureText!,
        cursorColor: eerieBlack,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
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
            overflow: TextOverflow.clip,
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
          contentPadding: contentPadding,
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
