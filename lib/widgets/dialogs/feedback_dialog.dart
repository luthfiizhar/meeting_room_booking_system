import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();

  TextEditingController _comment = TextEditingController();
  FocusNode commentNode = FocusNode();

  bool isLoading = false;

  int selectedValue = 0;
  String comment = "";

  List<FeedBackIcon> optionEmoticon = [
    FeedBackIcon(
      index: 0,
      value: 1,
      iconLocation: 'assets/feedback_bad.png',
      selectedColor: orangeAccent,
      notSelectedColor: davysGray,
      isSelected: false,
    ),
    FeedBackIcon(
      index: 1,
      value: 2,
      iconLocation: 'assets/feedback_neutral.png',
      selectedColor: blueAccent,
      notSelectedColor: davysGray,
      isSelected: false,
    ),
    FeedBackIcon(
      index: 2,
      value: 3,
      iconLocation: 'assets/feedback_good.png',
      selectedColor: greenAcent,
      notSelectedColor: davysGray,
      isSelected: false,
    ),
  ];

  onChange(int index) {
    switch (index) {
      case 0:
        selectedValue = 1;
        break;
      case 1:
        selectedValue = 2;
        break;
      case 2:
        selectedValue = 3;
        break;
      default:
        selectedValue = 99;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    commentNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _comment.dispose();
    commentNode.removeListener(() {});
    commentNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 450,
          maxWidth: 450,
          minHeight: 300,
          // maxHeight: 500,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 30,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Give us feedback!',
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
                  'How do you feel about the system so far?',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: eerieBlack,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RatingBar.builder(
                    allowHalfRating: false,
                    minRating: 1,
                    maxRating: 5,
                    initialRating: selectedValue.toDouble(),
                    itemCount: 5,
                    itemSize: 50,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return const Icon(
                        Icons.star,
                        color: yellow,
                      );
                    },
                    onRatingUpdate: (value) {
                      print(value);
                      selectedValue = value.toInt();
                    },
                  ),
                  // child: Wrap(
                  //   spacing: 60,
                  //   children: optionEmoticon
                  //       .asMap()
                  //       .map((index, element) => MapEntry(
                  //             index,
                  //             Builder(builder: (context) {
                  //               return SizedBox(
                  //                 height: 70,
                  //                 width: 70,
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     onChange(index);
                  //                   },
                  //                   child: FeedBackIcons(
                  //                     index: index,
                  //                     value: element.value,
                  //                     selectedColor: element.selectedColor,
                  //                     isSelected:
                  //                         selectedValue == element.value,
                  //                     iconLocation: element.iconLocation,
                  //                   ),
                  //                 ),
                  //               );
                  //             }),
                  //           ))
                  //       .values
                  //       .toList(),
                  // ),
                ),
                const SizedBox(
                  height: 35,
                ),
                BlackInputField(
                  controller: _comment,
                  focusNode: commentNode,
                  enabled: true,
                  maxLines: 4,
                  hintText: 'Tell us more...',
                  onSaved: (newValue) {
                    comment = newValue.toString();
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TransparentButtonBlack(
                      text: 'I\'ll do it later',
                      disabled: false,
                      padding: ButtonSize().smallSize(),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: eerieBlack,
                          )
                        : RegularButton(
                            text: 'Submit',
                            disabled: false,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 65, vertical: 20),
                            onTap: () {
                              setState(() {
                                isLoading = true;
                              });
                              if (formKey.currentState!.validate() &&
                                  selectedValue > 0) {
                                formKey.currentState!.save();
                                apiReq
                                    .sendFeedback(
                                        selectedValue,
                                        comment
                                            .toString()
                                            .replaceAll('\n', '\\n'))
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value['Status'].toString() == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                      ),
                                    ).then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  } else if (value['Status'].toString() ==
                                      "401") {
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
                                        isSuccess: false,
                                      ),
                                    );
                                  }
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: 'Error sendFeedback',
                                      contentText: error.toString(),
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              } else {
                                isLoading = false;
                                setState(() {});
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialogBlack(
                                    title: 'Failed',
                                    contentText: 'Please input your rating.',
                                    isSuccess: false,
                                  ),
                                );
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
    );
  }
}

class FeedBackIcons extends StatefulWidget {
  FeedBackIcons({
    super.key,
    this.index = 0,
    this.value = 3,
    this.iconLocation = "",
    this.isSelected = false,
    this.selectedColor = greenAcent,
  });

  int? index;
  Color? selectedColor;
  int? value;
  String? iconLocation;
  bool? isSelected;

  @override
  State<FeedBackIcons> createState() => _FeedBackIconsState();
}

class _FeedBackIconsState extends State<FeedBackIcons> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
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
        height: 70,
        width: 70,
        child: ImageIcon(
          AssetImage(widget.iconLocation!),
          color: isHover
              ? widget.selectedColor
              : !widget.isSelected!
                  ? platinum
                  : widget.selectedColor,
        ),
      ),
    );
  }
}

class FeedBackIcon {
  FeedBackIcon({
    this.index = 0,
    this.value = 3,
    this.iconLocation,
    this.selectedColor = greenAcent,
    this.notSelectedColor = platinum,
    this.isSelected = false,
  });

  int? index;
  int? value;
  Color? selectedColor;
  Color? notSelectedColor;
  String? iconLocation;
  bool? isSelected;
}
