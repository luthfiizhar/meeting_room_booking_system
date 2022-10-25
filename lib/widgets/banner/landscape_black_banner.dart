import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BlackBannerLandscape extends StatelessWidget {
  const BlackBannerLandscape({
    this.title,
    this.subtitle,
    this.imagePath,
  });

  final String? title;
  final String? subtitle;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 800,
        maxHeight: 100,
      ),
      child: Row(
        children: [
          Container(
            height: double.infinity,
            width: 450,
            decoration: BoxDecoration(
              color: eerieBlack,
              borderRadius: BorderRadius.only(
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
                        style: const TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: culturedWhite,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: culturedWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 14,
                  right: 13,
                  child: Wrap(
                    children: const [
                      Text(
                        'See more',
                        style: TextStyle(
                          fontFamily: 'Helvetica',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: culturedWhite,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Icon(
                        FontAwesomeIcons.arrowRightLong,
                        color: culturedWhite,
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
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10)),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.centerLeft,
                  begin: Alignment.centerRight,
                  stops: [0, 0.5, 0.75, 1],
                  colors: [
                    Color.fromRGBO(29, 29, 29, 0),
                    Color.fromRGBO(29, 29, 29, 0),
                    Color.fromRGBO(29, 29, 29, 0.5),
                    eerieBlack,
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
