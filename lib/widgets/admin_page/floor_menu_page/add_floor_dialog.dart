import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/white_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class AddNewFloorDialog extends StatefulWidget {
  const AddNewFloorDialog({super.key});

  @override
  State<AddNewFloorDialog> createState() => _AddNewFloorDialogState();
}

class _AddNewFloorDialogState extends State<AddNewFloorDialog> {
  ReqAPI apiReq = ReqAPI();
  TextEditingController _floorName = TextEditingController();

  String selectedBuilding = "";
  List buildingList = [];
  FocusNode floorNameNode = FocusNode();
  FocusNode buildingNode = FocusNode();

  List<DropdownMenuItem> addDividerItem(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['BuildingID'].toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['BuildingName'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights(List items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(15);
      }
    }
    return _itemsHeights;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiReq.getBuildingList().then((value) {
      if (value['Status'].toString() == "200") {
        setState(() {
          buildingList = value['Data'];
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
    floorNameNode.addListener(() {
      setState(() {});
    });
    buildingNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _floorName.dispose();
    floorNameNode.removeListener(() {});
    buildingNode.removeListener(() {});
    floorNameNode.dispose();
    buildingNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 200,
          maxHeight: 500,
          minWidth: 450,
          maxWidth: 450,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Floor',
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
                'Floor Name',
                BlackInputField(
                  controller: _floorName,
                  enabled: true,
                  focusNode: floorNameNode,
                  obsecureText: false,
                  hintText: 'Name here ...',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              inputField(
                'Building',
                BlackDropdown(
                  focusNode: buildingNode,
                  customHeights: _getCustomItemsHeights(buildingList),
                  items: addDividerItem(buildingList),
                  enabled: true,
                  hintText: 'Choose Building',
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TransparentButtonBlack(
                    text: 'Cancel',
                    disabled: false,
                    onTap: () {},
                    padding: ButtonSize().mediumSize(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RegularButton(
                    text: 'Confirm',
                    disabled: false,
                    onTap: () {},
                    padding: ButtonSize().mediumSize(),
                  ),
                ],
              )
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
          width: 140,
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
          width: 10,
        ),
        Expanded(
          child: widget,
        ),
      ],
    );
  }
}
