import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';

class FilterContainer extends StatefulWidget {
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
  State<FilterContainer> createState() => _FilterContainerState();
}

class _FilterContainerState extends State<FilterContainer> {
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Filter Floor',
              style: TextStyle(
                fontFamily: 'Helvetica',
                fontSize: 18,
                color: davysGray,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Divider(
              color: davysGray,
              thickness: 0.5,
            ),
          ),
          ListView.builder(
            itemCount: widget.listFilter!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < widget.listFilter!.length - 1 ? 15 : 0,
                ),
                child: BlackCheckBox(
                  selectedValue: widget.listFilter![index].selected,
                  label: widget.listFilter![index].name,
                  onChanged: (value) {
                    print('click');
                    print(value);
                    setState(() {
                      widget.listFilter![index].selected = value;
                      widget.onChangeFilter!();
                    });
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
