import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/detail_page/facility_item_detail.dart';
import 'package:meeting_room_booking_system/widgets/detail_page/food_item_detail.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
// import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';

class AdminDetailBooking extends StatefulWidget {
  AdminDetailBooking({
    super.key,
    this.bookingId,
  });

  String? bookingId;
  @override
  State<AdminDetailBooking> createState() => _AdminDetailBookingState();
}

class _AdminDetailBookingState extends State<AdminDetailBooking> {
  ReqAPI apiReq = ReqAPI();

  TextEditingController _notes = TextEditingController();
  FocusNode notesNode = FocusNode();

  String summary = "";
  String description = "";
  String roomType = "";
  String bookingType = "";

  String coverURL = "";

  String roomId = "";
  String bookingNip = "";
  String location = "";
  String floor = "";
  String eventDate = "";
  String eventTime = "";
  String startTime = "";
  String endTime = "";
  String duration = "";
  String participantTotal = "";
  String eventType = "";
  String repeat = "";
  String formattedDate = "";
  String repeatType = "";
  String monthAbs = "";
  String interval = "";
  String layoutName = "";
  String layoutImage = "";
  String bookingStatus = "";
  dynamic days;
  DateTime repeatEndDate = DateTime.now();

  String selectedDate = "";
  DateTime? bookingDate;

  String host = "";
  String hostEmail = "";
  String avaya = "";
  String phoneNumber = "";

  int bookingStep = 0;

  List guestInvited = [];
  List amenities = [];
  List foodAmenities = [];
  List bookingHistory = [];

  String additionalNotes = "";

  String imageLayout = "";

  bool isInitLoading = true;
  bool isCancelLoading = false;
  bool isAdmin = false;
  bool isPhoneShowed = false;
  bool isButtonShowed = true;

  String approvalNotes = "";

