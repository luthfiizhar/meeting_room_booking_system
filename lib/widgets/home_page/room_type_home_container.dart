import "package:flutter/material.dart";
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class RoomTypeContainerHomePage extends StatelessWidget {
  RoomTypeContainerHomePage({
    super.key,
    this.setContainerStatus,
    this.changeRoomType,
    this.roomTypeList,
    this.roomTypeName = "",
    this.roomTypeValue = "",
  });

  Function? setContainerStatus;
  Function? changeRoomType;
  List? roomTypeList;
  String roomTypeName;
  String roomTypeValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: platinum,
          width: 1,
        ),
        color: white,
      ),
      // child: SizedBox(
      //   width: double.infinity,
      //   height: 150,
      //   child: ListView.builder(
      //     itemCount: roomTypeList!.length,
      //     shrinkWrap: true,
      //     scrollDirection: Axis.horizontal,
      //     itemBuilder: (context, index) {
      //       return Padding(
      //         padding: EdgeInsets.only(
      //             right: index != roomTypeList!.length - 1 ? 20 : 0),
      //         child: InkWell(
      //           onTap: () {},
      //           child: choices(
      //             roomTypeList![index]['Name'],
      //             roomTypeList![index]['Image'],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
      child: Row(
        children: roomTypeList!
            .asMap()
            .map((index, e) {
              return MapEntry(
                index,
                Padding(
                  padding: EdgeInsets.only(
                    right: index + 1 != roomTypeList!.length ? 20 : 0,
                  ),
                  child: InkWell(
                    onTap: () {
                      changeRoomType!(e['Value'], e['Name'], e['Image']);
                      setContainerStatus!(false);
                    },
                    child: choices(e['Name'], e['Image']),
                  ),
                ),
              );
            })
            .values
            .toList(),
        // children: [

        //   InkWell(
        //     onTap: () {
        //       changeRoomType!('MeetingRoom', 'Meeting Room', '');
        //       setContainerStatus!(false);
        //     },
        //     child: choices('Meeting Room', ''),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        //   InkWell(
        //     onTap: () {
        //       changeRoomType!('Auditorium', 'Auditorium', '');
        //       setContainerStatus!(false);
        //     },
        //     child: choices('Auditorium', ''),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        //   InkWell(
        //     onTap: () {
        //       changeRoomType!('SocialHub', 'Social Hub', '');
        //       setContainerStatus!(false);
        //     },
        //     child: choices('Social Hub', ''),
        //   ),
        // ],
      ),
    );
  }

  Widget choices(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: davysGray,
            image: DecorationImage(
              image: NetworkImage(
                url,
                scale: 0.2,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: helveticaText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }
}
