import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/white_checkbox.dart';

class AmenitiesContainer extends StatelessWidget {
  AmenitiesContainer({
    super.key,
    required this.cameraValue,
    required this.tvValue,
    required this.cameraOnChange,
    required this.tvOnChange,
    this.isDark = true,
  });

  bool? cameraValue;
  ValueChanged? cameraOnChange;
  bool? tvValue;
  ValueChanged? tvOnChange;
  bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 20,
          maxHeight: 100,
          maxWidth: 150,
          minWidth: 150,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? eerieBlack : culturedWhite,
            border: isDark
                ? null
                : Border.all(
                    color: lightGray,
                    width: 1,
                  ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    isDark
                        ? WhiteCheckbox(
                            selectedValue: tvValue,
                            onChanged: tvOnChange,
                            label: 'TV',
                          )
                        : BlackCheckBox(
                            selectedValue: tvValue,
                            onChanged: tvOnChange,
                            label: 'TV',
                            filled: false,
                          ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    isDark
                        ? WhiteCheckbox(
                            selectedValue: cameraValue,
                            onChanged: cameraOnChange,
                            label: 'Camera',
                          )
                        : BlackCheckBox(
                            selectedValue: cameraValue,
                            onChanged: cameraOnChange,
                            label: 'Camera',
                            filled: false,
                          ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
