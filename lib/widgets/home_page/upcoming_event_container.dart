import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';

class UpcomingEventContainer extends StatelessWidget {
  UpcomingEventContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // constraints: const BoxConstraints(
      //   maxWidth: 780,
      //   minWidth: 780,
      //   maxHeight: 200,
      //   minHeight: 200,
      // ),
      constraints: homeLeftSideConstrains,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22.5, horizontal: 35),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/social_hub.jpg'),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
            opacity: 0.3,
          ),
          color: eerieBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Upcoming Event',
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: white,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'SEPT',
                      style: helveticaText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: culturedWhite,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '17',
                      style: helveticaText.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: culturedWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 13,
                ),
                const SizedBox(
                  height: 50,
                  child: VerticalDivider(
                    thickness: 1,
                    color: culturedWhite,
                  ),
                ),
                const SizedBox(
                  width: 13,
                ),
                Text(
                  'Kawan Lama Summit 2022',
                  style: helveticaText.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: culturedWhite,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Auditorium 3 at 09:00 - 17:00 WIB',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: culturedWhite,
                  ),
                ),
                TransparentBorderedWhiteButton(
                  disabled: false,
                  onTap: () {},
                  text: 'See Details',
                  padding: ButtonSize().mediumSize(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
