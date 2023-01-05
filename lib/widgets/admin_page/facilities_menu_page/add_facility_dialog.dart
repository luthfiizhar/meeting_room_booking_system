import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class AddNewFacilityDialog extends StatefulWidget {
  AddNewFacilityDialog({
    super.key,
    this.isEdit = false,
  });

  bool isEdit;

  @override
  State<AddNewFacilityDialog> createState() => _AddNewFacilityDialogState();
}

class _AddNewFacilityDialogState extends State<AddNewFacilityDialog> {
  final TextEditingController _name = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode typeNode = FocusNode();

  String name = "";
  String typeValue = "";
  String itemPhoto = "";
  bool isAvailableToUser = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameNode.addListener(() {
      setState(() {});
    });
    typeNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameNode.removeListener(() {});
    typeNode.removeListener(() {});
    nameNode.dispose();
    typeNode.dispose();

    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 500,
          maxWidth: 510,
          minHeight: 490,
          maxHeight: 500,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Facilities',
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: eerieBlack,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              inputField(
                'Name',
                Expanded(
                  child: BlackInputField(
                    controller: _name,
                    enabled: true,
                    focusNode: nameNode,
                    hintText: 'Name here...',
                    validator: (value) =>
                        value == "" ? "Name is required" : null,
                    onSaved: (newValue) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Type',
                SizedBox(
                  width: 250,
                  child: BlackDropdown(
                    focusNode: typeNode,
                    items: [],
                    hintText: 'Choose',
                    value: typeValue,
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Option',
                SizedBox(
                  width: 250,
                  child: BlackCheckBox(
                    selectedValue: isAvailableToUser,
                    onChanged: (value) {},
                    filled: true,
                    label: 'Availabl to User',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputFieldPhoto(
                'Item Photo',
                SizedBox(
                  width: 250,
                  height: 150,
                  child: DottedBorder(
                    dashPattern: [10, 4],
                    radius: Radius.circular(5),
                    strokeCap: StrokeCap.round,
                    child: Container(
                      width: 250,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_circle_outline_sharp,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Add Item Photo',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: spanishGray,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputField(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        widget,
      ],
    );
  }

  Widget inputFieldPhoto(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        widget,
      ],
    );
  }
}
