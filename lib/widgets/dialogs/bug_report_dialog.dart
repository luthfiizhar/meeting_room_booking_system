import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/area_menu_page/new_area_dialog.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class BugReportDialog extends StatefulWidget {
  const BugReportDialog({super.key});

  @override
  State<BugReportDialog> createState() => _BugReportDialogState();
}

class _BugReportDialogState extends State<BugReportDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();
  TextEditingController _description = TextEditingController();
  FocusNode descriptionNode = FocusNode();

  String description = "";
  List bugPhoto = [
    {'base64': "picker", 'isLast': true}
  ];

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

  Future getBugPhoto() async {
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
    bugPhoto.insert(bugPhoto.length - 1, {
      "base64": "data:image/$format;base64,${base64Encode(imageBytes)}",
      "isLast": false,
    });
  }

  removeBugPhoto(int index) {
    bugPhoto.removeAt(index);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    descriptionNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 620,
          maxWidth: 620,
          minHeight: 300,
          // maxHeight: 650,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Report Error',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Do you experience any error in system? Please describe here!',
                    style: helveticaText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  BlackInputField(
                    controller: _description,
                    focusNode: descriptionNode,
                    enabled: true,
                    maxLines: 5,
                    onSaved: (newValue) {
                      description = newValue.toString();
                    },
                    obsecureText: false,
                    hintText: 'Tell us more ...',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Have any photo? You can add prove of error here.',
                    style: helveticaText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    children: bugPhoto
                        .asMap()
                        .map(
                          (index, element) => MapEntry(
                            index,
                            element['isLast']
                                ? bugPhoto.length - 1 < 2
                                    ? InkWell(
                                        onTap: () {
                                          getBugPhoto();
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
                                                  'Add Photo',
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
                                    : const SizedBox()
                                : BugPhotoItemContainer(
                                    index: index,
                                    base64: element['base64'],
                                    remove: removeBugPhoto,
                                  ),
                          ),
                        )
                        .values
                        .toList(),
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
                        padding: ButtonSize().smallSize(),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      RegularButton(
                        text: 'Submit',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            description = description
                                .replaceAll('\n', '\\n')
                                .replaceAll('"', '\\"');
                            List photo = [];
                            for (var element in bugPhoto) {
                              if (element['isLast'] == false) {
                                photo.add('"${element['base64']}"');
                              }
                            }
                            apiReq
                                .sendBugReport(description, photo)
                                .then((value) {
                              if (value['Status'].toString() == "200") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: value['Title'],
                                    contentText: value['Message'],
                                  ),
                                ).then((value) {
                                  Navigator.of(context).pop(true);
                                });
                              } else if (value['Status'].toString() == "401") {
                                showDialog(
                                  context: context,
                                  builder: (context) => TokenExpiredDialog(
                                    title: value['Title'],
                                    contentText: value['Message'],
                                  ),
                                );
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
                                  title: 'Error sendBugReport',
                                  contentText: error.toString(),
                                  isSuccess: false,
                                ),
                              );
                            });
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
}

class BugPhotoItemContainer extends StatefulWidget {
  BugPhotoItemContainer({
    super.key,
    this.index = 0,
    this.base64 = "",
    this.remove,
  });

  int index;
  String base64;
  Function? remove;

  @override
  State<BugPhotoItemContainer> createState() => _BugPhotoItemContainerState();
}

class _BugPhotoItemContainerState extends State<BugPhotoItemContainer> {
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
