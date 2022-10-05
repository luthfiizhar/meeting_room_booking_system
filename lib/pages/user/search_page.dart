import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/login_info.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button_white.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_white.dart';
import 'package:meeting_room_booking_system/widgets/calendar_view_page/calendar_menu_item.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/white_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_white.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/white_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/footer.dart';
import 'package:meeting_room_booking_system/widgets/input/input_search_page.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/white_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:meeting_room_booking_system/widgets/pop_up_profile.dart';
import 'package:meeting_room_booking_system/widgets/search_page/check_box_amenities.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? _bookDate = TextEditingController();
  TextEditingController? _startTime = TextEditingController();
  TextEditingController? _endTime = TextEditingController();
  TextEditingController? _participant = TextEditingController();

  FocusNode _testInputNode = FocusNode();
  FocusNode _testInput2Node = FocusNode();
  FocusNode _testInputWhiteNode = FocusNode();
  FocusNode _dropdownBlackNode = FocusNode();
  FocusNode _dropdownWhiteNode = FocusNode();
  FocusNode _blackDateNode = FocusNode();

  TextEditingController? _testInputField = TextEditingController();
  TextEditingController? _testInputFieldDisabled = TextEditingController();
  TextEditingController? _testInputWhiteField = TextEditingController();

  String? dropdownBlackValue;

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];

  bool isPassword = true;

  int? participant = 1;

  int? selectedRoom = 1;

  int activeCalendarMenu = 2;
  int selectedMenu = 1;

  bool checkBoxAmenTv = false;
  bool checkBoxAmenCam = false;
  List? selectedAmen = [];

  final _formKey = new GlobalKey<FormState>();

  TimeOfDay selectedTime = TimeOfDay.now();

  List<Room> roomList = [];

  BoxShadow? navbarShadow = BoxShadow(
    blurRadius: 0,
    offset: Offset(0, 0),
  );

  ScrollController? _scrollController = ScrollController();

  bool profileVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LoginInfoModel>(context, listen: false)
          .setShadowActive(false);
    });

    // TODO: implement initState
    super.initState();
    _participant!.text = participant.toString();
    roomList.add(Room(
      roomId: 'R202',
      roomName: 'PERSISTANCE',
      areaId: '2',
      availability: true,
      bookingDuration: '2',
      capacity: '8',
      roomType: 'medium',
    ));

    _testInputNode.addListener(() {
      setState(() {});
    });
    _testInputWhiteNode.addListener(() {
      setState(() {});
    });
    _dropdownBlackNode.addListener(() {
      setState(() {});
    });
    _dropdownWhiteNode.addListener(() {
      setState(() {});
    });
    _blackDateNode.addListener(() {
      setState(() {});
    });
    _testInput2Node.addListener(() {
      setState(() {});
    });

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
    _testInputNode.dispose();
    _testInputWhiteNode.dispose();
    _dropdownBlackNode.dispose();
    _blackDateNode.dispose();
    _bookDate!.dispose();
    _endTime!.dispose();
    _participant!.dispose();
    _startTime!.dispose();
    _testInputField!.dispose();
    _testInputWhiteField!.dispose();
  }

  List<DropdownMenuItem<String>> addDividerItem(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<DropdownMenuItem<String>> addDividerItemWhite(List<String> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                color: culturedWhite,
              ),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights(List items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(15);
      }
    }
    return _itemsHeights;
  }

  _scrollListener(ScrollController scrollInfo, LoginInfoModel model) {
    // setState(() {});
    // print(scrollInfo.position.minScrollExtent);
    if (scrollInfo.offset == 0) {
      Provider.of<LoginInfoModel>(context, listen: false)
          .setShadowActive(false);
    } else {
      Provider.of<LoginInfoModel>(context, listen: false).setShadowActive(true);
      print('scroll');
    }
  }

  _onStartScroll(ScrollMetrics metrics) {
    print("Scroll Start");
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    print("Scroll Update");
  }

  _onEndScroll(ScrollMetrics metrics) {
    print("Scroll End");
  }

  popUpProfile(bool value) {
    if (profileVisible) {
      profileVisible = value;
    } else {
      profileVisible = value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 1,
      child: Form(
        key: _formKey,
        child: searchRoom(),
      ),
    );
    // return Consumer<LoginInfoModel>(builder: (context, model, child) {
    //   return Scaffold(
    //     body: Center(
    //       child: ConstrainedBox(
    //         constraints: pageConstraints,
    //         child: Align(
    //           alignment: Alignment.topCenter,
    //           child: Stack(
    //             children: [
    //               Column(
    //                 children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                       boxShadow: [
    //                         // model.navbarShadow
    //                         BoxShadow(
    //                           blurRadius: !model.shadowActive ? 0 : 40,
    //                           offset: !model.shadowActive
    //                               ? Offset(0, 0)
    //                               : Offset(0, 0),
    //                           color: Color.fromRGBO(29, 29, 29, 0.1),
    //                         )
    //                       ],
    //                     ),
    //                     child: NavigationBarWeb(
    //                       index: 1,
    //                       popUpProfile: popUpProfile,
    //                     ),
    //                   ),
    //                   // Container(
    //                   //   color: Color.fromRGBO(29, 29, 29, 0.1),
    //                   //   height: 1,
    //                   // ),
    //                   Expanded(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(top: 5),
    //                       child: CustomScrollView(
    //                         controller: _scrollController,
    //                         slivers: [
    //                           SliverList(
    //                             delegate: SliverChildListDelegate(
    //                               [
    //                                 SizedBox(
    //                                   height: 20,
    //                                 ),
    //                                 Form(
    //                                   key: _formKey,
    //                                   child: searchRoom(),
    //                                 ),
    //                                 SizedBox(
    //                                   height: 20,
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           // const SliverFillRemaining(
    //                           //   hasScrollBody: false,
    //                           //   child: Align(
    //                           //     alignment: Alignment.bottomCenter,
    //                           //     child: FooterWeb(),
    //                           //   ),
    //                           // )
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               Positioned(
    //                 right: 20,
    //                 top: 65,
    //                 child: Visibility(
    //                   visible: profileVisible,
    //                   child: Container(
    //                     // color: Colors.amber,
    //                     child: PopUpProfile(
    //                       name: 'Luthfi',
    //                       email: 'luthfiizhar@gmail.com',
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // });
  }

  Widget searchRoom() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: eerieBlack),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 6,
                    child: bookingDateInput(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    // flex: 6,
                    child: checkBoxAmenities(),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: bookingTimeInput(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: participantInput(),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: RegularButton(
                  text: 'Search',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  disabled: true,
                  padding: ButtonSize().longSize(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: RegularButton(
                  text: 'Dialog test',
                  onTap: () {
                    // if (_formKey.currentState!.validate()) {}
                    // _showProfileLayer();
                  },
                  disabled: false,
                  padding: ButtonSize().longSize(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: WhiteRegularButton(
                  text: 'White Version',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  disabled: true,
                  padding: ButtonSize().longSize(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: TransparentButtonBlack(
                  text: 'Transparent Black Version',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  disabled: true,
                  padding: ButtonSize().longSize(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: TransparentButtonBlack(
                  padding: ButtonSize().longSize(),
                  text: 'Black pop up small',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfirmDialogBlack(
                          title: 'Confirmation',
                          contentText: 'Are you sure to change visit time?',
                        );
                      },
                    );
                  },
                  disabled: false,
                  // backgroundColor: cardBg,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: TransparentButtonBlack(
                  padding: ButtonSize().longSize(),
                  text: 'white pop up small',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfirmDialogWhite(
                          title: 'Confirmation',
                          contentText: 'Are you sure to change visit time?',
                        );
                      },
                    ).then((value) {});
                  },
                  disabled: false,
                  // backgroundColor: cardBg,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                // height: 40,
                // width: 250,
                child: TransparentButtonBlack(
                  padding: ButtonSize().longSize(),
                  text: 'Alert pop Up small',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialogBlack(
                          title: 'Success',
                          contentText: 'Your changes has been saved.',
                        );
                      },
                    ).then((value) {});
                  },
                  disabled: false,
                  // backgroundColor: cardBg,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(10),
          // height: 300,
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: eerieBlack),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: BlackInputField(
                  enabled: true,
                  controller: _testInputField!,
                  hintText: 'Please input here',
                  focusNode: _testInputNode,
                  obsecureText: false,
                  suffixIcon: _testInputNode.hasFocus
                      ? IconButton(
                          onPressed: () {
                            _testInputField!.text = "";
                          },
                          icon: const Icon(
                            Icons.close,
                            color: eerieBlack,
                          ),
                        )
                      : SizedBox(),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.zero,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5),
                //   boxShadow: _testInputNode.hasFocus
                //       ? const [
                //           BoxShadow(
                //             blurRadius: 40,
                //             offset: Offset(0, 10),
                //             // blurStyle: BlurStyle.outer,
                //             color: Color.fromRGBO(29, 29, 29, 0.2),
                //           )
                //         ]
                //       : null,
                // ),
                child: SizedBox(
                  width: 250,
                  child: BlackInputField(
                    enabled: true,
                    controller: _testInputField!,
                    hintText: 'Password',
                    focusNode: _testInputNode,
                    obsecureText: isPassword,
                    suffixIcon: _testInputNode.hasFocus
                        ? IconButton(
                            onPressed: () {
                              if (isPassword) {
                                isPassword = false;
                              } else {
                                isPassword = true;
                              }
                              setState(() {});
                            },
                            icon: isPassword
                                ? Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: eerieBlack,
                                    size: 18,
                                  )
                                : Icon(
                                    FontAwesomeIcons.eye,
                                    color: eerieBlack,
                                    size: 18,
                                  ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // boxShadow: _testInputNode.hasFocus
                  //     ? const [
                  //         BoxShadow(
                  //           blurRadius: 40,
                  //           offset: Offset(0, 10),
                  //           // blurStyle: BlurStyle.outer,
                  //           color: Color.fromRGBO(29, 29, 29, 0.2),
                  //         )
                  //       ]
                  //     : null,
                ),
                child: SizedBox(
                  width: 250,
                  child: BlackInputField(
                    enabled: false,
                    controller: _testInputFieldDisabled!,
                    hintText: 'Please input here',
                    focusNode: _testInput2Node,
                    obsecureText: false,
                    suffixIcon: SizedBox(),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: _dropdownBlackNode.hasFocus
                      ? const [
                          BoxShadow(
                            blurRadius: 40,
                            offset: Offset(0, 10),
                            // blurStyle: BlurStyle.outer,
                            color: Color.fromRGBO(29, 29, 29, 0.2),
                          )
                        ]
                      : null,
                ),
                child: SizedBox(
                  width: 250,
                  child: BlackDropdown(
                    // value: dropdownBlackValue,
                    focusNode: _dropdownBlackNode,
                    items: addDividerItem(items),
                    // items: items.map((e) {
                    //   return DropdownMenuItem(
                    //     child: Text(e),
                    //     value: e,
                    //   );
                    // }).toList(),
                    customHeights: _getCustomItemsHeights(items),
                    enabled: true,
                    hintText: 'Choose',
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: eerieBlack,
                    ),
                    onChanged: (value) {
                      dropdownBlackValue = value;
                      _dropdownBlackNode.unfocus();
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 250,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: _blackDateNode.hasFocus
                      ? const [
                          BoxShadow(
                            blurRadius: 40,
                            offset: Offset(0, 10),
                            // blurStyle: BlurStyle.outer,
                            color: Color.fromRGBO(29, 29, 29, 0.2),
                          )
                        ]
                      : null,
                ),
                child: BlackInputField(
                  controller: _bookDate!,
                  focusNode: _blackDateNode,
                  obsecureText: false,
                  enabled: true,
                  onTap: () {
                    _selectStartDate();
                  },
                  hintText: 'Select date',
                  suffixIcon: const Icon(
                    FontAwesomeIcons.calendarDays,
                    size: 16,
                    color: eerieBlack,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              BlackCheckBox(
                selectedValue: checkBoxAmenTv,
                onChanged: (value) {
                  if (checkBoxAmenTv) {
                    checkBoxAmenTv = false;
                    selectedAmen!.removeWhere((element) => element == 'tv');
                  } else {
                    checkBoxAmenTv = true;
                    selectedAmen!.add('tv');
                  }
                  setState(() {});
                },
                label: 'Enabled',
                filled: true,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(8),
          // height: 300,
          width: 500,
          color: Colors.black,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: WhiteCheckbox(
                    selectedValue: checkBoxAmenTv,
                    onChanged: (value) {
                      if (checkBoxAmenTv) {
                        checkBoxAmenTv = false;
                        selectedAmen!.removeWhere((element) => element == 'tv');
                      } else {
                        checkBoxAmenTv = true;
                        selectedAmen!.add('tv');
                      }
                      setState(() {});
                    },
                    label: 'Enabled',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  child: WhiteInputField(
                    controller: _testInputWhiteField!,
                    enabled: false,
                    focusNode: _testInputWhiteNode,
                    hintText: 'Placeholder',
                    obsecureText: false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: _testInputWhiteNode.hasFocus
                          ? [
                              BoxShadow(
                                // spreadRadius: 40,
                                blurRadius: 40,
                                offset: Offset(0, 10),
                                // blurStyle: BlurStyle.outer,
                                color: Color.fromRGBO(243, 243, 243, 0.2),
                              )
                            ]
                          : null,
                    ),
                    child: WhiteInputField(
                      enabled: true,
                      focusNode: _testInputWhiteNode,
                      controller: _testInputWhiteField!,
                      hintText: 'Please input here',
                      obsecureText: false,
                      suffixIcon: _testInputWhiteNode.hasFocus
                          ? IconButton(
                              onPressed: () {
                                _testInputWhiteField!.text = "";
                              },
                              icon: Icon(
                                Icons.close,
                                color: culturedWhite,
                                size: 18,
                              ),
                            )
                          : SizedBox(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: 250,
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: _testInputWhiteNode.hasFocus
                          ? const [
                              BoxShadow(
                                blurRadius: 40,
                                offset: Offset(0, 10),
                                color: Color.fromRGBO(243, 243, 243, 0.2),
                              )
                            ]
                          : null,
                    ),
                    child: WhiteInputField(
                      enabled: true,
                      focusNode: _testInputWhiteNode,
                      controller: _testInputWhiteField!,
                      hintText: 'Password',
                      obsecureText: isPassword,
                      suffixIcon: _testInputWhiteNode.hasFocus
                          ? IconButton(
                              onPressed: () {
                                if (isPassword) {
                                  isPassword = false;
                                } else {
                                  isPassword = true;
                                }
                                setState(() {});
                              },
                              icon: isPassword
                                  ? Icon(
                                      FontAwesomeIcons.eye,
                                      color: culturedWhite,
                                      size: 18,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.eyeSlash,
                                      color: culturedWhite,
                                      size: 18,
                                    ),
                            )
                          : SizedBox(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: _dropdownWhiteNode.hasFocus
                        ? const [
                            BoxShadow(
                              blurRadius: 40,
                              offset: Offset(0, 10),
                              // blurStyle: BlurStyle.outer,
                              color: Color.fromRGBO(243, 243, 243, 0.2),
                            )
                          ]
                        : null,
                  ),
                  child: SizedBox(
                    width: 250,
                    child: WhiteDropdown(
                      focusNode: _dropdownWhiteNode,
                      items: addDividerItemWhite(items),
                      customHeights: _getCustomItemsHeights(items),
                      enabled: true,
                      hintText: 'Choose',
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: culturedWhite,
                      ),
                      onChanged: (value) {
                        dropdownBlackValue = value;
                        _dropdownWhiteNode.unfocus();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  // width: 250,
                  child: WhiteRegularButton(
                    padding: ButtonSize().longSize(),
                    text: 'Black pop up big',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ConfirmDialogBlack(
                            title: 'Confirmation',
                            contentText:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed semper ligula quam, id pretium ligula euismod non',
                          );
                        },
                      );
                    },
                    disabled: false,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  // width: 250,
                  child: WhiteRegularButton(
                    padding: ButtonSize().longSize(),
                    text: 'White pop up big',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ConfirmDialogWhite(
                            title: 'Confirmation',
                            contentText:
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed semper ligula quam, id pretium ligula euismod non',
                          );
                        },
                      );
                    },
                    disabled: false,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: TransparentButtonWhite(
                    padding: ButtonSize().mediumSize(),
                    text: 'Transparent White Version',
                    onTap: () {},
                    disabled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Available Rooms'),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: roomList.length,
                  itemBuilder: (context, index) {
                    // var list = roomList;
                    return LayoutBuilder(builder: (context, constraints) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 400,
                          // height: 100,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: eerieBlack),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 175,
                                // height: double.infinity,
                                // decoration: BoxDecoration(),
                                // clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  'assets/persistance_1.png',
                                  fit: BoxFit.cover,
                                ),
                                // child: SizedBox(),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        roomList[index].roomName!,
                                        style: cardHeaderText,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .watch_later_outlined,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: roomList[index]
                                                                .availability!
                                                            ? "Available"
                                                            : "Not Available",
                                                        style: cardContentText
                                                            .copyWith(
                                                          color: roomList[index]
                                                                  .availability!
                                                              ? Colors.green
                                                              : orangeRed,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${roomList[index].capacity} Person',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons
                                                              .corporate_fare_sharp,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${roomList[index].areaId} Floor',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Amenities :',
                                                  style: cardContentText,
                                                ),
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.tv_sharp,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'TV',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 1,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.videocam_sharp,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const WidgetSpan(
                                                        child: SizedBox(
                                                          width: 1,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Camera',
                                                        style: cardContentText,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RegularButton(
                                        text: 'Book',
                                        // fontSize: 12,
                                        onTap: () {},
                                        disabled: false,
                                        padding: ButtonSize().smallSize(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bookingTimeInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time Start'),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectTime(_startTime!);
                    },
                    child: InputSearch(
                      controller: _startTime,
                      enabled: false,
                      suffix: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: scaffoldBg,
                        size: 20,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Required";
                        }
                        if (_endTime!.text == "") {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectTime(_startTime!);
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time End'),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: (() {
                      _selectTime(_endTime!);
                    }),
                    child: InputSearch(
                      controller: _endTime,
                      enabled: false,
                      suffix: Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: scaffoldBg,
                        size: 20,
                      ),
                      validator: (value) {
                        if (value == "") {
                          return "Required";
                        }
                        if (_startTime!.text == "") {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectTime(_endTime!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget participantInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Participant (total person)'),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(
              width: 130,
              child: InputSearch(
                controller: _participant,
                enabled: false,
                suffix: Icon(
                  Icons.people_sharp,
                  size: 20,
                  color: scaffoldBg,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              height: 40,
              child: Column(children: [
                InkWell(
                  onTap: () {
                    participant = participant! + 1;
                    _participant!.text = participant.toString();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.keyboard_arrow_up_sharp,
                    size: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    participant = participant! - 1;
                    if (participant! <= 0) {
                      participant = 1;
                    }
                    _participant!.text = participant.toString();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 20,
                  ),
                )
              ]),
            )
            // Expanded(
            //   child: SizedBox(
            //     height: 40,
            //     child: ElevatedButton(
            //       child: Icon(Icons.search_sharp),
            //       onPressed: () {
            //         if (_formKey.currentState!.validate()) {}
            //       },
            //       style: ButtonStyle(
            //         foregroundColor:
            //             MaterialStateProperty.resolveWith(getColor),
            //         backgroundColor:
            //             MaterialStateProperty.resolveWith<Color>((states) {
            //           return spanishGray;
            //         }),
            //         shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
            //             (Set<MaterialState> states) {
            //           if (states.contains(MaterialState.pressed))
            //             return RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10),
            //                 side: BorderSide(color: eerieBlack, width: 5));
            //           return RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10));
            //         }),
            //         overlayColor: MaterialStateProperty.resolveWith<Color?>(
            //           (Set<MaterialState> states) {
            //             if (states.contains(MaterialState.pressed))
            //               return Colors.white; //<-- SEE HERE
            //             return null; // Defer to the widget's default.
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget bookingDateInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Booking For'),
        SizedBox(
          height: 10,
        ),
        InputSearch(
          controller: _bookDate,
          enabled: true,
          prefix: Icon(
            Icons.calendar_month_outlined,
            color: scaffoldBg,
            size: 20,
          ),
          onTap: () {
            _selectStartDate();
          },
        ),
      ],
    );
  }

  Future _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.inputOnly,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: eerieBlack,
                onPrimary: silver,
                onSurface: eerieBlack,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: eerieBlack,
                ),
              ),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
          );
        });

    if (picked_s != null) {
      final hour = picked_s.hour.toString().padLeft(2, '0');
      final minute = picked_s.minute.toString().padLeft(2, '0');
      setState(() {
        selectedTime = picked_s;
        controller.text = "$hour:$minute";
      });
    }
  }

  Future _selectStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: eerieBlack,
              onPrimary: silver,
              onSurface: eerieBlack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: eerieBlack,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    String formattedDate = DateFormat('d MMMM yyyy').format(picked!);
    if (picked != null)
      setState(() {
        _bookDate!.text = formattedDate;
      });
  }

  Widget checkBoxAmenities() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amenities'),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CheckBoxAmenities(
                selectedValue: checkBoxAmenTv,
                onChanged: (value) {
                  print('check');
                  if (checkBoxAmenTv) {
                    checkBoxAmenTv = false;
                    selectedAmen!.removeWhere((element) => element == 'tv');
                  } else {
                    checkBoxAmenTv = true;
                    selectedAmen!.add('tv');
                  }
                  setState(() {});
                  print(selectedAmen);
                },
                label: 'Enabled',
              ),
              SizedBox(
                width: 10,
              ),
              CheckBoxAmenities(
                selectedValue: checkBoxAmenCam,
                onChanged: (value) {
                  if (checkBoxAmenCam) {
                    checkBoxAmenCam = false;
                    selectedAmen!.removeWhere((element) => element == 'cam');
                  } else {
                    checkBoxAmenCam = true;
                    selectedAmen!.add('cam');
                  }
                  setState(() {});
                  print(selectedAmen);
                },
                label: 'Camera',
              ),
            ],
          ),
        )
      ],
    );
  }
}
