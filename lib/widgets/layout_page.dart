import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
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
  bool profileVisible = false;
  popUpProfile(bool value) {
    if (profileVisible) {
      profileVisible = value;
    } else {
      profileVisible = value;
    }
    setState(() {});
  }

  _scrollListener(ScrollController scrollInfo, LoginInfoModel model) {
    // setState(() {});
    // print(scrollInfo.position.minScrollExtent);
    // popUpProfile(false);
    if (scrollInfo.offset == 0) {
      Provider.of<LoginInfoModel>(context, listen: false)
          .setShadowActive(false);
    } else {
      Provider.of<LoginInfoModel>(context, listen: false).setShadowActive(true);
      // print('scroll');
    }
    widget.setDatePickerStatus!(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LoginInfoModel>(context, listen: false)
          .setShadowActive(false);
    }); //--> Set navbar shadow not active when firest build;
    _scrollController!.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollListener(_scrollController!,
            Provider.of<LoginInfoModel>(context, listen: false));
        // print(Provider.of<LoginInfoModel>(context).toString());
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController!.dispose();
  }

  resetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginInfoModel>(builder: (context, model, child) {
      return Scaffold(
        endDrawer: Drawer(
          backgroundColor: white,
          child: Text('Drawer'),
        ),
        body: GestureDetector(
          onTap: () {
            popUpProfile(false);
            widget.setDatePickerStatus!(false);
          },
          child: Center(
            child: ConstrainedBox(
              constraints: pageConstraints,
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
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      widget.child!,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
