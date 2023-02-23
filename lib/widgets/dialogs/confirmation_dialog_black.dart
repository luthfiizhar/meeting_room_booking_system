import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_white.dart';

class ConfirmDialogBlack extends StatelessWidget {
  const ConfirmDialogBlack({
    required this.title,
    required this.contentText,
    this.onTapConfirm,
  });

  final String? title;
  final String? contentText;
  final VoidCallback? onTapConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: eerieBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          minWidth: 560,
          minHeight: 200,
          maxHeight: double.infinity,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Stack(
            children: [
              Container(
                // color: Colors.amber,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title!,
                          style: titlePage.copyWith(
                            color: culturedWhite,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contentText!,
                          style: bodyText.copyWith(
                            color: culturedWhite,
                            fontWeight: FontWeight.w300,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     // SizedBox(),
                    //     TransparentButtonWhite(
                    //       text: 'Cancel',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     WhiteRegularButton(
                    //       text: 'Confirm',
                    //       onTap: () {},
                    //       padding: ButtonSize().smallSize(),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(),
                    TransparentButtonWhite(
                      text: 'Cancel',
                      onTap: () {
                        Navigator.of(context).pop(false);
                      },
                      padding: ButtonSize().mediumSize(),
                      disabled: false,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    WhiteRegularButton(
                      text: 'Confirm',
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      padding: ButtonSize().mediumSize(),
                      disabled: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
