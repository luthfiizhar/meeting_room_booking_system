import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class NewAreaDialog extends StatefulWidget {
  NewAreaDialog({super.key, this.isEdit = false});

  bool isEdit;

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

  List areaPhoto = [
    {'url': "", 'isLast': true}
  ];
  List<Amenities> defaultFacility = [
    Amenities(amenitiesId: '0', amenitiesName: 'Kosong'),
  ];
  List<Amenities> prohibitedFacility = [
    Amenities(amenitiesId: '0', amenitiesName: 'Kosong')
  ];

  List<DropdownMenuItem> roomTypeItems(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['Value'].toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['Name'],
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

  List<DropdownMenuItem> buildingItems(List items) {
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

  List<DropdownMenuItem> floorItems(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['AreaID'].toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['AreaName'],
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

  initRoomType() async {
    getRoomType().then((value) {
      print(value);
      if (value['Status'] == "200") {
        setState(() {
          roomType = value['Data'];
        });
        print('roomType-> $roomType');
      } else {}
    }).onError((error, stackTrace) {});
  }

  initFloorList() async {
    getFloorListDropdown().then((value) {
      if (value["Status"] == "200") {
        setState(() {
          floorList = value['Data'];
        });
      } else {}
    }).onError((error, stackTrace) {});
  }

  initBuildingList() async {
    getBuildingList().then((value) {
      if (value["Status"] == "200") {
        setState(() {
          buildingList = value['Data'];
        });
      } else {}
    }).onError((error, stackTrace) {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRoomType();
    initFloorList();
    initBuildingList();
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
                                  items: buildingItems(buildingList),
                                  enabled: true,
                                  customHeights:
                                      _getCustomItemsHeights(buildingList),
                                  hintText: 'Choose',
                                  value: widget.isEdit
                                      ? buildingList.first['BuildingID']
                                      : null,
                                  onChanged: (value) {},
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
                                  items: floorItems(floorList),
                                  enabled: true,
                                  customHeights:
                                      _getCustomItemsHeights(floorList),
                                  hintText: 'Choose',
                                  value: widget.isEdit
                                      ? floorList.first['AreaID']
                                      : null,
                                  onChanged: (value) {},
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
                                  focusNode: roomTypeNode,
                                  items: roomTypeItems(roomType),
                                  enabled: true,
                                  customHeights:
                                      _getCustomItemsHeights(roomType),
                                  hintText: 'Choose',
                                  value: widget.isEdit
                                      ? roomType.first['Value']
                                      : null,
                                  onChanged: (value) {},
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
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Cover Photo',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DottedBorder(
                  borderType: BorderType.Rect,
                  radius: const Radius.circular(5),
                  dashPattern: const [10, 4, 10, 4],
                  child: SizedBox(
                    width: 250,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          MdiIcons.plusCircleOutline,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Add Cover Photo',
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Area Photo',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: areaPhoto.map(
                    (e) {
                      if (e['isLast']) {
                        return DottedBorder(
                          borderType: BorderType.Rect,
                          radius: const Radius.circular(5),
                          dashPattern: const [10, 4, 10, 4],
                          child: SizedBox(
                            width: 250,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  MdiIcons.plusCircleOutline,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Add Area Photo',
                                  style: helveticaText.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: davysGray,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          width: 250,
                          height: 150,
                          decoration: BoxDecoration(
                            color: davysGray,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        );
                      }
                    },
                  ).toList(),
                  // children: [
                  //   DottedBorder(
                  //     borderType: BorderType.Rect,
                  //     radius: const Radius.circular(5),
                  //     dashPattern: const [10, 4, 10, 4],
                  //     child: SizedBox(
                  //       width: 250,
                  //       height: 150,
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           const Icon(
                  //             MdiIcons.plusCircleOutline,
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             'Add Area Photo',
                  //             style: helveticaText.copyWith(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.w300,
                  //               color: davysGray,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ),
                const SizedBox(
                  height: 40,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Default Facilities',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: defaultFacility.map((e) {
                                if (e.amenitiesId == '0') {
                                  return InkWell(
                                    onTap: () {
                                      defaultFacility.insert(
                                        defaultFacility.length - 2,
                                        Amenities(
                                            amenitiesId: '1',
                                            amenitiesName: '1'),
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 165,
                                      width: 125,
                                      color: blueAccent,
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 165,
                                    width: 125,
                                    color: platinum,
                                  );
                                }
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const VerticalDivider(
                        color: davysGray,
                        thickness: 0.5,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prohibited Facilities',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: prohibitedFacility.map((e) {
                                if (e.amenitiesId == '0') {
                                  return InkWell(
                                    onTap: () {
                                      prohibitedFacility.insert(
                                        prohibitedFacility.length - 2,
                                        Amenities(
                                            amenitiesId: '1',
                                            amenitiesName: 'Test'),
                                      );
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 165,
                                      width: 125,
                                      color: blueAccent,
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 165,
                                    width: 125,
                                    color: platinum,
                                  );
                                }
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TransparentButtonBlack(
                      text: 'Cancel',
                      disabled: false,
                      onTap: () {},
                      padding: ButtonSize().smallSize(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RegularButton(
                      text: 'Confirm',
                      disabled: false,
                      onTap: () {},
                      padding: ButtonSize().smallSize(),
                    ),
                  ],
                ),
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
