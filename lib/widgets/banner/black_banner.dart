import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BlackBanner extends StatelessWidget {
  const BlackBanner({
    required this.title,
    this.subtitle,
    this.imagePath,
  });

  final String? title;
  final String? subtitle;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 325),
      child: Column(
        children: [
          Container(
            height: 325,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath!),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.bottomCenter,
                  begin: Alignment.topCenter,
                  stops: [0, 0.5, 0.75, 1],
                  colors: [
                    Color.fromRGBO(29, 29, 29, 0),
                    Color.fromRGBO(29, 29, 29, 0),
                    Color.fromRGBO(29, 29, 29, 0.5),
                    eerieBlack,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: eerieBlack,
                      ),
                      child: Text(
                        'Featured',
                        style: TextStyle(
                          color: culturedWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 152,
            decoration: const BoxDecoration(
              color: eerieBlack,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: const TextStyle(
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
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: culturedWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Wrap(
                    children: const [
                      Text(
                        'See more',
                        style: TextStyle(
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
          )
        ],
      ),
    );
  }
}
