import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/area_menu_page.dart/area_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/capacity_menu_page/capacity_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/event_menu_page.dart/event_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/floor_menu_page/floor_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/setting_page_menu.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'dart:html' as html;

class AdminSettingPage extends StatefulWidget {
  AdminSettingPage({super.key, this.isAdmin = "false"});

  String? isAdmin;
  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  ScrollController scrollController = ScrollController();
  String menu = "Profile";
  int index = 0;
  bool isAdmin = false;

  onChangedMenu(String value) {
    setState(() {
      menu = value;
    });
  }

  @override
  void initState() {
    super.initState();
    print("isAdmin-->>  ${widget.isAdmin}");
    if (widget.isAdmin == "true") {
      isAdmin = true;
    }
  }

  resetState() {
    setState(() {});
  }

  resetAllStatus(bool value) {}

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 0,
      scrollController: scrollController,
      resetState: resetState,
      setDatePickerStatus: resetAllStatus,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Settings',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingPageMenu(
                    index: index,
                    menu: menu,
                    onChagedMenu: onChangedMenu,
                    isAdmin: isAdmin,
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Builder(builder: (context) {
                      switch (menu) {
                        case "Profile":
                          return ProfileMenuSetting();
                        case "Floor":
                          return FloorMenuSettingPage();
                        case "Area":
                          return AreaMenuPage();
                        case "Capacity":
                          return CapacityMenuPage();
                        case "Event":
                          return EventMenuPage();
                        default:
                          return Container(
                            color: greenAcent,
                            height: 200,
                          );
                      }
                    }),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget profileMenu() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Personal Data',
  //         style: helveticaText.copyWith(
  //           fontSize: 24,
  //           fontWeight: FontWeight.w700,
  //           color: davysGray,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class ProfileMenuSetting extends StatefulWidget {
  const ProfileMenuSetting({super.key});

  @override
  State<ProfileMenuSetting> createState() => _ProfileMenuSettingState();
}

class _ProfileMenuSettingState extends State<ProfileMenuSetting> {
  TextEditingController _name = TextEditingController();
  TextEditingController _nip = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _avaya = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _phoneCode = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode nipNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode avayaNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode phoneCodeNode = FocusNode();

  String name = "";
  String nip = "";
  String email = "";
  String avaya = "";
  String phone = "";
  String phoneCode = "";

  bool isConnectedToGoogle = false;

  bool isLoadingSync = false;

  @override
  void initState() {
    super.initState();

    getUserProfile().then((value) {
      print("User Profile -> $value");
      setState(() {
        name = value['Data']['EmpName'];
        nip = value['Data']['EmpNIP'];
        email = value['Data']['Email'];
        avaya = value['AvayaNumber'] ?? "-";
        phoneCode = value['Data']['CountryCode'];
        phone = value['Data']['PhoneNumber'];
        int gooleSync = value['Data']['GoogleAccountSync'];
        if (gooleSync == 1) {
          isConnectedToGoogle = true;
        } else {
          isConnectedToGoogle = false;
        }

        _name.text = name;
        _nip.text = nip;
        _avaya.text = avaya;
        _email.text = email;
        _phoneCode.text = phoneCode;
        _phone.text = phone;
      });
    });

    nameNode.addListener(() {
      setState(() {});
    });
    nipNode.addListener(() {
      setState(() {});
    });
    emailNode.addListener(() {
      setState(() {});
    });
    avayaNode.addListener(() {
      setState(() {});
    });
    phoneNode.addListener(() {
      setState(() {});
    });
    phoneCodeNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _name.dispose();
    _nip.dispose();
    _email.dispose();
    _avaya.dispose();
    _phone.dispose();
    _phoneCode.dispose();
    nameNode.removeListener(() {});
    nipNode.removeListener(() {});
    emailNode.removeListener(() {});
    avayaNode.removeListener(() {});
    phoneNode.removeListener(() {});
    phoneCodeNode.removeListener(() {});
    nameNode.dispose();
    nipNode.dispose();
    emailNode.dispose();
    avayaNode.dispose();
    phoneNode.dispose();
    phoneCodeNode.dispose();
  }

