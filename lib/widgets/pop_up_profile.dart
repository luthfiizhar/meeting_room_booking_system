import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/main.dart';

class PopUpProfile extends StatelessWidget {
  PopUpProfile({
    this.name,
    this.email,
    this.popUpProfile,
    this.resetState,
  });

  String? name;
  String? email;
  Function? popUpProfile;
  Function? resetState;

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
            horizontal: 25,
          ),
          width: 350,
          decoration: BoxDecoration(
            color: culturedWhite,
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
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/avatar_profile.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // child: Icon(Icons.person),
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
                          style: const TextStyle(
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
                          style: const TextStyle(
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
                onPressed: () {},
                child: const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  popUpProfile!(false);
                  jwtToken = "";
                  resetState;
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: davysGray,
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
