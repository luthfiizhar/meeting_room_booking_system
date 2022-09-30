import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class WhiteDropdown extends StatelessWidget {
  const WhiteDropdown({
    required this.items,
    this.hintText,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    required this.enabled,
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

  List<double> _getCustomItemsHeights() {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items!.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(4);
      }
    }
    return _itemsHeights;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      buttonHeight: 39,
      value: value,
      focusNode: focusNode,
      items: items,
      customItemsHeights: customHeights,
      onChanged: onChanged,
      decoration: InputDecoration(
        // constraints: BoxConstraints(maxHeight: 40),
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
            color: culturedWhite,
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
        fillColor: enabled! ? eerieBlack : platinum,
        filled: true,
        isDense: true,
        // isCollapsed: true,
        focusColor: eerieBlack,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: sonicSilver,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 0,
          bottom: 12,
        ),
        // suffixIcon: suffixIcon,
        suffixIconColor: culturedWhite,
      ),
      icon: suffixIcon,
      hint: Text(
        hintText!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          fontFamily: 'Helvetica',
          color: sonicSilver,
        ),
      ),
      // buttonPadding: EdgeInsets.only(
      //   right: 5,
      //   left: 5,
      //   top: 0,
      //   bottom: 0,
      // ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        fontFamily: 'Helvetica',
        color: culturedWhite,
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
          color: platinum,
          width: 1,
        ),
        color: eerieBlack,
      ),
      offset: const Offset(0, -20),
    );
    return DropdownButtonFormField(
      isExpanded: true,
      focusNode: focusNode,
      items: items,
      onChanged: onChanged,
      // onTap: onTap,
      icon: SizedBox(),
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
        fillColor: enabled! ? culturedWhite : platinum,
        filled: true,
        // isDense: true,
        isCollapsed: true,
        focusColor: culturedWhite,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
          color: eerieBlack,
        ),
        contentPadding: const EdgeInsets.only(
          right: 15,
          left: 15,
          top: 20,
          bottom: 18,
        ),
        suffixIcon: suffixIcon,
        suffixIconColor: eerieBlack,
      ),
      validator: validator,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: eerieBlack,
      ),
      borderRadius: BorderRadius.circular(5),
      dropdownColor: culturedWhite,
    );
  }
}
