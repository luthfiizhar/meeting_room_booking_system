import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';

class PopUpProfile extends StatelessWidget {
  PopUpProfile({
    this.name,
    this.email,
    this.popUpProfile,
    this.resetState,
    this.isAdmin = false,
    this.scaffoldKey,
  });

  String? name;
  String? email;
  Function? popUpProfile;
  Function? resetState;
  bool isAdmin;
  GlobalKey<ScaffoldState>? scaffoldKey;

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
              Column(
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
              !isAdmin
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.goNamed('admin_list');
                          },
                          child: Text(
                            'Approval',
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
                      ],
                    ),
              TextButton(
                onPressed: () {
                  context.goNamed('setting',
                      params: {'isAdmin': isAdmin.toString()});
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
                  box.put('jwtToken', "");
                  resetState!;
                  context.go('/home');
                  // logout().then((value) {
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
            ],
          ),
        ),
      ),
    );
  }
}
