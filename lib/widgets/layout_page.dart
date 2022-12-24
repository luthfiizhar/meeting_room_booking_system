import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/widgets/button/go_to_top_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:meeting_room_booking_system/widgets/pop_up_profile.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:provider/provider.dart';
import 'dart:html';

class LayoutPageWeb extends StatefulWidget {
  LayoutPageWeb({
    required this.child,
    this.index,
    this.setDatePickerStatus,
    required this.scrollController,
    this.resetState,
    this.model,
  });

  Widget? child;
  int? index;
  Function? setDatePickerStatus;
  final ScrollController? scrollController;
  Function? resetState;
  MainModel? model;
  // bool isAdmin;

  @override
  State<LayoutPageWeb> createState() => _LayoutPageWebState();
}

class _LayoutPageWebState extends State<LayoutPageWeb> {
  ScrollController? _scrollController;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final info = NetworkInfo();
  MainModel mainModel = MainModel();
  bool profileVisible = false;
  bool opacityOn = false;
  // bool upBottonVisible = false;
  String employeeName = "";
  String employeeEmail = "";

  bool isAdmin = false;

  popUpProfile(bool value) {
    if (profileVisible) {
      profileVisible = value;
      opacityOn = value;
    } else {
      opacityOn = value;
      profileVisible = value;
    }
    widget.setDatePickerStatus!(false);
    setState(() {});
  }

  _scrollListener(ScrollController scrollInfo, MainModel model) {
    if (mounted) {
      if (scrollInfo.offset == 0) {
        // Provider.of<MainModel>(context, listen: false)
        //     .setShadowActive(false);
        // Provider.of<MainModel>(context, listen: false).setUpBotton(false);
        mainModel.setShadowActive(false);
        mainModel.setUpBotton(false);
        mainModel.setIsScrolling(false);
        mainModel.setScrollPosition(scrollInfo.offset);
        mainModel.setIsScrollAtEdge(false);
      } else {
        // Provider.of<MainModel>(context, listen: false)
        //     .setShadowActive(true);
        // Provider.of<MainModel>(context, listen: false).setUpBotton(true);
        mainModel.setShadowActive(true);
        mainModel.setUpBotton(true);
        mainModel.setIsScrolling(true);
        mainModel.setScrollPosition(scrollInfo.offset);
        mainModel.setIsScrollAtEdge(false);
        if (scrollInfo.offset == scrollInfo.position.maxScrollExtent) {
          mainModel.setIsScrollAtEdge(true);
        }
      }
    }

    // widget.setDatePickerStatus!(false);
  }

