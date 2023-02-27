import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/model/booking_class.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/food_item.dart';
import 'package:meeting_room_booking_system/widgets/booking_page/room_facility_item.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_white.dart';
import 'package:meeting_room_booking_system/widgets/detail_page/facility_item_detail.dart';
import 'package:meeting_room_booking_system/widgets/detail_page/food_item_detail.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/booking_page_dialog.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/room_booking_dialog.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'dart:html' as html;

class ConfirmEventPage extends StatefulWidget {
  ConfirmEventPage({
    super.key,
    // this.booking,
    this.bookingId,
  });

  Booking? booking;

  String? bookingId;

  @override
  State<ConfirmEventPage> createState() => _ConfirmEventPageState();
}

class _ConfirmEventPageState extends State<ConfirmEventPage>
    with TickerProviderStateMixin {
  ReqAPI apiReq = ReqAPI();

  OverlayEntry? confirmOverlayEntry;

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
  String layoutId = "";
  String approvalComment = "";
  dynamic days;
  DateTime repeatEndDate = DateTime.now();
  String meetUrl = "";
  String bookingStatus = "";

  String selectedDate = "";

  DateTime? bookingDate;

  String host = "";
  String hostEmail = "";
  String avaya = "";
  String phoneNumber = "";

  List guestInvited = [];
  List amenities = [];
  List foodAmenities = [];
  List bookingHistory = [];

  String additionalNotes = "";

  String imageLayout = "";

  bool isInitLoading = true;
  bool isCancelLoading = false;
  bool isAdmin = false;
  bool isPic = false;
  bool isPhoneShowed = false;
  bool isOwner = false;
  bool isButtonShowed = true;
  bool isGoogleMeetShowed = false;

  int bookingStep = 0;
  resetStatus(bool value) {}

  OverlayEntry confirmOverlay() {
    return OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        // bottom: 0,
        child: Material(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            // height: ,
            decoration: const BoxDecoration(
              color: eerieBlack,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Is this event still going on?',
                  style: helveticaText.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: white,
                  ),
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    TransparentButtonWhite(
                      text: 'Cancel Event',
                      disabled: false,
                      onTap: () {},
                      padding: ButtonSize().smallSize(),
                    ),
                    WhiteRegularButton(
                      text: 'Confirm Event',
                      disabled: false,
                      onTap: () {},
                      padding: ButtonSize().smallSize(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    end: Offset.zero,
    begin: const Offset(0, 2.0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    // confirmOverlayEntry = confirmOverlay();
    // Overlay.of(context)!.insert(confirmOverlayEntry!);
    _controller.forward(from: 0);
    apiReq.getBookingDetail(widget.bookingId!).then((value) {
      print(value);
      if (value['Status'].toString() == "200") {
        isInitLoading = false;
        roomId = value['Data']['RoomID'];
        bookingNip = value['Data']['EmpNIP'];
        coverURL = value['Data']['RoomPhotos'];
        summary = value['Data']['Summary'];
        description = value['Data']['Description'] ?? "";
        roomType = value['Data']['RoomType'];

        bookingType = value['Data']['BookingType'];

        bookingStep = value['Data']['BookingStep'];
        bookingStatus = value['Data']['Status'];

        startTime = value['Data']['BookingStartTime'];
        endTime = value['Data']['BookingEndTime'];
        location = value['Data']['RoomName'];
        floor = value['Data']['AreaName'];
        eventDate = value['Data']['BookingDate'];

        eventTime =
            "${value['Data']['BookingStartTime']} - ${value['Data']['BookingEndTime']} WIB";
        duration = value['Data']['Duration'];
        participantTotal = value['Data']['AttendantsNumber'].toString();
        eventType = value['Data']['MeetingType'];
        repeat = value['Data']['Repeat'] ?? "";

        host = value['Data']['EmpName'];
        meetUrl = value['Data']['GoogleMeetLink'] ?? "";
        avaya = value['Data']['AvayaNumber'] ?? "";
        phoneNumber = value['Data']['PhoneNumber'] ?? "";
        hostEmail = value['Data']['Email'];
        layoutName = value['Data']['LayoutName'] ?? "";
        layoutImage = value['Data']['LayoutImg'] ?? "";
        layoutId = value['Data']['LayoutID'] ?? "";
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
        DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
        bookingDate = format.parse(
            "${value['Data']['BookingDateOriginal']} ${value['Data']['BookingStartTime']}:00");

        selectedDate = value['Data']['BookingDateOriginal'];
        setState(() {});
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
        setState(() {
          isInitLoading = false;
        });
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
        print(value);
        if (value["Status"].toString() == "200") {
          if (bookingDate!.isBefore(DateTime.now())) {
            setState(() {
              print('sudah lewat event nya');
              isButtonShowed = false;
              if (value["Data"]["Admin"].toString() == "1") {
                isAdmin = true;
                isPhoneShowed = true;
                isGoogleMeetShowed = true;
              } else {
                if (bookingNip == value["Data"]["EmpNIP"]) {
                  setState(() {
                    isOwner = true;
                    isGoogleMeetShowed = true;
                    isPhoneShowed = true;
                  });
                }
              }
            });
          } else {
            setState(() {
              isButtonShowed = true;
              if (value["Data"]["Admin"].toString() == "1") {
                setState(() {
                  isAdmin = true;
                  isPhoneShowed = true;
                  // isOwner = false;
                  isGoogleMeetShowed = true;
                  isButtonShowed = true;
                  if (bookingStatus != "WAITING APPROVAL" ||
                      bookingStatus != "CREATED") {
                    print('if declined');
                    isButtonShowed = true;
                  }
                });
              } else if (value["Data"]["Pic"].toString() == "1") {
                setState(() {
                  isPic = true;
                  isPhoneShowed = true;
                });
              }
              if (bookingNip == value["Data"]["EmpNIP"]) {
                setState(() {
                  isPhoneShowed = true;
                  isOwner = true;
                  isButtonShowed = true;
                  isGoogleMeetShowed = true;
                  if (bookingStatus != "WAITING APPROVAL" ||
                      bookingStatus != "CREATED") {
                    print('if declined');
                    isButtonShowed = true;
                  }
                });
              } else {
                print('else nip tidak cocok');
                setState(() {
                  if (value["Data"]["Admin"].toString() == "1") {
                    isButtonShowed = true;
                  } else {
                    isButtonShowed = false;
                  }
                });
              }
            });
          }
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
      // print(error);
      // print(stackTrace);
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed getDetail',
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
    // confirmOverlayEntry!.remove();
    scrollController.removeListener(() {});
    scrollController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 1100 ? mobile() : desktop();
  }

  Widget desktop() {
    return Stack(
      children: [
        LayoutPageWeb(
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
                    // mainAxisSize: MainAxisSize.max,
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
                                      style: helveticaText.copyWith(
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
                                      style: helveticaText.copyWith(
                                        fontFamily: 'Helvetica',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      height: 40,
                                    ),
                                    // bookingStep > 0
                                    //     ? const SizedBox()
                                    //     :
                                    // Visibility(
                                    //   visible: isButtonShowed,
                                    //   child: ConstrainedBox(
                                    //     constraints: const BoxConstraints(
                                    //       minHeight: 65,
                                    //       maxHeight: 65,
                                    //       minWidth: 400,
                                    //       maxWidth: 850,
                                    //     ),
                                    //     child: Container(
                                    //       padding: const EdgeInsets.symmetric(
                                    //         horizontal: 5,
                                    //         vertical: 10,
                                    //       ),
                                    //       // width: 800,
                                    //       height: 65,
                                    //       decoration: BoxDecoration(
                                    //         color: platinum,
                                    //         borderRadius: BorderRadius.circular(10),
                                    //       ),
                                    //       child: Row(
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.center,
                                    //         mainAxisSize: MainAxisSize.min,
                                    //         children: [
                                    //           // TransparentButtonBlack(
                                    //           //   text: 'Email to User',
                                    //           //   disabled: false,
                                    //           //   onTap: () {},
                                    //           //   padding: ButtonSize().mediumSize(),
                                    //           // ),
                                    //           // verticalDivider(),
                                    //           // TransparentButtonBlack(
                                    //           //   text: 'Trade',
                                    //           //   disabled: false,
                                    //           //   onTap: () {},
                                    //           //   padding: ButtonSize().mediumSize(),
                                    //           // ),
                                    //           // verticalDivider(),
                                    //           TransparentButtonBlack(
                                    //             text: 'Edit Event',
                                    //             disabled: false,
                                    //             onTap: () {
                                    //               // print(roomId);
                                    //               List guestInvited2 = [];
                                    //               for (var element
                                    //                   in guestInvited) {
                                    //                 guestInvited2.add(
                                    //                     "\"${element['AttendantsEmail']}\"");
                                    //               }
                                    //               List<Amenities> tempAmenities =
                                    //                   [];
                                    //               List<FoodAmenities>
                                    //                   tempFoodAmenities = [];
                                    //               for (var element in amenities) {
                                    //                 tempAmenities.add(
                                    //                   Amenities(
                                    //                     amenitiesId:
                                    //                         element['AmenitiesID'],
                                    //                     amenitiesName: element[
                                    //                         'AmenitiesName'],
                                    //                     qty: element['Amount'],
                                    //                     defaultAmount: element[
                                    //                         'DefaultAmount'],
                                    //                     photo: element['ImageURL'],
                                    //                   ),
                                    //                 );
                                    //               }

                                    //               for (var element
                                    //                   in foodAmenities) {
                                    //                 tempFoodAmenities.add(
                                    //                   FoodAmenities(
                                    //                     amenitiesId:
                                    //                         element['AmenitiesID'],
                                    //                     amenitiesName: element[
                                    //                         'AmenitiesName'],
                                    //                     qty: element['Amount'],
                                    //                     photo: element['ImageURL'],
                                    //                   ),
                                    //                 );
                                    //               }
                                    //               // print(
                                    //               //     "tempAmen ${tempAmenities.toString()}");
                                    //               context.goNamed(
                                    //                 'booking',
                                    //                 params: {
                                    //                   "roomId": roomId,
                                    //                   'date':
                                    //                       selectedDate.toString(),
                                    //                   'startTime': startTime,
                                    //                   'endTime': endTime,
                                    //                   'participant':
                                    //                       participantTotal,
                                    //                   //tempAmenities.toString(),
                                    //                   'roomType': roomType,
                                    //                   'isEdit': 'true'
                                    //                 },
                                    //                 queryParams: {
                                    //                   'date':
                                    //                       selectedDate.toString(),
                                    //                   'startTime': startTime,
                                    //                   'endTime': endTime,
                                    //                   'summary': summary,
                                    //                   'description': description,
                                    //                   'additionalNote':
                                    //                       additionalNotes,
                                    //                   'participant':
                                    //                       participantTotal,
                                    //                   'facilities':
                                    //                       tempAmenities.toString(),
                                    //                   'food': tempFoodAmenities
                                    //                       .toString(),
                                    //                   'bookingType': bookingType,
                                    //                   'guestInvited':
                                    //                       guestInvited2.toString(),
                                    //                   'repeatEndDate':
                                    //                       repeatEndDate.toString(),
                                    //                   'days': days,
                                    //                   'montAbs': monthAbs,
                                    //                   'repeatType': repeatType,
                                    //                   'interval': interval,
                                    //                   'meetingType': eventType,
                                    //                   'roomType': roomType,
                                    //                   'layoutName': layoutName,
                                    //                   'layoutImage': layoutImage,
                                    //                   'layoutId': layoutId,
                                    //                   'bookingId': widget.bookingId,
                                    //                 },
                                    //               );
                                    //               // showDialog(
                                    //               //   context: context,
                                    //               //   builder: (context) =>
                                    //               //       BookingRoomPageDialog(
                                    //               //     summary: summary,
                                    //               //     description: description,
                                    //               //     additionalNote: additionalNotes,
                                    //               //     invitedGuest: guestInvited,
                                    //               //     totalParticipant: participantTotal,
                                    //               //     roomId: roomId,
                                    //               //     date: formattedDate,
                                    //               //     startTime: startTime,
                                    //               //     endTime: endTime,
                                    //               //     facilities: amenities,
                                    //               //     foodAmenities: foodAmenities,
                                    //               //     participant: participantTotal,
                                    //               //     roomType: roomType,
                                    //               //     recurrent: [
                                    //               //       {
                                    //               //         'repeatEndDate': repeatEndDate,
                                    //               //         'days': days,
                                    //               //         'montAbs': monthAbs,
                                    //               //         'repeatType': repeatType,
                                    //               //         'interval': interval
                                    //               //       }
                                    //               //     ],
                                    //               //   ),
                                    //               // );
                                    //             },
                                    //             padding: ButtonSize().mediumSize(),
                                    //           ),
                                    //           verticalDivider(),
                                    //           TransparentButtonBlack(
                                    //             text: 'Cancel Event',
                                    //             disabled: false,
                                    //             onTap: () {
                                    //               showDialog(
                                    //                 context: context,
                                    //                 builder: (context) =>
                                    //                     const ConfirmDialogBlack(
                                    //                   title: 'Cancel Booking',
                                    //                   contentText:
                                    //                       'Are you sure want cancel this booking?',
                                    //                 ),
                                    //               ).then((value) {
                                    //                 if (value) {
                                    //                   setState(() {
                                    //                     isCancelLoading = true;
                                    //                   });
                                    //                   if (bookingType == "SINGLE") {
                                    //                     apiReq
                                    //                         .deleteBooking(
                                    //                             widget.bookingId!)
                                    //                         .then((value) {
                                    //                       // print(value);
                                    //                       setState(() {
                                    //                         isCancelLoading = false;
                                    //                       });
                                    //                       if (value['Status']
                                    //                               .toString() ==
                                    //                           "200") {
                                    //                         showDialog(
                                    //                           context: context,
                                    //                           builder: (context) =>
                                    //                               AlertDialogBlack(
                                    //                             title:
                                    //                                 value['Title'],
                                    //                             contentText: value[
                                    //                                 'Message'],
                                    //                           ),
                                    //                         ).then((value) {
                                    //                           context.go('/rooms');
                                    //                         });
                                    //                       } else {
                                    //                         showDialog(
                                    //                           context: context,
                                    //                           builder: (context) =>
                                    //                               AlertDialogBlack(
                                    //                             title:
                                    //                                 value['Title'],
                                    //                             contentText: value[
                                    //                                 'Message'],
                                    //                             isSuccess: false,
                                    //                           ),
                                    //                         );
                                    //                       }
                                    //                     }).onError((error,
                                    //                             stackTrace) {
                                    //                       showDialog(
                                    //                         context: context,
                                    //                         builder: (context) =>
                                    //                             AlertDialogBlack(
                                    //                           title:
                                    //                               'Failed connect to API',
                                    //                           contentText:
                                    //                               error.toString(),
                                    //                           isSuccess: false,
                                    //                         ),
                                    //                       );
                                    //                     });
                                    //                   }
                                    //                   if (bookingType ==
                                    //                       "RECURRENT") {
                                    //                     apiReq
                                    //                         .deleteBookingRecurrent(
                                    //                             widget.bookingId!)
                                    //                         .then((value) {
                                    //                       // print(value);
                                    //                       if (value['Status']
                                    //                               .toString() ==
                                    //                           "200") {
                                    //                         showDialog(
                                    //                           context: context,
                                    //                           builder: (context) =>
                                    //                               AlertDialogBlack(
                                    //                             title:
                                    //                                 value['Title'],
                                    //                             contentText: value[
                                    //                                 'Message'],
                                    //                           ),
                                    //                         ).then((value) {
                                    //                           context.go('/rooms');
                                    //                         });
                                    //                       } else {
                                    //                         showDialog(
                                    //                           context: context,
                                    //                           builder: (context) =>
                                    //                               AlertDialogBlack(
                                    //                             title:
                                    //                                 value['Title'],
                                    //                             contentText: value[
                                    //                                 'Message'],
                                    //                             isSuccess: false,
                                    //                           ),
                                    //                         );
                                    //                       }
                                    //                     }).onError((error,
                                    //                             stackTrace) {
                                    //                       showDialog(
                                    //                         context: context,
                                    //                         builder: (context) =>
                                    //                             AlertDialogBlack(
                                    //                           title:
                                    //                               'Failed connect to API',
                                    //                           contentText:
                                    //                               error.toString(),
                                    //                           isSuccess: false,
                                    //                         ),
                                    //                       );
                                    //                     });
                                    //                   }
                                    //                 } else {
                                    //                   setState(() {
                                    //                     isCancelLoading = false;
                                    //                   });
                                    //                 }
                                    //               });
                                    //             },
                                    //             padding: ButtonSize().mediumSize(),
                                    //           ),
                                    //         ],
                                    //       ),
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
          // ConstrainedBox(
          //     constraints: pageConstraints.copyWith(
          //       maxHeight: roomType == "MeetingRoom" ? 1700 : 2500,
          //       minHeight: 1500,
          //     ),
          //     child: Stack(
          //       children: [
          //         Align(
          //           alignment: Alignment.topCenter,
          //           child: Container(
          //             width: 1100,
          //             height: 400,
          //             decoration: BoxDecoration(
          //               color: graySand,
          //               borderRadius: BorderRadius.circular(10),
          //               image: DecorationImage(
          //                 image: NetworkImage(coverURL),
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Positioned(
          //           top: 300,
          //           right: 183,
          //           // alignment: Alignment.bottomCenter,
          //           child: Container(
          //             // color: Colors.blue,
          //             decoration: BoxDecoration(
          //               color: white,
          //               borderRadius: BorderRadius.circular(10),
          //               boxShadow: [
          //                 BoxShadow(
          //                   offset: const Offset(0, 0),
          //                   blurRadius: 40,
          //                   spreadRadius: 0,
          //                   color: eerieBlack.withOpacity(0.1),
          //                 ),
          //               ],
          //             ),
          //             width: 1000,
          //             // height: 1000,
          //             child: Padding(
          //               padding: const EdgeInsets.symmetric(
          //                 horizontal: 65,
          //                 vertical: 40,
          //               ),
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.min,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     summary,
          //                     style: helveticaText.copyWith(
          //                       fontFamily: 'Helvetica',
          //                       fontSize: 24,
          //                       fontWeight: FontWeight.w700,
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 10,
          //                   ),
          //                   Text(
          //                     description,
          //                     style: helveticaText.copyWith(
          //                       fontFamily: 'Helvetica',
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.w300,
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 40,
          //                   ),
          //                   Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Expanded(
          //                         child: eventDetailContainer(),
          //                       ),
          //                       const SizedBox(
          //                         width: 60,
          //                       ),
          //                       Expanded(
          //                         child: detailContainer2(),
          //                       ),
          //                     ],
          //                   ),
          //                   const SizedBox(
          //                     height: 40,
          //                   ),
          //                   // bookingStep > 0
          //                   //     ? const SizedBox()
          //                   //     :
          //                   Visibility(
          //                     visible: isButtonShowed,
          //                     child: ConstrainedBox(
          //                       constraints: const BoxConstraints(
          //                         minHeight: 65,
          //                         maxHeight: 65,
          //                         minWidth: 400,
          //                         maxWidth: 850,
          //                       ),
          //                       child: Container(
          //                         padding: const EdgeInsets.symmetric(
          //                           horizontal: 5,
          //                           vertical: 10,
          //                         ),
          //                         // width: 800,
          //                         height: 65,
          //                         decoration: BoxDecoration(
          //                           color: platinum,
          //                           borderRadius: BorderRadius.circular(10),
          //                         ),
          //                         child: Row(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           mainAxisSize: MainAxisSize.min,
          //                           children: [
          //                             // TransparentButtonBlack(
          //                             //   text: 'Email to User',
          //                             //   disabled: false,
          //                             //   onTap: () {},
          //                             //   padding: ButtonSize().mediumSize(),
          //                             // ),
          //                             // verticalDivider(),
          //                             // TransparentButtonBlack(
          //                             //   text: 'Trade',
          //                             //   disabled: false,
          //                             //   onTap: () {},
          //                             //   padding: ButtonSize().mediumSize(),
          //                             // ),
          //                             // verticalDivider(),
          //                             TransparentButtonBlack(
          //                               text: 'Edit Event',
          //                               disabled: false,
          //                               onTap: () {
          //                                 // print(roomId);
          //                                 List guestInvited2 = [];
          //                                 for (var element in guestInvited) {
          //                                   guestInvited2.add(
          //                                       "\"${element['AttendantsEmail']}\"");
          //                                 }
          //                                 List<Amenities> tempAmenities = [];
          //                                 List<FoodAmenities>
          //                                     tempFoodAmenities = [];
          //                                 for (var element in amenities) {
          //                                   tempAmenities.add(
          //                                     Amenities(
          //                                       amenitiesId:
          //                                           element['AmenitiesID'],
          //                                       amenitiesName:
          //                                           element['AmenitiesName'],
          //                                       qty: element['Amount'],
          //                                       defaultAmount:
          //                                           element['DefaultAmount'],
          //                                       photo: element['ImageURL'],
          //                                     ),
          //                                   );
          //                                 }

          //                                 for (var element in foodAmenities) {
          //                                   tempFoodAmenities.add(
          //                                     FoodAmenities(
          //                                       amenitiesId:
          //                                           element['AmenitiesID'],
          //                                       amenitiesName:
          //                                           element['AmenitiesName'],
          //                                       qty: element['Amount'],
          //                                       photo: element['ImageURL'],
          //                                     ),
          //                                   );
          //                                 }
          //                                 // print(
          //                                 //     "tempAmen ${tempAmenities.toString()}");
          //                                 context.goNamed(
          //                                   'booking',
          //                                   params: {
          //                                     "roomId": roomId,
          //                                     'date': selectedDate.toString(),
          //                                     'startTime': startTime,
          //                                     'endTime': endTime,
          //                                     'participant': participantTotal,
          //                                     'facilities': "[]",
          //                                     //tempAmenities.toString(),
          //                                     'roomType': roomType,
          //                                     'isEdit': 'true'
          //                                   },
          //                                   queryParams: {
          //                                     'date': selectedDate.toString(),
          //                                     'startTime': startTime,
          //                                     'endTime': endTime,
          //                                     'summary': summary,
          //                                     'description': description,
          //                                     'additionalNote': additionalNotes,
          //                                     'participant': participantTotal,
          //                                     'facilities':
          //                                         tempAmenities.toString(),
          //                                     'food':
          //                                         tempFoodAmenities.toString(),
          //                                     'bookingType': bookingType,
          //                                     'guestInvited':
          //                                         guestInvited2.toString(),
          //                                     'repeatEndDate':
          //                                         repeatEndDate.toString(),
          //                                     'days': days,
          //                                     'montAbs': monthAbs,
          //                                     'repeatType': repeatType,
          //                                     'interval': interval,
          //                                     'roomType': roomType,
          //                                     'layoutName': layoutName,
          //                                     'layoutImage': layoutImage,
          //                                     'layoutId': layoutId,
          //                                     'bookingId': widget.bookingId,
          //                                   },
          //                                 );
          //                                 // showDialog(
          //                                 //   context: context,
          //                                 //   builder: (context) =>
          //                                 //       BookingRoomPageDialog(
          //                                 //     summary: summary,
          //                                 //     description: description,
          //                                 //     additionalNote: additionalNotes,
          //                                 //     invitedGuest: guestInvited,
          //                                 //     totalParticipant: participantTotal,
          //                                 //     roomId: roomId,
          //                                 //     date: formattedDate,
          //                                 //     startTime: startTime,
          //                                 //     endTime: endTime,
          //                                 //     facilities: amenities,
          //                                 //     foodAmenities: foodAmenities,
          //                                 //     participant: participantTotal,
          //                                 //     roomType: roomType,
          //                                 //     recurrent: [
          //                                 //       {
          //                                 //         'repeatEndDate': repeatEndDate,
          //                                 //         'days': days,
          //                                 //         'montAbs': monthAbs,
          //                                 //         'repeatType': repeatType,
          //                                 //         'interval': interval
          //                                 //       }
          //                                 //     ],
          //                                 //   ),
          //                                 // );
          //                               },
          //                               padding: ButtonSize().mediumSize(),
          //                             ),
          //                             verticalDivider(),
          //                             TransparentButtonBlack(
          //                               text: 'Cancel Event',
          //                               disabled: false,
          //                               onTap: () {
          //                                 showDialog(
          //                                   context: context,
          //                                   builder: (context) =>
          //                                       const ConfirmDialogBlack(
          //                                     title: 'Cancel Booking',
          //                                     contentText:
          //                                         'Are you sure want cancel this booking?',
          //                                   ),
          //                                 ).then((value) {
          //                                   if (value) {
          //                                     setState(() {
          //                                       isCancelLoading = true;
          //                                     });
          //                                     if (bookingType == "SINGLE") {
          //                                       apiReq
          //                                           .deleteBooking(
          //                                               widget.bookingId!)
          //                                           .then((value) {
          //                                         // print(value);
          //                                         setState(() {
          //                                           isCancelLoading = false;
          //                                         });
          //                                         if (value['Status']
          //                                                 .toString() ==
          //                                             "200") {
          //                                           showDialog(
          //                                             context: context,
          //                                             builder: (context) =>
          //                                                 AlertDialogBlack(
          //                                               title: value['Title'],
          //                                               contentText:
          //                                                   value['Message'],
          //                                             ),
          //                                           ).then((value) {
          //                                             context.go('/rooms');
          //                                           });
          //                                         } else {
          //                                           showDialog(
          //                                             context: context,
          //                                             builder: (context) =>
          //                                                 AlertDialogBlack(
          //                                               title: value['Title'],
          //                                               contentText:
          //                                                   value['Message'],
          //                                               isSuccess: false,
          //                                             ),
          //                                           );
          //                                         }
          //                                       }).onError((error, stackTrace) {
          //                                         showDialog(
          //                                           context: context,
          //                                           builder: (context) =>
          //                                               AlertDialogBlack(
          //                                             title:
          //                                                 'Failed connect to API',
          //                                             contentText:
          //                                                 error.toString(),
          //                                             isSuccess: false,
          //                                           ),
          //                                         );
          //                                       });
          //                                     }
          //                                     if (bookingType == "RECURRENT") {
          //                                       apiReq
          //                                           .deleteBookingRecurrent(
          //                                               widget.bookingId!)
          //                                           .then((value) {
          //                                         // print(value);
          //                                         if (value['Status']
          //                                                 .toString() ==
          //                                             "200") {
          //                                           showDialog(
          //                                             context: context,
          //                                             builder: (context) =>
          //                                                 AlertDialogBlack(
          //                                               title: value['Title'],
          //                                               contentText:
          //                                                   value['Message'],
          //                                             ),
          //                                           ).then((value) {
          //                                             context.go('/rooms');
          //                                           });
          //                                         } else {
          //                                           showDialog(
          //                                             context: context,
          //                                             builder: (context) =>
          //                                                 AlertDialogBlack(
          //                                               title: value['Title'],
          //                                               contentText:
          //                                                   value['Message'],
          //                                               isSuccess: false,
          //                                             ),
          //                                           );
          //                                         }
          //                                       }).onError((error, stackTrace) {
          //                                         showDialog(
          //                                           context: context,
          //                                           builder: (context) =>
          //                                               AlertDialogBlack(
          //                                             title:
          //                                                 'Failed connect to API',
          //                                             contentText:
          //                                                 error.toString(),
          //                                             isSuccess: false,
          //                                           ),
          //                                         );
          //                                       });
          //                                     }
          //                                   } else {
          //                                     setState(() {
          //                                       isCancelLoading = false;
          //                                     });
          //                                   }
          //                                 });
          //                               },
          //                               padding: ButtonSize().mediumSize(),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          // bottom: 0,
          child: Material(
            child: SlideTransition(
              position: _offsetAnimation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                // height: ,
                decoration: const BoxDecoration(
                  color: eerieBlack,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Is this event still going on?',
                      style: helveticaText.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        TransparentButtonWhite(
                          text: 'Cancel Event',
                          disabled: false,
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ConfirmDialogBlack(
                                  title: 'Cancel Event?',
                                  contentText:
                                      "Your event will erased from the room list & marked as canceled."),
                            ).then((value) {
                              if (value) {
                                apiReq
                                    .userConfirmEventCancel(widget.bookingId!)
                                    .then((value) {
                                  if (value['Status'].toString() == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                      ),
                                    );
                                  } else if (value['Status'].toString() ==
                                      "401") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => TokenExpiredDialog(
                                        title: value['Title'],
                                        contentText: value['Message'],
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
                                      title: "Error userConfirmEvent",
                                      contentText: error.toString(),
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              }
                            });
                          },
                          padding: ButtonSize().smallSize(),
                        ),
                        WhiteRegularButton(
                          text: 'Confirm Event',
                          disabled: false,
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const ConfirmDialogBlack(
                                  title: 'Confirm Event?',
                                  contentText:
                                      "Your event will stay listed in the system."),
                            ).then((value) {
                              if (value) {
                                apiReq
                                    .userConfirmEventContinue(widget.bookingId!)
                                    .then((value) {
                                  if (value['Status'].toString() == "200") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialogBlack(
                                        title: value['Title'],
                                        contentText: value['Message'],
                                      ),
                                    );
                                  } else if (value['Status'].toString() ==
                                      "401") {
                                    showDialog(
                                      context: context,
                                      builder: (context) => TokenExpiredDialog(
                                        title: value['Title'],
                                        contentText: value['Message'],
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
                                      title: "Error userConfirmEvent",
                                      contentText: error.toString(),
                                      isSuccess: false,
                                    ),
                                  );
                                });
                              }
                            });
                          },
                          padding: ButtonSize().smallSize(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget mobile() {
    return Stack(
      children: [
        LayoutPageWebMobile(
          scrollController: scrollController,
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 20,
            ),
            child: isInitLoading
                ? const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: eerieBlack,
                    ),
                  )
                : Column(
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
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            child: SlideTransition(
              position: _offsetAnimation,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: eerieBlack,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Is this event still going on?',
                        style: helveticaText.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TransparentButtonWhite(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              text: 'Cancel Event',
                              fontWeight: FontWeight.w300,
                              disabled: false,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: WhiteRegularButton(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              text: 'Confirm Event',
                              disabled: false,
                              onTap: () {},
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
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
        // divider2(),
        // detailContent('Repeat', repeat),
        Visibility(
          visible: isGoogleMeetShowed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              divider2(),
              detailContentMeetUrl('Meet Url', meetUrl),
            ],
          ),
        ),
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
              : isPic
                  ? true
                  : isOwner
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
                        Builder(builder: (context) {
                          switch (guestInvited[index]['ResponseStatus']) {
                            case 'needsAction':
                              return const ImageIcon(
                                AssetImage(
                                  'assets/icons/question_mark_icon.png',
                                ),
                              );
                            case 'accepted':
                              return const ImageIcon(
                                AssetImage(
                                  'assets/icons/check_icon.png',
                                ),
                                color: greenAcent,
                              );
                            case 'declined':
                              return const ImageIcon(
                                AssetImage(
                                  'assets/icons/cancel_icon.png',
                                ),
                                color: orangeAccent,
                              );
                            default:
                              return const ImageIcon(
                                AssetImage(
                                  'assets/icons/question_mark_icon.png',
                                ),
                              );
                          }
                        })
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
                height: 125,
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
                          comments: bookingHistory[index]['Description'] ?? "-",
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
        // Visibility(
        //   visible: roomType == "MeetingRoom" ? false : true,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       detailTitle('Comments'),
        //       divider(),
        //       detailContent('Comments', approvalComment),
        //       const SizedBox(
        //         height: 30,
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  detailContent(String label, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            textAlign: TextAlign.right,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: davysGray,
            ),
          ),
        ),
      ],
    );
  }

  detailContentMeetUrl(String label, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: sonicSilver,
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              html.window.open(content, '');
            },
            child: Text(
              content,
              textAlign: TextAlign.right,
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: davysGray,
              ),
            ),
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

  Widget bookingDetail(String name, String status, String logDate,
      {String comments = "-"}) {
    return Container(
      child: Row(
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
          const SizedBox(
            width: 20,
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
                  comments,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
