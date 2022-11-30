import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class LeftFeatureContainer extends StatelessWidget {
  LeftFeatureContainer({
    super.key,
    this.title = "",
    this.content = "",
    this.backgroundImage,
    this.icon,
    this.backgroundColor = davysGray,
  });

  String title;
  String content;
  Image? icon;
  Image? backgroundImage;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 750,
          height: 250,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 65,
            vertical: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon!,
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: culturedWhite,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                content,
                style: helveticaText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: culturedWhite,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 330,
          height: 250,
          decoration: BoxDecoration(
            color: davysGray,
            // image: DecorationImage(
            //   image: backgroundImage!.image,
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ],
    );
  }
}

class RightFeatureContainer extends StatelessWidget {
  RightFeatureContainer({
    super.key,
    this.title = "",
    this.content = "",
    this.backgroundImage,
    this.icon,
    this.backgroundColor = culturedWhite,
  });

  String title;
  String content;
  Image? icon;
  Image? backgroundImage;
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 330,
          height: 250,
          color: backgroundColor,
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 750,
          height: 250,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 65,
            vertical: 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon!,
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    title,
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: eerieBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                content,
                style: helveticaText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
