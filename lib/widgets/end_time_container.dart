import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class EndTimeContainer extends StatelessWidget {
  EndTimeContainer({
    this.setEndTimeStatus,
    this.setEndTime,
    this.items,
    this.setTime,
    this.startTime,
    this.isDark = true,
  });

  List? items;
  Function? setEndTimeStatus;
  Function? setEndTime;
  Function? setTime;
  String? startTime;
  bool isDark;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 85,
        maxWidth: 150,
        maxHeight: 300,
      ),
      child: GestureDetector(
        onTap: () {},
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
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.builder(
              // physics: NeverScrollableScrollPhysics(),
              itemCount: items!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    // onChangeParticipant!(items![index]);
                    // setParticipantStatus!(false);
                    setEndTimeStatus!(false);
                    setEndTime!(items![index]);
                    setTime!(startTime!, items![index]);
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
        ),
      ),
    );
  }
}
