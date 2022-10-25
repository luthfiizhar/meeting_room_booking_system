import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/main.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/widgets/button/go_to_top_button.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:meeting_room_booking_system/widgets/pop_up_profile.dart';
import 'package:provider/provider.dart';

class LayoutPageWeb extends StatefulWidget {
  LayoutPageWeb({
    required this.child,
    this.index,
    this.setDatePickerStatus,
  });

  Widget? child;
  int? index;
  Function? setDatePickerStatus;

  @override
  State<LayoutPageWeb> createState() => _LayoutPageWebState();
}

class _LayoutPageWebState extends State<LayoutPageWeb> {
  ScrollController? _scrollController = ScrollController();
  MainModel mainModel = MainModel();
  bool profileVisible = false;
  // bool upBottonVisible = false;
  popUpProfile(bool value) {
    if (profileVisible) {
      profileVisible = value;
    } else {
      profileVisible = value;
    }
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
      } else {
        // Provider.of<MainModel>(context, listen: false)
        //     .setShadowActive(true);
        // Provider.of<MainModel>(context, listen: false).setUpBotton(true);
        mainModel.setShadowActive(true);
        mainModel.setUpBotton(true);
      }
    }

    // widget.setDatePickerStatus!(false);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              widget.setDatePickerStatus!(false);
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
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: CustomScrollView(
                            controller: _scrollController,
                            // controller: model.layoutController,
                            slivers: [
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ConstrainedBox(
                                      constraints: pageConstraints,
                                      child: widget.child!,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FooterWeb(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 20,
                    top: 45,
                    child: Visibility(
                      visible: profileVisible,
                      child: Center(
                        child: Container(
                          // color: Colors.amber,
                          child: PopUpProfile(
                            name: 'Luthfi',
                            email: 'luthfiizhar@gmail.com',
                            popUpProfile: popUpProfile,
                            resetState: resetState,
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
