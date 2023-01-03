import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';

class SelectLayoutDialog extends StatefulWidget {
  SelectLayoutDialog({
    super.key,
    this.setLayout,
    this.imaegUrl = "",
    this.imageBytes,
    this.isUpload = false,
    this.layoutBase64 = "",
  });

  Function? setLayout;
  String imaegUrl;
  Uint8List? imageBytes;
  String layoutBase64;
  bool isUpload;

  @override
  State<SelectLayoutDialog> createState() => _SelectLayoutDialogState();
}

class _SelectLayoutDialogState extends State<SelectLayoutDialog> {
  ReqAPI apiReq = ReqAPI();
  List? availableLayout = ['1', '2', '3'];

  List layoutList = [];

  bool upButtonVisible = false;
  bool downButtonVisible = true;
  bool otherPict = false;
  ScrollController _scrollController = ScrollController();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.imaegUrl != "" || widget.imageBytes!.isNotEmpty) {
      setState(() {
        emptyImage = false;
        if (widget.isUpload) {
          otherPict = true;
          // webImage = widget.imageBytes;
          base64image = widget.layoutBase64;
        } else {
          otherPict = false;
          urlImage = widget.imaegUrl;
        }
      });
    }
    apiReq.getLayoutList().then((value) {
      print(value);
      if (value["Status"].toString() == "200") {
        setState(() {
          layoutList = value["Data"];
        });
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
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
    _scrollController.addListener(() {
      scroll(_scrollController);
    });
  }

  Future getImage() async {
    String format;
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
      format = pickedFile.name.toString().split('.').last;
      setState(() {
        webImage = f;
        _image = File('a');
      });
    } else {
      _image = File(pickedFile.path);
      format = pickedFile.name.toString().split('.').last;
    }
    // pr.show();
    // isLoading = true;
    // compressImage(_image).then((value) {
    // pr.hide();
    // _image = value;
    // imageUpload = NetworkImage(_image!.path);
    // List<int> imageBytes = _image!.readAsBytesSync();
    List<int> imageBytes = webImage!;
    // base64image = base64Encode(imageBytes);
    base64image = "data:image/$format;base64,${base64Encode(imageBytes)}";
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
                          ? const SizedBox()
                          : otherPict
                              ? Container(
                                  height: 375,
                                  width: 500,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(
                                        Base64Decoder().convert(
                                            base64image!.split(',').last),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 375,
                                  width: 500,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(urlImage),
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
                                itemCount: layoutList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == layoutList.length) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          getImage().then((value) {
                                            setState(() {
                                              otherPict = true;
                                              emptyImage = false;
                                              widget.setLayout!(
                                                "OTHERS",
                                                "",
                                                base64image,
                                                "",
                                                true,
                                              );
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
                                      onTap: () {
                                        setState(() {
                                          // final ByteData imageData =
                                          //     await NetworkAssetBundle(
                                          //             Uri.parse(
                                          //                 layoutList[index]
                                          //                     ['LayoutImg']))
                                          //         .load("");
                                          // final Uint8List bytes =
                                          //     imageData.buffer.asUint8List();
                                          // print(bytes);
                                          emptyImage = false;
                                          otherPict = false;
                                          urlImage =
                                              layoutList[index]['LayoutImg'];
                                          widget.setLayout!(
                                            layoutList[index]['LayoutName'],
                                            layoutList[index]['LayoutID']
                                                .toString(),
                                            "",
                                            urlImage,
                                            false,
                                          );
                                        });
                                      },
                                      child: Container(
                                        height: 100,
                                        // color: Colors.amber,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              layoutList[index]['LayoutImg'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
