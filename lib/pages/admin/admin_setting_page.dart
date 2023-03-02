import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/pages/user/profile_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/area_menu_page/area_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/capacity_menu_page/capacity_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/event_menu_page/event_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/facilities_menu_page/facilities_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/floor_menu_page/floor_menu_page.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/setting_page_menu.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/user_admin_page/user_admin_page.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
// import 'dart:html' as html;

class AdminSettingPage extends StatefulWidget {
  AdminSettingPage({
    super.key,
    this.isAdmin = "false",
    this.firstMenu = "Profile",
  });

  String? isAdmin;
  String? firstMenu;
  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  ReqAPI apiReq = ReqAPI();
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
    // print("isAdmin-->>  ${widget.isAdmin}");
    if (widget.isAdmin == "true") {
      isAdmin = true;
    }
    if (widget.firstMenu == "admin_setting") {
      setState(() {
        // menu = "Floor";
        onChangedMenu("Floor");
        index = 1;
      });
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
                          return ProfileMenuSetting(
                            scrollController: scrollController,
                          );
                        case "Floor":
                          return const FloorMenuSettingPage();
                        case "Area":
                          return AreaMenuPage();
                        case "Capacity":
                          return const CapacityMenuPage();
                        case "Event":
                          return const EventMenuPage();
                        case "Facility":
                          return const FacilitiesMenuPage();
                        case "Admin":
                          return const AdminUserPage();
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
                height: 100,
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
