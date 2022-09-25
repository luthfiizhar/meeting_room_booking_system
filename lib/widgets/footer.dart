import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class FooterWeb extends StatelessWidget {
  const FooterWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 20,
      decoration: BoxDecoration(
          // border: Border()
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(10),
          //   topRight: Radius.circular(10),
          // ),
          color: eerieBlack),
      // color: eerieBlack,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              // color: Colors.red,
              width: 60,
              height: 20,
              child: SvgPicture.asset(
                'assets/klg_main_logo_white.svg',
                // color: Colors.white,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
