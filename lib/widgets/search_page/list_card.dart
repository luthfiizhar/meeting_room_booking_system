import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';

class ListRoomContainer extends StatelessWidget {
  const ListRoomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Container(
        width: 730,
        height: 210,
        decoration: BoxDecoration(
          color: culturedWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: lightGray,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 210,
                    maxWidth: 225,
                  ),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      // image: DecorationImage(
                      //   image: AssetImage('assets/103.jpg'),
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 25,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '103',
                          style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 20,
                            height: 1.3,
                            color: eerieBlack,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                MdiIcons.alarm,
                                size: 18,
                                color: davysGray,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '12:00 - 13:00',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        height: 1.3,
                                        color: davysGray,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Available for 1 hour',
                                      style: TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        height: 1.3,
                                        color: spanishGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          children: [
                            const Icon(
                              MdiIcons.accountMultipleOutline,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              '2 - 6 Person',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                                color: davysGray,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            const Icon(
                              MdiIcons.officeBuilding,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              '1st Floor',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                                color: davysGray,
                              ),
                            ),
                            const SizedBox(
                              width: 90,
                            ),
                            const Icon(
                              MdiIcons.television,
                              size: 18,
                              color: davysGray,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Text(
                              'TV & Camera',
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                                color: davysGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: RegularButton(
                text: 'Book',
                disabled: false,
                onTap: () {
                  // context.go('/home/booking');
                  context.goNamed('booking', params: {
                    "roomId": '103',
                    'date': '01/11/2022',
                    'startTime': '10:30',
                    'endTime': '11.30',
                    'participant': '5',
                    'facilities': '[tv,camera]',
                    'roomType': 'audi'
                  });
                },
                padding: ButtonSize().smallSize(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
