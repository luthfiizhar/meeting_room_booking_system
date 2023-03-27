import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class AddNewFacilityDialog extends StatefulWidget {
  AddNewFacilityDialog({
    super.key,
    this.isEdit = false,
    Amenities? amenities,
  }) : amenities = amenities ?? Amenities();

  bool isEdit;
  Amenities? amenities;

  @override
  State<AddNewFacilityDialog> createState() => _AddNewFacilityDialogState();
}

class _AddNewFacilityDialogState extends State<AddNewFacilityDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  ScrollController scrollController = ScrollController();

  FocusNode nameNode = FocusNode();
  FocusNode typeNode = FocusNode();

  String id = "";
  String name = "";
  String typeValue = "UTILITIES";
  String categoryValue = "";
  String itemPhoto = "";
  bool isAvailableToUser = false;

  List itemTypes = [];
  List<FacilityCategory> categoryList = [];
  bool isLoading = false;

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

  List<DropdownMenuItem> itemTypeDropdown(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['Value'],
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

  Future getImage() async {
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
    urlImage = "data:image/$format;base64,${base64Encode(imageBytes)}";
  }

  Future initFacilitiesType() {
    return apiReq.getAmenitiesType().then((value) {
      if (value['Status'].toString() == "200") {
        itemTypes = value['Data'];
        setState(() {});
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    });
  }

  Future initFacilityCategory() {
    return apiReq.getFacilityCategory().then((value) {
      if (value['Status'].toString() == "200") {
        List categoryResult = value['Data'];
        for (var element in categoryResult) {
          categoryList.add(FacilityCategory(
            name: element['Name'],
            value: element['Value'],
            isSelected: false,
          ));
        }
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: "Error getFacilityCategory",
          contentText: error.toString(),
        ),
      );
    });
  }

  initDataEdit() {
    id = widget.amenities!.amenitiesId!;
    name = widget.amenities!.amenitiesName!;
    _name.text = name;
    typeValue = widget.amenities!.type!;
    isAvailableToUser = widget.amenities!.isAvailableToUser!;
    urlImage = widget.amenities!.photo!;
    List<String> resCategories = widget.amenities!.category!.split(",");
    List<FacilityCategory> tempCategories = [];
    for (var element in resCategories) {
      tempCategories.add(
        FacilityCategory(
          name: element,
          value: element,
          isSelected: true,
        ),
      );
    }

    for (var element in tempCategories) {
      for (var element2 in categoryList) {
        if (element2.value == element.value) {
          element2.isSelected = true;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initFacilitiesType().then((value) {
      initFacilityCategory().then((value) {
        if (widget.isEdit) {
          initDataEdit();
        }
      });
    });

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
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 35,
            ),
            child: Form(
              key: formKey,
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
                        onSaved: (newValue) {
                          name = newValue.toString();
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
                        focusNode: typeNode,
                        items: itemTypeDropdown(itemTypes),
                        customHeights: _getCustomItemsHeights(itemTypes),
                        hintText: 'Choose',
                        value: widget.isEdit ? typeValue : null,
                        onChanged: (value) {
                          typeValue = value;
                        },
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
                        onChanged: (value) {
                          if (isAvailableToUser) {
                            isAvailableToUser = false;
                          } else {
                            isAvailableToUser = true;
                          }
                          setState(() {});
                        },
                        filled: true,
                        label: 'Available to User',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Category',
                    SizedBox(
                      // width: 250,
                      child: Wrap(
                        spacing: 15,
                        children: categoryList.map((e) {
                          return BlackCheckBox(
                            selectedValue: e.isSelected,
                            filled: true,
                            label: e.name,
                            onChanged: (value) {
                              if (e.isSelected) {
                                e.isSelected = false;
                              } else {
                                e.isSelected = true;
                              }
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputFieldPhoto(
                    'Item Photo',
                    urlImage == ""
                        ? InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: SizedBox(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                          )
                        : urlImage.startsWith('data')
                            ? InkWell(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  width: 250,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        Base64Decoder()
                                            .convert(urlImage.split(',').last),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: urlImage,
                                imageBuilder: (context, imageProvider) {
                                  return InkWell(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: Container(
                                      width: 250,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      isLoading
                          ? const SizedBox(
                              child: CircularProgressIndicator(
                                color: eerieBlack,
                              ),
                            )
                          : RegularButton(
                              text: 'Confirm',
                              disabled: false,
                              padding: ButtonSize().mediumSize(),
                              onTap: () {
                                if (formKey.currentState!.validate() &&
                                    urlImage != "") {
                                  formKey.currentState!.save();
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Amenities addFacilitiesData = Amenities();
                                  addFacilitiesData.amenitiesName = name;
                                  addFacilitiesData.type = typeValue;
                                  addFacilitiesData.photo = urlImage;
                                  addFacilitiesData.isAvailableToUser =
                                      isAvailableToUser;

                                  List categoriesTempList = [];
                                  for (var element in categoryList
                                      .where((element) => element.isSelected)
                                      .toList()) {
                                    categoriesTempList.add(element.value);
                                  }
                                  addFacilitiesData.category =
                                      categoriesTempList.join(",");
                                  if (widget.isEdit) {
                                    addFacilitiesData.amenitiesId = id;
                                    apiReq
                                        .updateFacility(addFacilitiesData)
                                        .then((value) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (value['Status'].toString() == "200") {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialogBlack(
                                            title: value['Title'],
                                            contentText: value['Message'],
                                          ),
                                        ).then((value) {
                                          Navigator.of(context).pop(true);
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialogBlack(
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
                                          title: "Error addFacilities",
                                          contentText: error.toString(),
                                        ),
                                      );
                                    });
                                  } else {
                                    apiReq
                                        .addFacilities(addFacilitiesData)
                                        .then((value) {
                                      if (value['Status'].toString() == "200") {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialogBlack(
                                            title: value['Title'],
                                            contentText: value['Message'],
                                          ),
                                        ).then((value) {
                                          Navigator.of(context).pop(true);
                                        });
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialogBlack(
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
                                          title: "Error addFacilities",
                                          contentText: error.toString(),
                                        ),
                                      );
                                    });
                                  }
                                } else {
                                  scrollController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linear,
                                  );
                                  if (urlImage == "") {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AlertDialogBlack(
                                        title: "Failed",
                                        contentText: "Photo is required.",
                                        isSuccess: false,
                                      ),
                                    );
                                  }
                                }
                              },
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

class FacilityCategory {
  FacilityCategory({
    this.name = "",
    this.value = "",
    this.isSelected = false,
  });
  String name;
  String value;
  bool isSelected;

  Map<String, dynamic> toJson() =>
      {'"name"': '"$name"', '"value"': '"$value"', '"isSelected"': isSelected};

  @override
  String toString() {
    return toJson().toString();
  }
}
