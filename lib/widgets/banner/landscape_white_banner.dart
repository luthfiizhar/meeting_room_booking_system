import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class WhiteBannerLandscape extends StatelessWidget {
  const WhiteBannerLandscape({
    this.title,
    this.subtitle,
    this.imagePath,
    this.fit = BoxFit.cover,
    this.borderColor = Colors.transparent,
    this.backgroundColor = culturedWhite,
    this.isUseGradient = true,
  });

  final String? title;
  final String? subtitle;
  final String? imagePath;
  final BoxFit? fit;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool? isUseGradient;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 1000,
        minWidth: 500,
        maxHeight: 100,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor!,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 450,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 26,
                          horizontal: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title!,
                              style: helveticaText.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: eerieBlack,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              subtitle!,
                              style: helveticaText.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: eerieBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 14,
                        right: 13,
                        child: Wrap(
                          children: [
                            Text(
                              'See more',
                              style: helveticaText.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: eerieBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Icon(
                              FontAwesomeIcons.arrowRightLong,
                              color: eerieBlack,
                              size: 12,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imagePath!),
                        fit: fit,
                      ),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: backgroundColor,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isUseGradient!
                            ? LinearGradient(
                                end: Alignment.centerLeft,
                                begin: Alignment.centerRight,
                                stops: [0, 0.5, 0.75, 1],
                                colors: [
                                  Color.fromRGBO(255, 255, 255, 0),
                                  Color.fromRGBO(255, 255, 255, 0),
                                  Color.fromRGBO(255, 255, 255, 0.28),
                                  backgroundColor!,
                                ],
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: eerieBlack,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Featured',
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: culturedWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
