import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class FooterWeb extends StatelessWidget {
  const FooterWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 75,
      decoration: const BoxDecoration(
        // border: Border(
        //     top: BorderSide(
        //   color: eerieBlack,
        // )),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(10),
        //   topRight: Radius.circular(10),
        // ),
        color: culturedWhite,
      ),
      // color: eerieBlack,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Positioned(
            top: 10,
            left: 40,
            child: Container(
              // color: Colors.red,
              width: 170,
              height: 55,
              child: Image.asset(
                'assets/navbarlogo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            // alignment: Alignment.center,
            top: 28,
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
            top: 28,
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

class FooterWebMobile extends StatelessWidget {
  const FooterWebMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 120,
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        color: platinum,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 125,
              child: Image.asset('assets/navbarlogo.png'),
            ),
            SizedBox(
              width: 220,
              child: Text(
                '@Copyright Kawan Lama Group 2022.',
                style: helveticaText.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: davysGray,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 220,
              child: Text(
                'All Rights Reserved.',
                style: helveticaText.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: davysGray,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 240,
              child: Text(
                'Facility Management. 2022.',
                style: helveticaText.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: davysGray,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
