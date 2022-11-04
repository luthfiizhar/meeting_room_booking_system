import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class ParticipantContainer extends StatelessWidget {
  ParticipantContainer({
    super.key,
    this.setParticipantStatus,
    this.onChangeParticipant,
    this.isDark = true,
  });

  Function? onChangeParticipant;
  Function? setParticipantStatus;
  int? length = 5;
  bool isDark;
  // List? items = [
  //   '1 - 3',
  //   '4 - 6',
  //   '7 - 10',
  //   'More than 10',
  // ];
  List? items = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '>10'];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 70,
        maxWidth: 150,
        maxHeight: 300,
      ),
      child: Container(
        width: double.minPositive,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: isDark ? eerieBlack : culturedWhite,
          borderRadius: BorderRadius.circular(10),
          border: isDark
              ? null
              : Border.all(
                  color: lightGray,
                  width: 1,
                ),
        ),
        child: ListView.builder(
          itemCount: items!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                onChangeParticipant!(items![index]);
                setParticipantStatus!(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  index == 0 || index == items!.length
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Divider(
                            color: isDark ? platinum : davysGray,
                          ),
                        ),
                  Text(
                    items![index],
                    style: TextStyle(
                      color: isDark ? platinum : davysGray,
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
