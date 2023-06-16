import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:shimmer/shimmer.dart';

class SelectLayoutDialog extends StatefulWidget {
  SelectLayoutDialog({
    super.key,
    this.setLayout,
    this.imaegUrl = "",
    this.imageBytes,
    this.isUpload = false,
    this.layoutBase64 = "",
    this.roomId = "",
  });

  Function? setLayout;
  String imaegUrl;
  Uint8List? imageBytes;
  String layoutBase64;
  bool isUpload;
  String roomId;

  @override
  State<SelectLayoutDialog> createState() => _SelectLayoutDialogState();
}

class _SelectLayoutDialogState extends State<SelectLayoutDialog> {
  ReqAPI apiReq = ReqAPI();
  List? availableLayout = ['1', '2', '3'];

  List<Layout> layoutList = [];

  String layoutName = "";
  String layoutId = "";

  bool upButtonVisible = false;
  bool downButtonVisible = true;
  bool otherPict = false;
  ScrollController _scrollController = ScrollController();

  int selectedLayout = 9999;

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
    if (widget.imaegUrl != "" || widget.imageBytes!.isEmpty) {
      setState(() {
        if (widget.isUpload) {
          emptyImage = false;
          otherPict = true;
          // webImage = widget.imageBytes;
          base64image = widget.layoutBase64;
        } else {
          emptyImage = false;
          otherPict = false;
          urlImage = widget.imaegUrl;
        }
      });
    } else {
      setState(() {
        emptyImage = true;
      });
    }
    apiReq.getLayoutList(widget.roomId).then((value) {
      print("layout api --> $value");
      if (value["Status"].toString() == "200") {
        setState(() {
          List result = value["Data"];
          for (var element in result) {
            layoutList.add(Layout(
              imageUrl: element['LayoutImg'],
              layoutId: element['LayoutID'],
              layoutName: element['LayoutName'],
              isSelected: false,
            ));
          }
        });
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
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
    print("empty image --> $emptyImage");
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
          maxHeight: 600,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        color: platinum,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      height: 375,
                      width: 500,
                      child: Center(
                        child: emptyImage
                            ? Text(
                                'No Layout Selected',
                                style: helveticaText.copyWith(
                                  color: davysGray,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
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
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                // : Container(
                                //     height: 375,
                                //     width: 500,
                                //     decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //         image: NetworkImage(urlImage),
                                //         fit: BoxFit.cover,
                                //       ),
                                //     ),
                                //   ),
                                : urlImage == ""
                                    ? const SizedBox()
                                    : CachedNetworkImage(
                                        imageUrl: urlImage,
                                        placeholder: (context, url) {
                                          return Shimmer(
                                            gradient: const LinearGradient(
                                              colors: [
                                                platinum,
                                                grayx11,
                                                davysGray
                                              ],
                                            ),
                                            direction: ShimmerDirection.rtl,
                                            child: Container(
                                              height: 375,
                                              width: 500,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7.5),
                                              ),
                                            ),
                                          );
                                        },
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: 375,
                                            width: 500,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
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
                                                selectedLayout = 9999;
                                                otherPict = true;
                                                emptyImage = false;
                                                layoutName = "OTHERS";
                                                layoutId = "";
                                                urlImage = "";
                                                // widget.setLayout!(
                                                //   "OTHERS",
                                                //   "",
                                                //   base64image,
                                                //   "",
                                                //   true,
                                                // );
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
                                              radius:
                                                  const Radius.circular(7.5),
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
                                                      'Add Layout',
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
                                            selectedLayout =
                                                layoutList[index].layoutId;
                                            emptyImage = false;
                                            otherPict = false;
                                            urlImage =
                                                layoutList[index].imageUrl;
                                            layoutName =
                                                layoutList[index].layoutName;
                                            layoutId = layoutList[index]
                                                .layoutId
                                                .toString();
                                            base64image = "";
                                            // widget.setLayout!(
                                            //   layoutList[index]['LayoutName'],
                                            //   layoutList[index]['LayoutID']
                                            //       .toString(),
                                            //   "",
                                            //   urlImage,
                                            //   false,
                                            // );
                                          });
                                        },
                                        child: Container(
                                          height: 100,
                                          // color: Colors.amber,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: selectedLayout ==
                                                    layoutList[index].layoutId
                                                ? Border.all(
                                                    color: greenAcent,
                                                    width: 1,
                                                  )
                                                : null,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                layoutList[index].imageUrl,
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
                            SizedBox(
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
                                              _scrollController.offset - 125,
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
                                              _scrollController.offset + 125,
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
                      padding: ButtonSize().smallSize(),
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    RegularButton(
                      text: 'Confirm',
                      disabled: false,
                      padding: ButtonSize().smallSize(),
                      onTap: () async {
                        await widget.setLayout!(
                          layoutName,
                          layoutId,
                          base64image,
                          urlImage,
                          otherPict,
                        );
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Layout {
  Layout({
    this.layoutName = "",
    this.layoutId = 0,
    this.imageUrl = "",
    this.isSelected = false,
  });

  String layoutName;
  int layoutId;
  String imageUrl;
  bool isSelected;
}