  approveAudi(String notes) {
    apiReq.approveAuditorium(widget.bookingId!, notes).then((value) {
      if (value['Status'] == "200") {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: true,
          ),
        );
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  rejectAudi(String notes) {
    apiReq.rejectAuditorium(widget.bookingId!, notes).then((value) {
      if (value['Status'] == "200") {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: true,
          ),
        );
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  resetStatus(bool value) {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiReq.getBookingDetail(widget.bookingId!).then((value) {
      // print("BookingDetail --> $value");
      if (value['Status'].toString() == "200") {
        setState(() {
          isInitLoading = false;
          roomId = value['Data']['RoomID'];
          bookingNip = value['Data']['EmpNIP'];
          coverURL = value['Data']['RoomPhotos'];
          summary = value['Data']['Summary'];
          description = value['Data']['Description'];
          roomType = value['Data']['RoomType'];
          bookingStatus = value['Data']['Status'];
          bookingType = value['Data']['BookingType'];

          startTime = value['Data']['BookingStartTime'];
          endTime = value['Data']['BookingEndTime'];
          location = value['Data']['RoomName'];
          floor = value['Data']['AreaName'];
          eventDate = value['Data']['BookingDate'];
          hostEmail = value['Data']['Email'];
          phoneNumber = value['Data']['PhoneNumber'];
          avaya = value['Data']['AvayaNumber'] ?? "";

          eventTime =
              "${value['Data']['BookingStartTime']} - ${value['Data']['BookingEndTime']} WIB";
          duration = value['Data']['Duration'];
          participantTotal = value['Data']['AttendantsNumber'].toString();
          eventType = value['Data']['MeetingType'];
          repeat = value['Data']['Repeat'];

          host = value['Data']['EmpName'];
          bookingStep = value['Data']['BookingStep'];

          layoutName = value['Data']['LayoutName'] ?? "";
          layoutImage = value['Data']['LayoutImg'] ?? "";

          amenities = value['Data']['Amenities'];
          foodAmenities = value['Data']['FoodAmenities'];

          guestInvited = value['Data']['Attendants'];

          additionalNotes = value['Data']['AdditionalNotes'] ?? "";

          bookingHistory = value['Data']['History'];
          repeatType = value['Data']['RepeatType'] ?? "NONE";
          if (bookingType == "RECURSIVE") {
            repeatEndDate = DateTime.parse(value['Data']['RepeatEndDate']);
            monthAbs = value['Data']['MonthAbsolute'].toString();
            days = value['Data']['Days'];
            interval = value['Data']['RepInterval'].toString();
          }
          formattedDate = DateFormat('yyyy-mm-dd')
              .format(DateTime.parse(value['Data']['BookingDateOriginal']));
          selectedDate = value['Data']['BookingDateOriginal'];
          DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
          bookingDate = format.parse(
              "${value['Data']['BookingDateOriginal']} ${value['Data']['BookingStartTime']}:00");
          // bookingDate = DateTime.parse(value['Data']['BookingDateOriginal']);
          // if (bookingStatus == "APPROVED") {
          //   isButtonShowed = false;
          // }
        });
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
        if (value['Status'].toString() == "401") {
          context.go('/login');
        }
      }
      apiReq.getUserProfile().then((value) {
        if (value["Status"].toString() == "200") {
          if (value["Data"]["Admin"].toString() == "1") {
            setState(() {
              isAdmin = true;
              isPhoneShowed = true;
              isButtonShowed = true;
              if (bookingStatus != "WAITING APPROVAL") {
                isButtonShowed = false;
              }
              // if (bookingDate!.isBefore(DateTime.now())) {
              //   isButtonShowed = false;
              // }
            });
          } else {
            setState(() {
              if (bookingNip == value["Data"]["EmpNIP"]) {
                isPhoneShowed = true;
                isButtonShowed = true;
                if (bookingStatus != "WAITING APPROVAL") {
                  isButtonShowed = false;
                }
                // if (bookingDate!.isBefore(DateTime.now())) {
                //   isButtonShowed = false;
                // }
              }
            });
          }
          // print('isButton Showed $isButtonShowed');
          // print(bookingDate!.isBefore(DateTime.now()));
          // print(bookingDate);
          // print(DateTime.now());
        } else if (value['Status'].toString() == "401") {
          showDialog(
            context: context,
            builder: (context) => TokenExpiredDialog(
              title: value['Title'],
              contentText: value['Message'],
              isSuccess: false,
            ),
          );
        }
      }).onError((error, stackTrace) {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: 'Error for getUserProfile()',
            contentText: error.toString(),
            isSuccess: false,
          ),
        );
      });
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  ScrollController scrollController = ScrollController();
  resetState() {
    setState(() {});
  }

  setDatePickerStatus(bool value) {}

  @override
  void dispose() {
    super.dispose();
    // scrollController.removeListener(() {});
    // scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 1200 ? mobile() : desktop();
  }

  Widget desktop() {
    return LayoutPageWeb(
      index: 3,
      scrollController: scrollController,
      setDatePickerStatus: setDatePickerStatus,
      resetState: resetState,
      child: isCancelLoading || isInitLoading
          ? const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: eerieBlack,
              ),
            )
          : ConstrainedBox(
              constraints: pageConstraints,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 1100,
                          height: 400,
                          decoration: BoxDecoration(
                            color: graySand,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(coverURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 300,
                          left: 183,
                        ),
                        child: Container(
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 0),
                                blurRadius: 40,
                                spreadRadius: 0,
                                color: eerieBlack.withOpacity(0.1),
                              ),
                            ],
                          ),
                          width: 1000,
                          // height: 1000,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 65,
                              vertical: 40,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  summary,
                                  style: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: eventDetailContainer(),
                                    ),
                                    const SizedBox(
                                      width: 60,
                                    ),
                                    Expanded(
                                      child: detailContainer2(),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Visibility(
                                  // visible: bookingStep > 1 ? false : true,
                                  visible: isButtonShowed ? true : false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RegularButton(
                                        text: 'Approve Event',
                                        disabled: false,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                AuditoriumNotesApprovalDialog(
                                              onConfirm: approveAudi,
                                            ),
                                          ).then((value) {
                                            context.goNamed('admin_list');
                                          });
                                        },
                                        padding: ButtonSize().mediumSize(),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      TransparentButtonBlack(
                                        text: 'Decline Event',
                                        disabled: false,
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                AuditoriumNotesApprovalDialog(
                                              onConfirm: rejectAudi,
                                            ),
                                          ).then((value) {
                                            context.goNamed('admin_list');
                                          });
                                        },
                                        padding: ButtonSize().mediumSize(),
                                      )
                                    ],
                                  ),
                                )
                                // ConstrainedBox(
                                //   constraints: const BoxConstraints(
                                //     minHeight: 65,
                                //     maxHeight: 65,
                                //     minWidth: 400,
                                //     maxWidth: 850,
                                //   ),
                                //   child: Container(
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 5,
                                //       vertical: 10,
                                //     ),
                                //     // width: 800,
                                //     height: 65,
                                //     decoration: BoxDecoration(
                                //       color: platinum,
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     child: Row(
                                //       crossAxisAlignment: CrossAxisAlignment.center,
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         // TransparentButtonBlack(
                                //         //   text: 'Email to User',
                                //         //   disabled: false,
                                //         //   onTap: () {},
                                //         //   padding: ButtonSize().mediumSize(),
                                //         // ),
                                //         // verticalDivider(),
                                //         // TransparentButtonBlack(
                                //         //   text: 'Trade',
                                //         //   disabled: false,
                                //         //   onTap: () {},
                                //         //   padding: ButtonSize().mediumSize(),
                                //         // ),
                                //         // verticalDivider(),
                                //         TransparentButtonBlack(
                                //           text: 'Edit Event',
                                //           disabled: false,
                                //           onTap: () {
                                //             print(roomId);
                                //             context.goNamed(
                                //               'booking',
                                //               params: {
                                //                 "roomId": roomId,
                                //                 'date': selectedDate.toString(),
                                //                 'startTime': startTime,
                                //                 'endTime': endTime,
                                //                 'participant': '1',
                                //                 'facilities': '[]',
                                //                 'roomType': 'meeting_room',
                                //                 'isEdit': 'true'
                                //               },
                                //               queryParams: {
                                //                 'date': selectedDate.toString(),
                                //                 'startTime': startTime,
                                //                 'endTime': endTime,
                                //                 'summary': summary,
                                //                 'description': description,
                                //                 'additionalNote': additionalNotes,
                                //                 'participant': '1',
                                //                 'facilities': '[]',
                                //                 'bookingType': bookingType,
                                //                 'guestInvited':
                                //                     guestInvited.toString(),
                                //                 'repeatEndDate':
                                //                     repeatEndDate.toString(),
                                //                 'days': days,
                                //                 'montAbs': monthAbs,
                                //                 'repeatType': repeatType,
                                //                 'interval': interval,
                                //                 'roomType': 'MeetingRoom',
                                //                 'layoutName': layoutName,
                                //                 'layoutImage': layoutImage,
                                //                 'bookingId': widget.bookingId,
                                //               },
                                //             );
                                //             // showDialog(
                                //             //   context: context,
                                //             //   builder: (context) =>
                                //             //       BookingRoomPageDialog(
                                //             //     summary: summary,
                                //             //     description: description,
                                //             //     additionalNote: additionalNotes,
                                //             //     invitedGuest: guestInvited,
                                //             //     totalParticipant: participantTotal,
                                //             //     roomId: roomId,
                                //             //     date: formattedDate,
                                //             //     startTime: startTime,
                                //             //     endTime: endTime,
                                //             //     facilities: amenities,
                                //             //     foodAmenities: foodAmenities,
                                //             //     participant: participantTotal,
                                //             //     roomType: roomType,
                                //             //     recurrent: [
                                //             //       {
                                //             //         'repeatEndDate': repeatEndDate,
                                //             //         'days': days,
                                //             //         'montAbs': monthAbs,
                                //             //         'repeatType': repeatType,
                                //             //         'interval': interval
                                //             //       }
                                //             //     ],
                                //             //   ),
                                //             // );
                                //           },
                                //           padding: ButtonSize().mediumSize(),
                                //         ),
                                //         verticalDivider(),
                                //         TransparentButtonBlack(
                                //           text: 'Cancel Event',
                                //           disabled: false,
                                //           onTap: () {
                                //             showDialog(
                                //               context: context,
                                //               builder: (context) =>
                                //                   const ConfirmDialogBlack(
                                //                 title: 'Cancel Booking',
                                //                 contentText:
                                //                     'Are you sure want cancel this booking?',
                                //               ),
                                //             ).then((value) {
                                //               setState(() {
                                //                 isCancelLoading = true;
                                //               });
                                //               if (value) {
                                //                 if (bookingType == "SINGLE") {
                                //                   deleteBooking(widget.bookingId!)
                                //                       .then((value) {
                                //                     print(value);
                                //                     setState(() {
                                //                       isCancelLoading = false;
                                //                     });
                                //                     if (value['Status'] == "200") {
                                //                       showDialog(
                                //                         context: context,
                                //                         builder: (context) =>
                                //                             AlertDialogBlack(
                                //                           title: value['Title'],
                                //                           contentText:
                                //                               value['Message'],
                                //                         ),
                                //                       ).then((value) {
                                //                         context.go('/rooms');
                                //                       });
                                //                     }
                                //                   }).onError((error, stackTrace) {
                                //                     showDialog(
                                //                       context: context,
                                //                       builder: (context) =>
                                //                           AlertDialogBlack(
                                //                         title:
                                //                             'Failed connect to API',
                                //                         contentText:
                                //                             error.toString(),
                                //                         isSuccess: false,
                                //                       ),
                                //                     );
                                //                   });
                                //                 }
                                //                 if (bookingType == "RECURRENT") {
                                //                   deleteBookingRecurrent(
                                //                           widget.bookingId!)
                                //                       .then((value) {
                                //                     print(value);
                                //                     if (value['Status'] == "200") {
                                //                       showDialog(
                                //                         context: context,
                                //                         builder: (context) =>
                                //                             AlertDialogBlack(
                                //                           title: value['Title'],
                                //                           contentText:
                                //                               value['Message'],
                                //                         ),
                                //                       ).then((value) {
                                //                         context.go('/rooms');
                                //                       });
                                //                     }
                                //                   }).onError((error, stackTrace) {
                                //                     showDialog(
                                //                       context: context,
                                //                       builder: (context) =>
                                //                           AlertDialogBlack(
                                //                         title:
                                //                             'Failed connect to API',
                                //                         contentText:
                                //                             error.toString(),
                                //                         isSuccess: false,
                                //                       ),
                                //                     );
                                //                   });
                                //                 }
                                //               }
                                //             });
                                //           },
                                //           padding: ButtonSize().mediumSize(),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
    );
  }

  Widget mobile() {
    return LayoutPageWebMobile(
      scrollController: scrollController,
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20,
        ),
        child: Column(
          children: [
            coverURL == ""
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: platinum,
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: coverURL,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: platinum,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summary,
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  eventDetailContainer(),
                  const SizedBox(
                    height: 25,
                  ),
                  detailContainer2()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  eventDetailContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        detailTitle('Event Detail'),
        divider(),
        detailContent('Location', location),
        divider2(),
        detailContent('Floor', floor),
        divider2(),
        detailContent('Event Date', eventDate),
        divider2(),
        detailContent('Event Time', eventTime),
        divider2(),
        detailContent('Duration', duration),
        divider2(),
        detailContent('Participant', '$participantTotal Person'),
        divider2(),
        detailContent('Event Type', eventType),
        divider2(),
        detailContent('Repeat', repeat),
        const SizedBox(
          height: 30,
        ),
        detailTitle('Host Info'),
        divider(),
        detailContent('Host', host),
        divider2(),
        detailContent('Email', hostEmail),
        divider2(),
        detailContent('Avaya', avaya),
        Visibility(
          visible: isAdmin
              ? true
              : isPhoneShowed
                  ? true
                  : false,
          child: Column(
            children: [
              divider2(),
              detailContent('Phone', phoneNumber),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        detailTitle('Guest Info'),
        divider(),
        guestInvited.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    'No guest invited',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: guestInvited.length,
                itemBuilder: (context, index) {
                  return Container(
                    // color: Colors.amber,
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            guestInvited[index]['AttendantsEmail'],
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_sharp,
                          color: greenAcent,
                          size: 18,
                        )
                      ],
                    ),
                    // child: ListTile(
                    //   leading: CircleAvatar(
                    //     radius: 15,
                    //     backgroundColor: Colors.blue,
                    //   ),
                    //   title: Text(
                    //     guestInvited[index]['AttendantsEmail'],
                    //     style: helveticaText.copyWith(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w300,
                    //       height: 1.3,
                    //       color: davysGray,
                    //     ),
                    //   ),
                    //   trailing: Icon(Icons.check_circle_sharp),
                    // ),
                  );
                },
              ),
        const SizedBox(
          height: 30,
        ),
        detailTitle('Additional Notes'),
        divider(),
        Text(
          additionalNotes == "" ? '-' : additionalNotes,
          style: helveticaText.copyWith(
            fontSize: 16,
            color: davysGray,
            fontWeight: FontWeight.w300,
          ),
        )
      ],
    );
  }

  detailContainer2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        detailTitle('Room Facility'),
        divider(),
        amenities.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    'No facilities requested',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: amenities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 125 / 165,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return RoomFacilityItemDetail(
                    result: amenities[index],
                  );
                },
              ),
        const SizedBox(
          height: 30,
        ),
        detailTitle('Food & Beverages'),
        divider(),
        foodAmenities.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    'No F&B requested',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                itemCount: foodAmenities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 125 / 145,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return FoodAmenitiesItemDetail(
                    result: foodAmenities[index],
                  );
                },
              ),

        const SizedBox(
          height: 30,
        ),
        Visibility(
          visible: roomType == "MeetingRoom" ? false : true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              detailTitle('Room Layout'),
              divider(),
              layoutImage == ""
                  ? SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                        child: Text(
                          'No Layout Submitted',
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: lightGray,
                          width: 1,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Image.network(layoutImage),
                      ),
                    ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),

        detailTitle('Booking Detail'),
        divider(),
        // bookingDetailSection(),
        bookingHistory.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    'No status',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: bookingHistory.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 0 : 10,
                          bottom: 10,
                        ),
                        child: bookingDetail(
                          bookingHistory[index]['EmpName'] ??
                              bookingHistory[index]['EmpNIP'],
                          bookingHistory[index]['Status'],
                          bookingHistory[index]['LogDate'],
                          bookingHistory[index]['Description'],
                        ),
                      ),
                      index == bookingHistory.length - 1
                          ? const SizedBox()
                          : const Divider(
                              color: lightGray,
                              thickness: 0.5,
                            )
                    ],
                  );
                },
              ),
      ],
    );
  }

  detailContent(String label, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: helveticaText.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: sonicSilver,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width < 1366 ? 200 : null,
          child: Text(
            content,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: davysGray,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Text detailTitle(String text) {
    return Text(
      text,
      style: helveticaText.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: orangeAccent,
      ),
    );
  }

  divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Divider(
        color: orangeAccent,
        thickness: 0.5,
      ),
    );
  }

  divider2() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 9.5,
      ),
      child: Divider(
        color: lightGray,
        thickness: 0.5,
      ),
    );
  }

  verticalDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 7.5,
      ),
      child: VerticalDivider(
        color: eerieBlack,
        thickness: 0.5,
      ),
    );
  }

  Widget bookingDetail(
      String name, String status, String logDate, String desc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            status,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
                ),
                textAlign: TextAlign.end,
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                desc,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: davysGray,
                ),
                textAlign: TextAlign.end,
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                logDate,
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AuditoriumNotesApprovalDialog extends StatefulWidget {
  AuditoriumNotesApprovalDialog({
    super.key,
    this.onConfirm,
    this.resetState,
    this.notes,
  });

  Function? onConfirm;
  Function? resetState;
  String? notes;

  @override
  State<AuditoriumNotesApprovalDialog> createState() =>
      _AuditoriumNotesApprovalDialogState();
}

class _AuditoriumNotesApprovalDialogState
    extends State<AuditoriumNotesApprovalDialog> {
  TextEditingController _notes = TextEditingController();
  FocusNode notesNode = FocusNode();

  String notes = "";

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    notesNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _notes.dispose();
    notesNode.removeListener(() {});
    notesNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: culturedWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          minWidth: 385,
          minHeight: 200,
          maxHeight: double.infinity,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: titlePage.copyWith(
                      color: eerieBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlackInputField(
                    controller: _notes,
                    focusNode: notesNode,
                    enabled: true,
                    maxLines: 4,
                    obsecureText: false,
                    hintText: 'Notes here ...',
                    onSaved: (newValue) {
                      notes = newValue.toString();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: 'Cancel',
                        disabled: false,
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        padding: ButtonSize().smallSize(),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: eerieBlack,
                            )
                          : RegularButton(
                              text: 'Confirm',
                              disabled: false,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  await widget.onConfirm!(notes);
                                  Navigator.of(context).pop(true);
                                }
                              },
                              padding: ButtonSize().smallSize(),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
