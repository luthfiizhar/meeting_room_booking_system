import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/select_amenities_dialog.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/radio_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class NewAreaDialog extends StatefulWidget {
  NewAreaDialog({
    super.key,
    this.isEdit = false,
    this.roomId = "",
    this.resetState,
  });

  bool isEdit;
  Function? resetState;
  String roomId;

  @override
  State<NewAreaDialog> createState() => _NewAreaDialogState();
}

class _NewAreaDialogState extends State<NewAreaDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();
  TextEditingController _areaName = TextEditingController();
  TextEditingController _areaAlias = TextEditingController();
  TextEditingController _minCapacity = TextEditingController();
  TextEditingController _maxCapacity = TextEditingController();
  TextEditingController _maxDuration = TextEditingController();

  FocusNode areaNameNode = FocusNode();
  FocusNode areaAliasNode = FocusNode();
  FocusNode minCapacityNode = FocusNode();
  FocusNode maxCpacityNode = FocusNode();
  FocusNode maxDurationNode = FocusNode();
  FocusNode buildingNode = FocusNode();
  FocusNode floorNode = FocusNode();
  FocusNode roomTypeNode = FocusNode();

  String areaName = "";
  String areaAlias = "";
  String roomId = "";
  String selectedBuilding = "1";
  String selectedFloor = "AR-1";
  String selectedType = "MeetingRoom";
  String minCapacity = "";
  String maxCapacity = "";
  String maxDuration = "";
  // String buildingValue = "1";
  // String floorValue = "AR-1";
  // String roomTypeValue = "MeetingRoom";

  String availabilityValue = "INACTIVE";

  List buildingList = [];
  List floorList = [];
  List roomType = [];

  List<RadioModel> availabilityList = [
    RadioModel(
      isSelected: true,
      text: 'Show to User',
      value: "ACTIVE",
    ),
    RadioModel(
      isSelected: true,
      text: 'Not Visible',
      value: "INACTIVE",
    ),
  ];

  String coverPhotoBase64 = "";
  String coverPhotoUrl = "";

  List areaPhoto = [
    {'base64': "picker", 'isLast': true}
  ];

  List<Amenities> allAmenities = [];
  List<Amenities> allProhibitedAmenities = [];
  List<Amenities> defaultFacility = [
    Amenities(amenitiesId: '0', amenitiesName: 'Kosong'),
  ];
  List<Amenities> prohibitedFacility = [
    Amenities(amenitiesId: '0', amenitiesName: 'Kosong')
  ];

  String urlImage = "";
  bool emptyImage = true;
  File? pickedImage;
  var imageFile;
  String? base64image = "";
  final picker = ImagePicker();
  File? _image = File('');
  NetworkImage? imageUpload;
  Uint8List? webImage = Uint8List(8);
  XFile? _imageX;

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
    apiReq.getRoomType().then((value) {
      if (value['Status'].toString() == "200") {
        setState(() {
          roomType = value['Data'];
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
  }

  initFloorList() async {
    apiReq.getFloorListDropdown().then((value) {
      if (value["Status"].toString() == "200") {
        setState(() {
          floorList = value['Data'];
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
  }

  initBuildingList() async {
    apiReq.getBuildingList().then((value) {
      if (value["Status"] == "200") {
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
  }

  initAmenitiesList() async {
    apiReq.getAmenitiesListAdmin().then((value) {
      print(value);
      if (value['Status'] == "200") {
        List result = value['Data'];
        for (var element in result) {
          allAmenities.add(Amenities(
            amenitiesId: element['AmenitiesID'].toString(),
            amenitiesName: element['AmenitiesName'].toString(),
            photo: element['ImageURL'].toString(),
          ));
          allProhibitedAmenities.add(Amenities(
            amenitiesId: element['AmenitiesID'].toString(),
            amenitiesName: element['AmenitiesName'].toString(),
            photo: element['ImageURL'].toString(),
          ));
        }
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
  }

  setListAmenities(List<Amenities> list) {
    defaultFacility.removeWhere((element) => element.amenitiesId != "0");
    setState(() {
      // print('list ----> $list');
      for (var i = 0; i < allAmenities.length; i++) {
        for (var element in list) {
          if (allAmenities[i].amenitiesId == element.amenitiesId) {
            allAmenities[i].qty = element.qty;
            defaultFacility.insert(defaultFacility.length - 1, element);
          }
        }
      }
      // defaultFacility = list;
    });
    print("DEFAULT ---> $defaultFacility");
  }

  setProhibitedList(List<Amenities> list) {
    // print("RESULT PROHIBITED $list");
    prohibitedFacility.removeWhere((element) => element.amenitiesId != "0");

    for (var result in list) {
      if (result.isProhibited == true) {
        prohibitedFacility.insert(prohibitedFacility.length - 1, result);
      }
    }
    allProhibitedAmenities = list;

    setState(() {});
  }

  Future getCoverImage() async {
    String format;
    imageCache.clear();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    imageFile = await pickedFile!.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    if (kIsWeb) {
      // Check if this is a browser session
      var f = await pickedFile.readAsBytes();
      format = pickedFile.name.toString().split('.').last;
      setState(() {
        webImage = f;
        _image = File('a');
      });
    } else {
      _image = File(pickedFile.path);
      format = pickedFile.name.toString().split('.').last;
    }
    List<int> imageBytes = webImage!;
    coverPhotoBase64 = "data:image/$format;base64,${base64Encode(imageBytes)}";
  }

  Future getAreaPhoto() async {
    String format;
    imageCache.clear();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    imageFile = await pickedFile!.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    if (kIsWeb) {
      // Check if this is a browser session
      var f = await pickedFile.readAsBytes();
      format = pickedFile.name.toString().split('.').last;
      setState(() {
        webImage = f;
        _image = File('a');
      });
    } else {
      _image = File(pickedFile.path);
      format = pickedFile.name.toString().split('.').last;
    }
    List<int> imageBytes = webImage!;
    areaPhoto.insert(areaPhoto.length - 1, {
      "base64": "data:image/$format;base64,${base64Encode(imageBytes)}",
      "isLast": false,
    });
  }

  removeAreaPhoto(int index) {
    areaPhoto.removeAt(index);
    setState(() {});
  }

  removeCoverPhoto(int index) {
    coverPhotoBase64 = "";
    setState(() {});
  }

  removeDefaultFacilities(int index) {
    setState(() {
      var id = defaultFacility.elementAt(index).amenitiesId;
      // print("ID --> $id");
      for (var i = 0; i < allAmenities.length; i++) {
        if (allAmenities[i].amenitiesId == id) {
          allAmenities[i].qty = 0;
        }
      }
      defaultFacility.removeAt(index);
    });
  }

  removeProhibitedFacilites(int index) {
    setState(() {
      // var id = prohibitedFacility.elementAt(index).amenitiesId;
      // // print("ID --> $id");
      // for (var i = 0; i < allAmenities.length; i++) {
      //   if (allAmenities[i].amenitiesId == id) {
      //     allAmenities[i].qty = 0;
      //   }
      // }
      // defaultFacility.removeAt(index);
    });
  }

  initDataEdit() {
    apiReq.adminRoomDetail(widget.roomId).then((value) {
      print(value);
      if (value['Status'].toString() == "200") {
        setState(() {
          roomId = value['Data']['RoomID'];
          areaName = value['Data']['RoomName'];
          areaAlias = value['Data']['RoomAlias'];
          selectedType = value['Data']['RoomType'];
          selectedFloor = value['Data']['AreaID'];
          selectedBuilding = value['Data']['BuildingID'];
          minCapacity = value['Data']['MinCapacity'].toString();
          maxCapacity = value['Data']['MaxCapacity'].toString();
          int maxDurationSec = int.parse(value['Data']['BookingDuration']);
          maxDuration = "${maxDurationSec / 3600}";
          availabilityValue = value['Data']['Status'];
          coverPhotoBase64 = value['Data']['CoverPhoto'];
          _areaName.text = areaName;
          _areaAlias.text = areaAlias;
          _minCapacity.text = minCapacity;
          _maxCapacity.text = maxCapacity;
          _maxDuration.text = maxDuration;
          List areaPhotoResult = value['Data']['RoomPhotos'];
          List defaultFacilityResult = value['Data']['DefaultAmenities'];
          List prohibitedFacilityResult = value['Data']['ForbiddenAmenities'];
          for (var element in areaPhotoResult) {
            areaPhoto.insert(areaPhoto.length - 1,
                {'base64': element['Photo'], 'isLast': false});
          }
          for (var element in defaultFacilityResult) {
            defaultFacility.insert(
              defaultFacility.length - 1,
              Amenities(
                amenitiesId: element['AmenitiesID'].toString(),
                amenitiesName: element['AmenitiesName'],
                photo: element['ImageURL'],
                roomAmenitiesId: element['RoomAmenitiesID'],
              ),
            );
          }
          for (var element in prohibitedFacilityResult) {
            prohibitedFacility.insert(
              prohibitedFacilityResult.length - 1,
              Amenities(
                amenitiesId: element['AmenitiesID'].toString(),
                amenitiesName: element['AmenitiesName'],
                photo: element['ImageURL'],
              ),
            );
          }
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
          title: "Error getAdminRoomDetail",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initRoomType();
    initFloorList();
    initBuildingList();
    initAmenitiesList();
    if (widget.isEdit) {
      initDataEdit();
    }
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
            child: Form(
              key: formKey,
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
                                    onSaved: (newValue) {
                                      areaName = newValue.toString();
                                    },
                                    validator: (value) => value == ""
                                        ? "Area name is required"
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              inputField(
                                'Area Alias',
                                SizedBox(
                                  width: 300,
                                  child: BlackInputField(
                                    controller: _areaAlias,
                                    enabled: true,
                                    focusNode: areaAliasNode,
                                    hintText: 'Alias here ...',
                                    onSaved: (newValue) {
                                      areaAlias = newValue.toString();
                                    },
                                    validator: (value) => value == ""
                                        ? "Area alias is required"
                                        : null,
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
                                    value:
                                        widget.isEdit ? selectedBuilding : null,
                                    onChanged: (value) {
                                      selectedBuilding = value;
                                    },
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
                                    value: widget.isEdit ? selectedFloor : null,
                                    onChanged: (value) {
                                      selectedFloor = value;
                                    },
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
                                    value: widget.isEdit ? selectedType : null,
                                    onChanged: (value) {
                                      selectedType = value;
                                    },
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
                                  onSaved: (newValue) {
                                    minCapacity = newValue.toString();
                                  },
                                  validator: (value) => value == ""
                                      ? "This field is required"
                                      : null,
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
                                  onSaved: (newValue) {
                                    maxCapacity = newValue.toString();
                                  },
                                  validator: (value) => value == ""
                                      ? "This field is required"
                                      : null,
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
                                  onSaved: (newValue) {
                                    maxDuration = newValue.toString();
                                  },
                                  validator: (value) => value == ""
                                      ? "This field is required"
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            inputField3(
                                'Availability:',
                                Wrap(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  direction: Axis.vertical,
                                  spacing: 15,
                                  children: availabilityList.map((e) {
                                    return CustomRadioButton(
                                      group: availabilityValue,
                                      label: e.text,
                                      value: e.value,
                                      onChanged: (value) {
                                        setState(() {
                                          availabilityValue = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                )),
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
                  InkWell(
                    onTap: () {
                      getCoverImage();
                    },
                    child: coverPhotoBase64 != ""
                        ? AreaPhotoItemContainer(
                            index: 0,
                            base64: coverPhotoBase64,
                            remove: removeCoverPhoto,
                          )
                        : DottedBorder(
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
                    children: areaPhoto
                        .asMap()
                        .map(
                          (index, element) => MapEntry(
                            index,
                            element['isLast']
                                ? InkWell(
                                    onTap: () {
                                      getAreaPhoto();
                                    },
                                    child: DottedBorder(
                                      borderType: BorderType.Rect,
                                      radius: const Radius.circular(5),
                                      dashPattern: const [10, 4, 10, 4],
                                      child: SizedBox(
                                        width: 250,
                                        height: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                    ),
                                  )
                                : AreaPhotoItemContainer(
                                    index: index,
                                    base64: element['base64'],
                                    remove: removeAreaPhoto,
                                  ),
                          ),
                        )
                        .values
                        .toList(),
                    // children: areaPhoto.map(
                    //   (e) {
                    //     if (e['isLast']) {
                    //       return InkWell(
                    //         onTap: () {
                    //           getAreaPhoto();
                    //         },
                    //         child: DottedBorder(
                    //           borderType: BorderType.Rect,
                    //           radius: const Radius.circular(5),
                    //           dashPattern: const [10, 4, 10, 4],
                    //           child: SizedBox(
                    //             width: 250,
                    //             height: 150,
                    //             child: Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   MdiIcons.plusCircleOutline,
                    //                 ),
                    //                 const SizedBox(
                    //                   height: 10,
                    //                 ),
                    //                 Text(
                    //                   'Add Area Photo',
                    //                   style: helveticaText.copyWith(
                    //                     fontSize: 16,
                    //                     fontWeight: FontWeight.w300,
                    //                     color: davysGray,
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     } else {
                    //       return Container(
                    //         width: 250,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           color: davysGray,
                    //           borderRadius: BorderRadius.circular(5),
                    //         ),
                    //       );
                    //     }
                    //   },
                    // ).toList(),
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
                                children: defaultFacility
                                    .asMap()
                                    .map(
                                      (index, e) => MapEntry(
                                        index,
                                        e.amenitiesId == '0'
                                            ? InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SelectFacilityDialogAdmin(
                                                      listAmen: allAmenities,
                                                      setListAmenities:
                                                          setListAmenities,
                                                    ),
                                                  );
                                                },
                                                child: DottedBorder(
                                                  borderType: BorderType.Rect,
                                                  radius:
                                                      const Radius.circular(5),
                                                  dashPattern: const [
                                                    10,
                                                    4,
                                                    10,
                                                    4
                                                  ],
                                                  child: SizedBox(
                                                    height: 165,
                                                    width: 125,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          MdiIcons
                                                              .plusCircleOutline,
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          'Add Facility',
                                                          style: helveticaText
                                                              .copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: davysGray,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : FacilityItemContainer(
                                                image: e.photo!,
                                                name: e.amenitiesName!,
                                                qty: e.qty!.toString(),
                                                index: index,
                                                remove: removeDefaultFacilities,
                                              ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                                // children: defaultFacility.map((e) {
                                //   if (e.amenitiesId == '0') {
                                //     return InkWell(
                                //       onTap: () {
                                //         showDialog(
                                //           context: context,
                                //           builder: (context) =>
                                //               SelectFacilityDialogAdmin(
                                //             listAmen: allAmenities,
                                //             setListAmenities: setListAmenities,
                                //           ),
                                //         );
                                //       },
                                //       child: DottedBorder(
                                //         borderType: BorderType.Rect,
                                //         radius: const Radius.circular(5),
                                //         dashPattern: const [10, 4, 10, 4],
                                //         child: SizedBox(
                                //           height: 165,
                                //           width: 125,
                                //           child: Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.center,
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //             children: [
                                //               const Icon(
                                //                 MdiIcons.plusCircleOutline,
                                //               ),
                                //               const SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Text(
                                //                 'Add Facility',
                                //                 style: helveticaText.copyWith(
                                //                   fontSize: 16,
                                //                   fontWeight: FontWeight.w300,
                                //                   color: davysGray,
                                //                 ),
                                //               )
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   } else {
                                //     return FacilityItemContainer(
                                //       image: e.photo!,
                                //       name: e.amenitiesName!,
                                //       qty: e.qty!.toString(),
                                //     );
                                //   }
                                // }).toList(),
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
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              SelectProhibitedFacilityDialog(
                                            listAmen: allProhibitedAmenities,
                                            setListAmenities: setProhibitedList,
                                          ),
                                        );
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.Rect,
                                        radius: const Radius.circular(5),
                                        dashPattern: const [10, 4, 10, 4],
                                        child: SizedBox(
                                          height: 165,
                                          width: 125,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                MdiIcons.plusCircleOutline,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Add Facility',
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
                                    );
                                  } else {
                                    return ProhibitedFacilityItemContainer(
                                      image: e.photo!,
                                      name: e.amenitiesName!,
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
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            Room room = Room();
                            List areaPhotoValue = [];
                            List selectedProhibited = [];
                            List<Amenities> selectedDefaultFacilities = [];

                            room.roomName = areaName;
                            room.roomAlias = areaAlias;
                            room.availability = availabilityValue;
                            room.buildingId = selectedBuilding;
                            room.floorId = selectedFloor;
                            room.roomType = selectedType;
                            // room.defaultFacilities = defaultFacility;
                            room.minCapacity = minCapacity;
                            room.maxCapacity = maxCapacity;
                            room.maxBookingDuration = maxDuration;
                            // room.prohibitedFacilities = prohibitedFacility;
                            room.coverPhoto = coverPhotoBase64;
                            // room.areaPhoto = areaPhoto;

                            for (var element in defaultFacility) {
                              if (element.amenitiesId != "0") {
                                selectedDefaultFacilities.add(element);
                              }
                            }
                            for (var element in prohibitedFacility) {
                              if (element.amenitiesId != "0") {
                                selectedProhibited
                                    .add('"${element.amenitiesId}"');
                              }
                            }
                            for (var element in areaPhoto) {
                              if (element['isLast'] != true) {
                                if (widget.isEdit) {
                                  areaPhotoValue.add(
                                      {'"Photo"': '"${element['base64']}"'});
                                } else {
                                  areaPhotoValue.add('"${element['base64']}"');
                                }
                              }
                            }
                            room.defaultFacilities = selectedDefaultFacilities;
                            room.prohibitedFacilities = selectedProhibited;
                            room.areaPhoto = areaPhotoValue;
                            // print("AREA PHOTO --> $areaPhotoValue");
                            if (widget.isEdit) {
                              room.roomId = widget.roomId;
                              print(room.toJson());
                              apiReq.editRoom(room).then((value) {
                                print(value);
                                if (value['Status'].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: true,
                                    ),
                                  ).then((value) {
                                    widget.resetState!();
                                    Navigator.of(context).pop();
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
                                    title: 'Error addNewRoom',
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                );
                              });
                            } else {
                              apiReq.addNewRoom(room).then((value) {
                                print(value);
                                if (value['Status'].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: true,
                                    ),
                                  ).then((value) {
                                    widget.resetState!();
                                    Navigator.of(context).pop();
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
                                    title: 'Error addNewRoom',
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                );
                              });
                            }

                            // print(room.toJson());
                          }
                        },
                        padding: ButtonSize().smallSize(),
                      ),
                    ],
                  ),
                ],
              ),
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

  Widget inputField3(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
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
          width: 20,
        ),
        widget,
      ],
    );
  }
}

class SelectFacilityDialogAdmin extends StatefulWidget {
  SelectFacilityDialogAdmin({
    super.key,
    this.setListAmenities,
    this.roomId,
    this.listAmen,
  });

  Function? setListAmenities;
  String? roomId;
  List<Amenities>? listAmen;

  @override
  State<SelectFacilityDialogAdmin> createState() =>
      _SelectFacilityDialogAdminState();
}

class _SelectFacilityDialogAdminState extends State<SelectFacilityDialogAdmin> {
  List listAmen = [];
  List<Amenities> amenities = [];

  List<Amenities> selectedAmen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getAmenitiesList(widget.roomId!).then((value) {
    //   // print(value);
    //   setState(() {
    //     listAmen = value['Data'];
    print(widget.listAmen!);
    for (var element in widget.listAmen!) {
      amenities.add(
        Amenities(
          amenitiesId: element.amenitiesId,
          amenitiesName: element.amenitiesName,
          qty: element.qty,
          photo: element.photo,
        ),
      );
    }

    //     print(amenities.toString());
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 550,
          minHeight: 200,
          minWidth: 450,
          maxWidth: 450,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            decoration: BoxDecoration(
              color: culturedWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Amenities',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.builder(
                    itemCount: amenities.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: index < amenities.length - 1 ? 5 : 0,
                              top: index != 0 ? 5 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    amenities[index].amenitiesName!,
                                    style: const TextStyle(
                                      height: 1.3,
                                      fontFamily: 'Helvetica',
                                      fontSize: 18,
                                      color: eerieBlack,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: RegularButton(
                                        disabled: false,
                                        text: '-',
                                        onTap: () {
                                          int min = amenities[index].qty!;

                                          if (min > 0) {
                                            min--;
                                            amenities[index].qty = min;
                                          } else {
                                            min = 0;
                                            amenities[index].qty = min;
                                          }
                                          setState(() {});
                                        },
                                        padding: ButtonSize().itemQtyButton(),
                                        fontWeight: FontWeight.w300,
                                        radius: 5,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      amenities[index].qty.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 18,
                                        color: eerieBlack,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: RegularButton(
                                        disabled: false,
                                        text: '+',
                                        onTap: () {
                                          // listAmen[index]['qty']++;
                                          setState(() {
                                            int plus = amenities[index].qty!;
                                            plus++;
                                            amenities[index].qty = plus;
                                          });
                                        },
                                        padding: ButtonSize().itemQtyButton(),
                                        fontWeight: FontWeight.w300,
                                        radius: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          index < amenities.length - 1
                              ? const Divider(
                                  color: sonicSilver,
                                  thickness: 0.5,
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RegularButton(
                        text: 'Confirm',
                        disabled: false,
                        onTap: () {
                          // Amenities amen = Amenities();
                          selectedAmen = amenities
                              .where((element) => element.qty! > 0)
                              .toList();
                          widget.setListAmenities!(selectedAmen);
                          // print(selectedAmen);
                          Navigator.of(context).pop();
                        },
                        padding: ButtonSize().mediumSize(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectProhibitedFacilityDialog extends StatefulWidget {
  SelectProhibitedFacilityDialog(
      {super.key, this.setListAmenities, this.listAmen, this.roomId});

  Function? setListAmenities;
  String? roomId;
  List<Amenities>? listAmen;

  @override
  State<SelectProhibitedFacilityDialog> createState() =>
      _SelectProhibitedFacilityDialogState();
}

class _SelectProhibitedFacilityDialogState
    extends State<SelectProhibitedFacilityDialog> {
  List listAmen = [];
  List<Amenities> amenities = [];

  List<Amenities> selectedAmen = [];

  @override
  void initState() {
    super.initState();

    // getAmenitiesList(widget.roomId!).then((value) {
    //   // print(value);
    //   setState(() {
    //     listAmen = value['Data'];
    for (var element in widget.listAmen!) {
      amenities.add(
        Amenities(
          amenitiesId: element.amenitiesId,
          amenitiesName: element.amenitiesName,
          qty: element.qty,
          photo: element.photo,
          isProhibited: element.isProhibited,
        ),
      );
    }
    //     print(amenities.toString());
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 550,
          minHeight: 200,
          minWidth: 450,
          maxWidth: 450,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            decoration: BoxDecoration(
              color: culturedWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Amenities',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.builder(
                    itemCount: amenities.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: index < amenities.length - 1 ? 5 : 0,
                              top: index != 0 ? 5 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    amenities[index].amenitiesName!,
                                    style: const TextStyle(
                                      height: 1.3,
                                      fontFamily: 'Helvetica',
                                      fontSize: 18,
                                      color: eerieBlack,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value: amenities[index].isProhibited,
                                  onChanged: (value) {
                                    setState(() {
                                      if (amenities[index].isProhibited! ==
                                          true) {
                                        amenities[index].isProhibited = false;
                                      } else {
                                        amenities[index].isProhibited = true;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          index < amenities.length - 1
                              ? const Divider(
                                  color: sonicSilver,
                                  thickness: 0.5,
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RegularButton(
                        text: 'Confirm',
                        disabled: false,
                        onTap: () {
                          // Amenities amen = Amenities();
                          selectedAmen = amenities;
                          // .where((element) => element.isProhibited! == true)
                          // .toList();
                          print("SELECTED AMEN ----> $selectedAmen");
                          widget.setListAmenities!(selectedAmen);
                          // print(selectedAmen);
                          Navigator.of(context).pop();
                        },
                        padding: ButtonSize().mediumSize(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FacilityItemContainer extends StatefulWidget {
  FacilityItemContainer({
    super.key,
    this.name = "",
    this.qty = "",
    this.image = "",
    required this.index,
    this.remove,
  });

  String name;
  String qty;
  String image;
  int index;
  Function? remove;

  @override
  State<FacilityItemContainer> createState() => _FacilityItemContainerState();
}

class _FacilityItemContainerState extends State<FacilityItemContainer> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: SizedBox(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              height: 165,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: Image(
                                image: imageProvider,
                              ).image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.name,
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      color: eerieBlack,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${widget.qty} Unit",
                    style: helveticaText.copyWith(
                      fontSize: 14,
                      color: davysGray,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            isHover
                ? Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      onTap: () {
                        widget.remove!(widget.index);
                      },
                      child: Icon(Icons.close),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ProhibitedFacilityItemContainer extends StatelessWidget {
  ProhibitedFacilityItemContainer({
    super.key,
    this.name = "",
    this.image = "",
  });

  String name;
  String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      height: 165,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 80,
            child: CachedNetworkImage(
              imageUrl: image,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image(
                        image: imageProvider,
                      ).image,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            name,
            style: helveticaText.copyWith(
              fontSize: 14,
              color: eerieBlack,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class AreaPhotoItemContainer extends StatefulWidget {
  AreaPhotoItemContainer({
    super.key,
    this.base64 = "",
    required this.index,
    this.remove,
  });

  String base64;
  final int index;
  Function? remove;

  @override
  State<AreaPhotoItemContainer> createState() => _AreaPhotoItemContainerState();
}

class _AreaPhotoItemContainerState extends State<AreaPhotoItemContainer> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: Stack(
        children: [
          widget.base64.startsWith('data')
              ? Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    color: davysGray,
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: MemoryImage(
                        const Base64Decoder().convert(
                          widget.base64.split(',').last,
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: widget.base64,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 250,
                      height: 150,
                      decoration: BoxDecoration(
                        color: davysGray,
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
          !isHover
              ? const SizedBox()
              : Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () {
                      widget.remove!(widget.index);
                    },
                    child: const Icon(Icons.close),
                  ),
                )
        ],
      ),
    );
  }
}
