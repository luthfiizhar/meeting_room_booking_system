import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class FooterWeb extends StatelessWidget {
  const FooterWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 115,
      decoration: const BoxDecoration(
        // border: Border(
        //     top: BorderSide(
        //   color: eerieBlack,
        // )),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(10),
        //   topRight: Radius.circular(10),
        // ),
        color: white,
      ),
      // color: eerieBlack,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Positioned(
            top: 20,
            left: 0,
            child: Container(
              // color: Colors.red,
              width: 230,
              height: 80,
              child: SvgPicture.asset(
                'assets/klg_logo_tagline_black.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            // alignment: Alignment.center,
            top: 49,
            left: 100,
            right: 100,
            child: Container(
              // color: Colors.amber,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '@Copyright Kawan Lama Group 2022. All Rights Reserved.',
                  style: TextStyle(
                    fontSize: 16,
                    color: davysGray,
                    fontWeight: FontWeight.w300,
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 49,
            right: 40,
            child: Container(
              // color: Colors.pink,
              child: const Text(
                'Facility Management. 2022.',
                style: TextStyle(
                  fontSize: 16,
                  color: davysGray,
                  fontWeight: FontWeight.w300,
                  height: 1.15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
