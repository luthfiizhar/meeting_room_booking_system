import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';

class FilterContainer extends StatelessWidget {
  FilterContainer({
    super.key,
    this.listFilter,
    this.selectedFilter,
    this.onChangeFilter,
  });

  List<CheckBoxModel>? listFilter;
  List? selectedFilter;
  Function? onChangeFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: culturedWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: lightGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Filter Floor',
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 18,
                color: davysGray,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Divider(
              color: davysGray,
              thickness: 0.5,
            ),
          ),
          ListView.builder(
            itemCount: listFilter!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < listFilter!.length - 1 ? 15 : 0,
                ),
                child: BlackCheckBox(
                  selectedValue: false,
                  label: listFilter![index].value,
                  onChanged: (value) {
                    onChangeFilter;
                  },
                  filled: false,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
