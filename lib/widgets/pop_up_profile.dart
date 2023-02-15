import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/bug_report_dialog.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/feedback_dialog.dart';
import 'package:meeting_room_booking_system/widgets/login_pop_up.dart';

class PopUpProfile extends StatelessWidget {
  PopUpProfile({
    this.name,
    this.email,
    this.popUpProfile,
    this.resetState,
    this.isAdmin = false,
    this.updateLogin,
    this.photo,
  });

  ReqAPI apiReq = ReqAPI();
  String? name;
  String? email;
  String? photo;
  Function? popUpProfile;
  Function? resetState;
  Function? updateLogin;
  bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        popUpProfile!(true);
      },
      onExit: (event) {
        popUpProfile!(false);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 25,
          ),
          width: 350,
          decoration: BoxDecoration(
            // color: culturedWhite,
            color: white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                blurRadius: 40,
                color: Color.fromRGBO(29, 29, 29, 0.1),
                offset: Offset(0, 0),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  photo == ""
                      ? Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: sonicSilver,
                          ),
                          child: Center(
                            child: Text(
                              name!.characters.first,
                              style: helveticaText.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: white,
                                height: 1.15,
                              ),
                            ),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: photo!,
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: 30,
                            );
                          },
                        ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name!,
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: davysGray,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Text(
                          email!,
                          style: helveticaText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: sonicSilver,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 13,
              ),
              const Divider(
                color: spanishGray,
                thickness: 0.5,
              ),
              const SizedBox(
                height: 13,
              ),
              TextButton(
                onPressed: () {
                  context.goNamed('setting', params: {
                    'isAdmin': isAdmin.toString(),
                    'menu': 'Profile'
                  });
                },
                child: Text(
                  'My Profile',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              !isAdmin
                  ? const SizedBox()
                  : Column(
                      children: [],
                    ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => FeedbackDialog(),
                  );
                },
                child: Text(
                  'Give Us Feedback',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => BugReportDialog(),
                  );
                },
                child: Text(
                  'Report Error',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () async {
                  popUpProfile!(false);
                  var box = await Hive.openBox('userLogin');
                  var jwt =
                      box.get('jwTtoken') != "" ? box.get('jwtToken') : "";
                  jwtToken = "";
                  isTokenValid = false;
                  box.put('jwtToken', "");
                  box.delete('jwtToken');
                  box.delete('firstLogin');
                  box.delete('feedback');
                  box.delete('feedbackBanner');
                  resetState!;
                  context.go('/login');
                  // showDialog(
                  //   barrierDismissible: false,
                  //   context: context,
                  //   builder: (context) => LoginPopUp(
                  //     resetState: resetState,
                  //     updateLogin: updateLogin,
                  //   ),
                  // );

                  // apiReq.logout().then((value) {
                  //   print(value);
                  //   if (value['Status'] == "200") {
                  //     // context.goNamed('home');
                  //     scaffoldKey!.currentContext!.go('/home');
                  //     resetState!();
                  //   }
                  // });
                },
                child: Text(
                  'Logout',
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              !isAdmin
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 13,
                        ),
                        const Divider(
                          color: spanishGray,
                          thickness: 0.5,
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        TextButton(
                          onPressed: () {
                            context.goNamed('admin_list');
                          },
                          child: Text(
                            'Approval List',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            context.goNamed('setting', params: {
                              'isAdmin': isAdmin.toString(),
                              'menu': 'admin_setting'
                            });
                          },
                          child: Text(
                            'Settings',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Bug List',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            context.goNamed('feedback_list');
                          },
                          child: Text(
                            'Rating Result',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