  Future checkDeviceInfo() async {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    final Connectivity _connectivity = Connectivity();
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      print(connectivityResult);
      _connectivity.checkConnectivity().then((value) {
        print(value);
      });
    }
    // final add =  await NetworkInterface().addresses;
    // var info = NetworkInfo();
    // var wifiIP = await info.getWifiIP();
    // print('Ip address -> $wifiIP');
    // print(info);
    print('Running on -> ${webBrowserInfo.userAgent}');
  }

  Future autoScroll() async {
    _scrollController?.animateTo(
      20,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  scrollToTop() {
    _scrollController?.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = widget.scrollController;
    if (widget.model != null) {
      mainModel = widget.model!;
    }
    getUserProfile().then((value) {
      if (value['Status'] == "200") {
        setState(() {
          employeeName = value['Data']['EmpName'];
          employeeEmail = value['Data']['Email'];
          if (value['Data']['Admin'] == 1) {
            isAdmin = true;
          }
        });
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
          title: 'Can\'t connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
    // checkDeviceInfo();
    // if (mounted) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Provider.of<MainModel>(context, listen: false)
      //     .setShadowActive(false);
      mainModel.setShadowActive(false);
      // Provider.of<MainModel>(context, listen: false)
      //     .layoutController
      //     .addListener(() {
      //   _scrollListener(_scrollController!,
      //       Provider.of<MainModel>(context, listen: false));
      // });
    });
    // model.setShadowActive(false);
    // model.layoutController.addListener(() {
    //   _scrollListener(model.layoutController, model);
    // });
    // }
    //--> Set navbar shadow not active when firest build;
    _scrollController!.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollListener(_scrollController!, mainModel);
        // print(Provider.of<MainModel>(context).toString());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _scrollController!.dispose();
    // Provider.of<MainModel>(context, listen: false).layoutController;
    // model.layoutController.dispose();
  }

  resetState() {
    widget.resetState!();
    setState(() {
      print(jwtToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
      value: mainModel,
      child: Consumer<MainModel>(builder: (context, model, child) {
        if (model.autoScrollSearch) {
          autoScroll().then((value) {
            mainModel.setAutoScrollSearch(false);
          });
        }
        return Scaffold(
          // floatingActionButton: InkWell(
          //   onTap: () {},
          //   child: Container(
          //     width: 30,
          //     height: 30,
          //     child: Icon(
          //       Icons.arrow_upward_sharp,
          //     ),
          //   ),
          // ),
          endDrawer: Drawer(
            backgroundColor: white,
            child: Text('Drawer'),
          ),
          body: GestureDetector(
            onTap: () {
              popUpProfile(false);
              // widget.setDatePickerStatus!(false);
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            // model.navbarShadow
                            BoxShadow(
                              blurRadius: !model.shadowActive ? 0 : 40,
                              offset: !model.shadowActive
                                  ? Offset(0, 0)
                                  : Offset(0, 0),
                              color: Color.fromRGBO(29, 29, 29, 0.1),
                            )
                          ],
                        ),
                        child: NavigationBarWeb(
                          index: widget.index,
                          popUpProfile: popUpProfile,
                          popUpStatus: profileVisible,
                          getProfile: _getEntry(context),
                          resetState: widget.resetState,
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Scrollbar(
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: screenWidth > 1000
                                              ? screenHeight - 115 - 70
                                              : 0,
                                        ),
                                        child: widget.child!),
                                    FooterWeb(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child: ConstrainedBox(
                      //       constraints: pageConstraints,
                      //       child: CustomScrollView(
                      //         controller: _scrollController,
                      //         // controller: model.layoutController,
                      //         slivers: [
                      //           SliverList(
                      //             delegate: SliverChildListDelegate(
                      //               [
                      //                 // const SizedBox(
                      //                 //   height: 20,
                      //                 // ),
                      //                 // ConstrainedBox(
                      //                 //   constraints: pageConstraints.copyWith(
                      //                 //       minHeight: MediaQuery.of(context)
                      //                 //           .size
                      //                 //           .height),
                      //                 //   child: widget.child!,
                      //                 // ),
                      //                 widget.child!
                      //                 // const SizedBox(
                      //                 //   height: 20,
                      //                 // ),
                      //               ],
                      //             ),
                      //           ),
                      //           const SliverFillRemaining(
                      //             hasScrollBody: false,
                      //             child: Align(
                      //               alignment: Alignment.bottomCenter,
                      //               child: FooterWeb(),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  opacityOn
                      ? Positioned(
                          top: 60,
                          child: Opacity(
                            opacity: opacityOn ? 0.5 : 0,
                            child: Container(
                              color: eerieBlack.withOpacity(0.5),
                              height: MediaQuery.of(context).size.height - 60,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        )
                      : SizedBox(),
                  Positioned(
                    right: 20,
                    top: 45,
                    child: Visibility(
                      visible: profileVisible,
                      child: Center(
                        child: Container(
                          // color: Colors.amber,
                          child: PopUpProfile(
                            name: employeeName,
                            email: employeeEmail,
                            popUpProfile: popUpProfile,
                            resetState: resetState,
                            isAdmin: isAdmin,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: model.upBottonVisible,
                    child: Positioned(
                      bottom: !model.upBottonVisible
                          ? 20
                          : _scrollController!.position.atEdge
                              ? 135
                              : 20,
                      right: 20,
                      child: SizedBox(
                        height: 45,
                        width: 85,
                        child: GoToTopButton(
                          onTap: () {
                            scrollToTop();
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  OverlayEntry _getEntry(context) {
    OverlayEntry entry;
    entry = OverlayEntry(
      // opaque: true,
      builder: (context) {
        return Positioned(
          right: 20,
          top: 45,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Material(
            child: PopUpProfile(
              name: 'Luthfi',
              email: 'luthfiizhar@gmail.com',
              popUpProfile: popUpProfile,
              resetState: resetState,
            ),
          ),
        );
      },
    );

    return entry;
  }
}
