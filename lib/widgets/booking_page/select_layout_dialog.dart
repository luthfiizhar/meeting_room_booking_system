import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:image_picker/image_picker.dart';

class SelectLayoutDialog extends StatefulWidget {
  const SelectLayoutDialog({super.key});

  @override
  State<SelectLayoutDialog> createState() => _SelectLayoutDialogState();
}

class _SelectLayoutDialogState extends State<SelectLayoutDialog> {
  List? availableLayout = ['1', '2', '3'];

  bool upButtonVisible = false;
  bool downButtonVisible = true;
  ScrollController _scrollController = ScrollController();

  bool emptyImage = true;
  File? pickedImage;
  var imageFile;
  String? base64image = "";
  final picker = ImagePicker();
  File? _image = File('');
  NetworkImage? imageUpload;
  Uint8List? webImage = Uint8List(8);
  XFile? _imageX;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      scroll(_scrollController);
    });
  }

  Future getImage() async {
    print('getimage');
    imageCache.clear();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    imageFile = await pickedFile!.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);
    // Image? fromPicker = await ImagePickerWeb.getImageAsWidget();

    // setState(() {
    if (kIsWeb) {
      // Check if this is a browser session
      // imageUpload = NetworkImage(pickedFile.path);
      // _image = File(pickedFile.path);
      var f = await pickedFile.readAsBytes();
      setState(() {
        webImage = f;
        _image = File('a');
      });
    } else {
      _image = File(pickedFile.path);
    }
    // pr.show();
    // isLoading = true;
    // compressImage(_image).then((value) {
    // pr.hide();
    // _image = value;
    // imageUpload = NetworkImage(_image!.path);
    // List<int> imageBytes = _image!.readAsBytesSync();
    List<int> imageBytes = webImage!;
    base64image = base64Encode(imageBytes);
    // print("base64-> " + base64image.toString());
    // });
    // });
  }

  scroll(ScrollController scrollinfo) {
    setState(() {
      if (scrollinfo.offset == scrollinfo.position.minScrollExtent) {
        upButtonVisible = false;
      } else if (scrollinfo.offset == scrollinfo.position.maxScrollExtent) {
        downButtonVisible = false;
      } else {
        upButtonVisible = true;
        downButtonVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 750,
          maxWidth: 750,
          minHeight: 550,
          maxHeight: 550,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 25,
          ),
          decoration: BoxDecoration(
            color: culturedWhite,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Layout',
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: davysGray,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    height: 375,
                    width: 500,
                    child: Center(
                      child: emptyImage
                          ? SizedBox()
                          : Container(
                              height: 375,
                              width: 500,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(webImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            height: 375,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _scrollController,
                                shrinkWrap: true,
                                itemCount: availableLayout!.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == availableLayout!.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          getImage().then((value) {
                                            setState(() {
                                              emptyImage = false;
                                            });
                                          });
                                        },
                                        child: Container(
                                          height: 100,
                                          // color: Colors.green,
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            color: spanishGray,
                                            padding: EdgeInsets.zero,
                                            radius: const Radius.circular(7.5),
                                            dashPattern: const [4, 5],
                                            strokeWidth: 2,
                                            strokeCap: StrokeCap.round,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      'assets/add_circle.png'),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Text(
                                                    'Add Facility',
                                                    style: TextStyle(
                                                      fontFamily: 'Helvetica',
                                                      fontSize: 16,
                                                      color: spanishGray,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 100,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: 375,
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: upButtonVisible,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: InkWell(
                                      onTap: () {
                                        _scrollController.animateTo(
                                            _scrollController.offset - 50,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            curve: Curves.easeInToLinear);
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: eerieBlack,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.keyboard_arrow_up_sharp,
                                            size: 16,
                                            color: culturedWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: downButtonVisible,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
                                        _scrollController.animateTo(
                                            _scrollController.offset + 50,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: eerieBlack,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            size: 16,
                                            color: culturedWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
