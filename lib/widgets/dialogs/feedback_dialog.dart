import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
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

  int selectedValue = 99;
  String comment = "";

  List<FeedBackIcon> optionEmoticon = [
    FeedBackIcon(
      index: 0,
      value: "Bad",
      iconLocation: 'assets/feedback_bad.png',
      selectedColor: orangeAccent,
      notSelectedColor: davysGray,
      isSelected: false,
    ),
    FeedBackIcon(
      index: 1,
      value: "Neutral",
      iconLocation: 'assets/feedback_neutral.png',
      selectedColor: blueAccent,
      notSelectedColor: davysGray,
      isSelected: false,
    ),
    FeedBackIcon(
      index: 2,
      value: "Good",
      iconLocation: 'assets/feedback_good.png',
      selectedColor: greenAcent,
      notSelectedColor: davysGray,
      isSelected: false,
    ),
  ];

  onChange(int index) {
    switch (index) {
      case 0:
        selectedValue = 0;
        break;
      case 1:
        selectedValue = 1;
        break;
      case 2:
        selectedValue = 2;
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
          minHeight: 450,
          maxHeight: 500,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 30,
          ),
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
                child: Wrap(
                  spacing: 60,
                  children: optionEmoticon
                      .asMap()
                      .map((index, element) => MapEntry(
                            index,
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: InkWell(
                                onTap: () {
                                  onChange(index);
                                },
                                child: FeedBackIcons(
                                  index: index,
                                  value: element.value,
                                  selectedColor: element.selectedColor,
                                  isSelected: selectedValue == index,
                                  iconLocation: element.iconLocation,
                                ),
                              ),
                            ),
                          ))
                      .values
                      .toList(),
                ),
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
                  RegularButton(
                    text: 'Submit',
                    disabled: false,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 65, vertical: 20),
                    onTap: () {
                      // Navigator.of(context).pop();
                    },
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

class FeedBackIcons extends StatelessWidget {
  FeedBackIcons({
    super.key,
    this.index = 0,
    this.value = "",
    this.iconLocation = "",
    this.isSelected = false,
    this.selectedColor = greenAcent,
  });

  int? index;
  Color? selectedColor;
  String? value;
  String? iconLocation;
  bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: ImageIcon(
        AssetImage(iconLocation!),
        color: !isSelected! ? platinum : selectedColor,
      ),
    );
  }
}

class FeedBackIcon {
  FeedBackIcon({
    this.index = 0,
    this.value = "",
    this.iconLocation,
    this.selectedColor = greenAcent,
    this.notSelectedColor = platinum,
    this.isSelected = false,
  });

  int? index;
  String? value;
  Color? selectedColor;
  Color? notSelectedColor;
  String? iconLocation;
  bool? isSelected;
}
