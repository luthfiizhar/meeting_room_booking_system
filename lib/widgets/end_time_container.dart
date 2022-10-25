import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class EndTimeContainer extends StatelessWidget {
  EndTimeContainer({
    this.setEndTimeStatus,
    this.setEndTime,
    this.items,
    this.setTime,
    this.startTime,
  });

  List? items;
  Function? setEndTimeStatus;
  Function? setEndTime;
  Function? setTime;
  String? startTime;

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
            color: culturedWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
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
                        : const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Divider(),
                          ),
                    Text(
                      items![index],
                      style: const TextStyle(
                        color: davysGray,
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
    );
  }
}