  googleLink() {
    getLinkGoogleAuth().then((value) async {
      html.WindowBase popUpWindow;

      popUpWindow = html.window.open(
        value['Data']['Link'],
        'GWS',
        'width=400, height=500, scrollbars=yes',
      );

      String code = "";
      html.window.onMessage.listen((event) async {
        if (event.data.toString().contains('token=')) {
          code = event.data.toString().split('token=')[1];
          setState(() {
            isLoadingSync = true;
          });
          await Future.delayed(const Duration(seconds: 2), () async {
            popUpWindow.close();
            setState(() {
              isLoadingSync = false;
            });
            saveTokenGoogle(code).then((value) {
              print(value);

              if (value['Status'] == "200") {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialogBlack(
                    title: value['Title'],
                    contentText: value['Message'],
                    isSuccess: true,
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
                  title: 'Failed',
                  contentText: error.toString(),
                  isSuccess: false,
                ),
              );
            });
          });
        }
      });
      if (code != "") {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Data',
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          'Full Name',
          SizedBox(
            width: 400,
            child: BlackInputField(
              controller: _name,
              enabled: true,
              focusNode: nameNode,
              obsecureText: false,
              hintText: 'Your name here ...',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          'Employee Number',
          SizedBox(
            width: 150,
            child: BlackInputField(
              controller: _nip,
              enabled: true,
              focusNode: nipNode,
              obsecureText: false,
              hintText: 'NIP here ...',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          'Email',
          SizedBox(
            width: 400,
            child: BlackInputField(
              controller: _email,
              enabled: true,
              focusNode: emailNode,
              obsecureText: false,
              hintText: 'Email here ...',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          'Avaya',
          SizedBox(
            width: 150,
            child: BlackInputField(
              controller: _avaya,
              enabled: true,
              focusNode: avayaNode,
              obsecureText: false,
              hintText: 'Avaya here ...',
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          'Phone',
          Row(
            children: [
              SizedBox(
                width: 93,
                child: BlackInputField(
                  controller: _phoneCode,
                  enabled: true,
                  focusNode: phoneCodeNode,
                  obsecureText: false,
                  prefixIcon: const Icon(
                    Icons.add,
                    size: 16,
                  ),
                  maxLines: 1,
                  // hintText: 'Email here ...',
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 225,
                child: BlackInputField(
                  controller: _phone,
                  enabled: true,
                  focusNode: phoneNode,
                  obsecureText: false,
                  hintText: 'Phone Number here ...',
                ),
              ),
            ],
          ),
        ),
        divider(),
        Text(
          'Link to Google',
          style: helveticaText.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: davysGray,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          'Account Status',
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                isConnectedToGoogle
                    ? Icons.check_circle_sharp
                    : Icons.remove_circle_sharp,
                color: isConnectedToGoogle ? greenAcent : orangeAccent,
                size: 16,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                isConnectedToGoogle
                    ? 'You are linked to Google Workspace account'
                    : 'You are not linked to Google Workspace account',
                style: helveticaText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  // height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        inputRow(
          '',
          isLoadingSync
              ? const CircularProgressIndicator(
                  color: eerieBlack,
                )
              : TransparentBorderedBlackButton(
                  text: isConnectedToGoogle
                      ? 'Unlink My Account'
                      : 'Link My Account',
                  disabled: false,
                  onTap: () {
                    if (!isConnectedToGoogle) {
                      googleLink();
                    } else {}
                  },
                  padding: ButtonSize().mediumSize(),
                ),
        ),
        divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TransparentButtonBlack(
              text: 'Cancel',
              disabled: false,
              onTap: () {},
              padding: ButtonSize().mediumSize(),
            ),
            const SizedBox(
              width: 20,
            ),
            RegularButton(
              text: 'Save',
              disabled: false,
              onTap: () {},
              padding: ButtonSize().mediumSize(),
            )
          ],
        ),
      ],
    );
  }

  inputRow(String label, Widget field) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 175,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        field,
      ],
    );
  }

  divider() {
    return Column(
      children: const [
        SizedBox(
          height: 25,
        ),
        Divider(
          thickness: 0.5,
          color: grayx11,
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
