import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class NoBorderDropdownButton extends StatelessWidget {
  const NoBorderDropdownButton({
    super.key,
    required this.items,
    this.hintText,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.enabled = true,
    this.onTap,
    this.value,
    this.customHeights,
  });

  final List<DropdownMenuItem<dynamic>>? items;
  final String? hintText;
  final FocusNode? focusNode;
  final ValueChanged? onChanged;
  final FormFieldValidator? validator;
  final Widget? suffixIcon;
  final bool? enabled;
  final VoidCallback? onTap;
  final dynamic value;
  final List<double>? customHeights;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      buttonHeight: 25,
      value: value,
      focusNode: focusNode,
      items: items,
      customItemsHeights: customHeights,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        disabledBorder: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        fillColor: enabled!
            ? focusNode!.hasFocus
                ? culturedWhite
                : Colors.transparent
            : platinum,
        filled: true,
        isDense: true,
        // isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: lightGray,
        ),
        contentPadding: const EdgeInsets.only(
          right: 0,
          left: 0,
          top: 0,
          bottom: 0,
        ),
        // suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      itemPadding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      icon: suffixIcon,
      hint: Text(
        hintText!,
        style: helveticaText.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
      ),
      // buttonPadding: EdgeInsets.only(
      //   right: 5,
      //   left: 5,
      //   top: 0,
      //   bottom: 0,
      // ),
      style: helveticaText.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      // buttonDecoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(5),
      //   border: Border.all(
      //     color: eerieBlack,
      //     width: 1,
      //   ),
      //   color: culturedWhite,
      // ),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: sonicSilver,
          width: 1,
        ),
        color: culturedWhite,
      ),
      // offset: const Offset(0, -20),
    );
  }
}
