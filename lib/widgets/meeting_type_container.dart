import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class MeetingTypeContainer extends StatelessWidget {
  MeetingTypeContainer({
    super.key,
    this.selectedMeetingType,
    this.setMeetingType,
    this.meetingTypeStatus,
    this.setMeetingTypeStatus,
    this.meetingType,
  });

  String? selectedMeetingType;
  Function? setMeetingTypeStatus;
  Function? setMeetingType;
  bool? meetingTypeStatus;

  // List typeChoices = [
  //   {'id': '1', 'name': 'Meeting Room'},
  //   {'id': '2', 'name': 'Auditorium'},
  //   {'id': '3', 'name': 'SocialHub'},
  // ];
  List? meetingType;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 180,
        maxWidth: 160,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: eerieBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: meetingType!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setMeetingType!(meetingType![index]['Value'],
                    meetingType![index]['Name'], meetingType![index]['Image']);
                setMeetingTypeStatus!(false);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index == 0 || index == meetingType!.length
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Divider(
                            color: culturedWhite,
                          ),
                        ),
                  Text(
                    meetingType![index]['Name'],
                    style: const TextStyle(
                      color: culturedWhite,
                      fontFamily: 'Helvetica',
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
