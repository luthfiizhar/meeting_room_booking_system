import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';

class AmenitiesContainer extends StatelessWidget {
  AmenitiesContainer({
    super.key,
    required this.cameraValue,
    required this.tvValue,
    required this.cameraOnChange,
    required this.tvOnChange,
  });

  bool? cameraValue;
  ValueChanged? cameraOnChange;
  bool? tvValue;
  ValueChanged? tvOnChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: culturedWhite,
          border: Border.all(
            color: lightGray,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            BlackCheckBox(
              selectedValue: tvValue,
              onChanged: tvOnChange,
              label: 'TV',
              filled: false,
            ),
            const SizedBox(
              height: 15,
            ),
            BlackCheckBox(
              selectedValue: cameraValue,
              onChanged: cameraOnChange,
              label: 'Camera',
              filled: false,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
