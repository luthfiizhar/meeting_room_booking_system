import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';

class SortingContainer extends StatefulWidget {
  SortingContainer({
    super.key,
    this.listSorting,
    this.selectedSorting,
    this.onChangeSorting,
  });

  List<RadioModel>? listSorting;
  String? selectedSorting;
  Function? onChangeSorting;

  @override
  State<SortingContainer> createState() => _SortingContainerState();
}

class _SortingContainerState extends State<SortingContainer> {
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
              'Sort Result',
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
            itemCount: widget.listSorting!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < widget.listSorting!.length - 1 ? 15 : 0,
                ),
                child: CustomRadioButton(
                  value: widget.listSorting![index].text,
                  group: widget.selectedSorting,
                  onChanged: (value) {
                    // widget.selectedSorting = widget.listSorting![index].text!;
                    widget.onChangeSorting!(widget.listSorting![index].value,
                        widget.listSorting![index].text!);
                  },
                  label: widget.listSorting![index].text,
                ),
              );
            },
          ),
          // CustomRadioButton(
          //   value: '1',
          //   group: '1',
          //   onChanged: (value) {},
          //   label: 'Lowest Floor',
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // CustomRadioButton(
          //   value: '1',
          //   group: '1',
          //   onChanged: (value) {},
          //   label: 'Lowest Floor',
          // ),
        ],
      ),
    );
  }
}
