import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class NewAreaDialog extends StatefulWidget {
  const NewAreaDialog({super.key});

  @override
  State<NewAreaDialog> createState() => _NewAreaDialogState();
}

class _NewAreaDialogState extends State<NewAreaDialog> {
  TextEditingController _areaName = TextEditingController();
  TextEditingController _minCapacity = TextEditingController();
  TextEditingController _maxCapacity = TextEditingController();
  TextEditingController _maxDuration = TextEditingController();

  FocusNode areaNameNode = FocusNode();
  FocusNode minCapacityNode = FocusNode();
  FocusNode maxCpacityNode = FocusNode();
  FocusNode maxDurationNode = FocusNode();
  FocusNode buildingNode = FocusNode();
  FocusNode floorNode = FocusNode();
  FocusNode roomTypeNode = FocusNode();

  String areaName = "";
  String minCapacity = "";
  String maxCapacity = "";
  String maxDuration = "";

  List buildingList = [];
  List floorList = [];
  List roomType = [];

  String coverPhotoBase64 = "";

  List areaPhoto = [];
  List<Amenities> defaultFacility = [];
  List prohibitedFacility = [];

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
    areaNameNode.addListener(() {
      setState(() {});
    });
    minCapacityNode.addListener(() {
      setState(() {});
    });
    maxCpacityNode.addListener(() {
      setState(() {});
    });
    maxDurationNode.addListener(() {
      setState(() {});
    });
    buildingNode.addListener(() {
      setState(() {});
    });
    floorNode.addListener(() {
      setState(() {});
    });
    roomTypeNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _areaName.dispose();
    _minCapacity.dispose();
    _maxCapacity.dispose();
    _maxDuration.dispose();

    areaNameNode.removeListener(() {});
    areaNameNode.dispose();
    minCapacityNode.removeListener(() {});
    minCapacityNode.dispose();
    maxCpacityNode.removeListener(() {});
    maxCpacityNode.dispose();
    maxDurationNode.removeListener(() {});
    maxDurationNode.dispose();
    buildingNode.removeListener(() {});
    buildingNode.dispose();
    floorNode.removeListener(() {});
    floorNode.dispose();
    roomTypeNode.removeListener(() {});
    roomTypeNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 1100,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 35,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: white,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Area',
                  style: helveticaText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: eerieBlack,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            inputField(
                              'Area Name',
                              SizedBox(
                                width: 300,
                                child: BlackInputField(
                                  controller: _areaName,
                                  enabled: true,
                                  focusNode: areaNameNode,
                                  hintText: 'Name here ...',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            inputField(
                              'Building',
                              SizedBox(
                                width: 250,
                                child: BlackDropdown(
                                  focusNode: buildingNode,
                                  items: addDividerItem(buildingList),
                                  enabled: true,
                                  customHeights:
                                      _getCustomItemsHeights(buildingList),
                                  hintText: 'Choose',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            inputField(
                              'Floor',
                              SizedBox(
                                width: 250,
                                child: BlackDropdown(
                                  focusNode: floorNode,
                                  items: addDividerItem(floorList),
                                  enabled: true,
                                  customHeights:
                                      _getCustomItemsHeights(floorList),
                                  hintText: 'Choose',
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
                                  focusNode: buildingNode,
                                  items: addDividerItem(roomType),
                                  enabled: true,
                                  customHeights:
                                      _getCustomItemsHeights(roomType),
                                  hintText: 'Choose',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 38,
                      ),
                      const VerticalDivider(
                        color: grayx11,
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        width: 38,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          inputField2(
                            'Min. Capacity (Person)',
                            SizedBox(
                              width: 100,
                              child: BlackInputField(
                                controller: _minCapacity,
                                enabled: true,
                                focusNode: minCapacityNode,
                                hintText: '...',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          inputField2(
                            'Max. Capacity (Person)',
                            SizedBox(
                              width: 100,
                              child: BlackInputField(
                                controller: _maxCapacity,
                                enabled: true,
                                focusNode: maxCpacityNode,
                                hintText: '...',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          inputField2(
                            'Max. Duration (Hours)',
                            SizedBox(
                              width: 100,
                              child: BlackInputField(
                                controller: _maxDuration,
                                enabled: true,
                                focusNode: maxDurationNode,
                                hintText: '...',
                              ),
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                )
              ],
            ),
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
        widget,
      ],
    );
  }

  Widget inputField2(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 190,
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
        widget,
      ],
    );
  }
}
