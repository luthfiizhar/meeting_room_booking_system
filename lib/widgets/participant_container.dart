import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class ParticipantContainer extends StatefulWidget {
  ParticipantContainer({
    super.key,
    this.setParticipantStatus,
    this.onChangeParticipant,
    this.isDark = true,
    this.participantValue = 2,
  });

  Function? onChangeParticipant;
  Function? setParticipantStatus;
  bool isDark;
  double participantValue;

  @override
  State<ParticipantContainer> createState() => _ParticipantContainerState();
}

class _ParticipantContainerState extends State<ParticipantContainer> {
  int? length = 5;

  late double participantValue;

  // List? items = [
  List? items = ['2', '3', '4', '5', '6', '7', '8', '9', '>10'];

  ScrollController? participantScroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    participantValue = widget.participantValue;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 80,
        maxWidth: 300,
        maxHeight: 75,
        minHeight: 75,
      ),
      child: Container(
        width: double.infinity,
        // height: double.infinity,

        decoration: BoxDecoration(
          color: widget.isDark ? eerieBlack : culturedWhite,
          borderRadius: BorderRadius.circular(10),
          border: widget.isDark
              ? null
              : Border.all(
                  color: lightGray,
                  width: 1,
                ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Slider(
            activeColor: culturedWhite,
            inactiveColor: davysGray,
            onChanged: (value) {
              setState(() {
                participantValue = value;
              });
              String stringValue = "";
              if (participantValue == 10) {
                stringValue = '>$participantValue';
              } else {
                stringValue = '$participantValue';
              }
              widget.onChangeParticipant!(stringValue, value);
            },
            value: participantValue,
            min: 0,
            max: 10,
            divisions: 10,
            label: participantValue == 10
                ? '>$participantValue'
                : '$participantValue',
          ),
        ),
        // child: RawScrollbar(
        //   controller: participantScroll,
        //   thumbColor: platinum,
        //   radius: const Radius.circular(10),
        //   thickness: 10,
        //   child: SingleChildScrollView(
        //     controller: participantScroll,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 20,
        //         vertical: 20,
        //       ),
        //       child: Column(
        //         children: [
        //           ListView.builder(
        //             itemCount: items!.length,
        //             shrinkWrap: true,
        //             itemBuilder: (context, index) {
        //               return InkWell(
        //                 onTap: () {
        //                   onChangeParticipant!(items![index]);
        //                   setParticipantStatus!(false);
        //                 },
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   // mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     index == 0 || index == items!.length
        //                         ? const SizedBox()
        //                         : Padding(
        //                             padding: const EdgeInsets.symmetric(
        //                               vertical: 10,
        //                             ),
        //                             child: Divider(
        //                               color: isDark ? platinum : davysGray,
        //                             ),
        //                           ),
        //                     Text(
        //                       items![index],
        //                       style: TextStyle(
        //                         color: isDark ? platinum : davysGray,
        //                         fontSize: 16,
        //                         height: 1.3,
        //                         fontWeight: FontWeight.w300,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             },
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
