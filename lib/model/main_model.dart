import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/pages/admin/admin_list_approval_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  late bool _isFirstLogin = true;
  BoxShadow _navbarShadow = const BoxShadow();
  double _blurRadiusNavbar = 0;
  Offset _offsetNavbar = Offset(0, 0);
  static ScrollController _layoutController = ScrollController();

  String _jwtToken = "";

  Color? _settingPageActiveColor;

  String _selectedDate = "";
  String _selectedArea = "";
  List _dataRoom = [];
  List _eventRoom = [];

  bool _autoScrollSearch = false;

  bool _profilePopup = false;

  bool _upBottonVisible = false;

  bool _shadowActive = false;
  bool _feedback = false;
  bool _feedbackBanner = false;

  bool _isScrolling = false;
  bool _isScrollAtEdge = false;
  double _scrollPosition = 0;

  RoomEventDataSource _events =
      RoomEventDataSource(<RoomEvent>[], <CalendarResource>[]);
  List _approvalList = [];
  List _approvalCountList = [];
  SearchTerm _searchTerm = SearchTerm();
  ListApprovalBody _approvalBody = ListApprovalBody();
  int _approvalTotalResult = 0;

  String get jwtToken => _jwtToken;
  ScrollController get layoutController => _layoutController;
  bool get shadowActive => _shadowActive;
  bool get profilePopup => _profilePopup;
  bool get autoScrollSearch => _autoScrollSearch;
  bool get upBottonVisible => _upBottonVisible;
  bool get isScrolling => _isScrolling;
  bool get isScrollAtEdge => _isScrollAtEdge;
  double get scrollPosition => _scrollPosition;

  bool get feedback => _feedback;
  bool get feedbackBanner => _feedbackBanner;

  String get selectedDate => _selectedDate;
  String get selectedArea => _selectedArea;
  List get dataRoom => _dataRoom;
  List get eventRoom => _eventRoom;
  Color get settingPageActiveColor => _settingPageActiveColor!;

  RoomEventDataSource get events => _events;

  int _testScroll = 0;

  bool get isAuthenticated => _isAuthenticated;

  bool get firstLogin => _isFirstLogin;

  BoxShadow get navbarShadow => _navbarShadow;

  double get blurRadiusNavbar => _blurRadiusNavbar;
  Offset get offsetNavbar => _offsetNavbar;

  int get testScroll => _testScroll;

  List get approvalList => _approvalList;
  List get approvalCountList => _approvalCountList;
  SearchTerm get searchTerm => _searchTerm;
  ListApprovalBody get approvalBody => _approvalBody;
  int get approvalTotalResult => _approvalTotalResult;

  void setJwtToken(String value) {
    _jwtToken = value;
    notifyListeners();
  }

  void setUpBotton(bool value) {
    _upBottonVisible = value;
    notifyListeners();
  }

  void setSettingPageActiveColor(Color value) {
    _settingPageActiveColor = value;
    notifyListeners();
  }

  void setIsScrollAtEdge(bool value) {
    _isScrollAtEdge = value;
    notifyListeners();
  }

  void setScrollPosition(double value) {
    _scrollPosition = value;
    notifyListeners();
  }

  void setIsScrolling(bool value) {
    _isScrolling = value;
    notifyListeners();
  }

  void setAutoScrollSearch(bool value) {
    _autoScrollSearch = value;
    notifyListeners();
  }

  void setProfilePopup(bool value) {
    _profilePopup = value;
    notifyListeners();
  }

  void setShadowActive(bool value) {
    _shadowActive = value;
    notifyListeners();
  }

  void setNavShadow() {
    // _navbarShadow = const BoxShadow(
    //   blurRadius: 10,
    //   color: eerieBlack,
    //   offset: Offset(0, 10),
    // );
    _testScroll++;
    _blurRadiusNavbar = 10;
    // _offsetNavbar = Offset(0, 5);
    notifyListeners();
  }

  void removeNavShadow() {
    // _navbarShadow = const BoxShadow(
    //   blurRadius: 0,
    //   // color: eerieBlack,
    //   offset: Offset(0, 0),
    // );
    _testScroll = 0;
    _blurRadiusNavbar = 0;
    // _offsetNavbar = Offset(0, 0);
    notifyListeners();
  }

  void onBoardDone() {
    _isFirstLogin = false;
    notifyListeners();
  }

  void login() {
    _isAuthenticated = true;
    _isFirstLogin = true;
    notifyListeners();
  }

  void setEvents(dynamic data, List dataRoom, List eventRoom) {
    _events.appointments!.clear();
    dataRoom = data;
    int length = dataRoom.length;
    // print(dataRoom);
    for (var i = 0; i < length; i++) {
      eventRoom = dataRoom[i]['Bookings'];

      for (var j = 0; j < eventRoom.length; j++) {
        _events.appointments!.add(
          RoomEvent(
            // subject: ,
            resourceIds: [dataRoom[i]['RoomID']],
            from: DateTime.parse(eventRoom[j]['StartDateTime']),
            to: DateTime.parse(eventRoom[j]['EndDateTime']),
            background: davysGray,
            capacity: 5,
            contactID: "1111",
            isAllDay: false,
            eventName: eventRoom[j]['Description'],
            organizer: "",
            recurrenceRule: "NONE",
            endTimeZone: "",
            startTimeZone: "",
            bookingID: eventRoom[j]['BookingID'],
          ),
        );
      }
    }
    _events.notifyListeners(
        CalendarDataSourceAction.reset, _events.appointments!);
    notifyListeners();
  }

  void setSelectedDate(String value) {
    _selectedDate = value;
    notifyListeners();
  }

  void setSelectedArea(String value) {
    _selectedArea = value;
    notifyListeners();
  }

  void setDataAndEventRoom(List value) {
    _dataRoom = value;
    notifyListeners();
  }

  setEventRoom(List value) {
    _eventRoom = value;
    notifyListeners();
  }

  setEvent(RoomEventDataSource value) {
    _events = value;
    notifyListeners();
  }

  setApprovalTotalResult(int value) {
    _approvalTotalResult = value;
    notifyListeners();
  }

  setAprrovalBody(ListApprovalBody value) {
    _approvalBody = value;
    notifyListeners();
  }

  updateApprovalList(List value) {
    _approvalList = value;
    notifyListeners();
  }

  updateApprovalCountList(List value) {
    _approvalCountList = value;
    notifyListeners();
  }

  setFeedback(bool feedbackVal, bool bannerVal) {
    _feedback = feedbackVal;
    _feedbackBanner = bannerVal;
    notifyListeners();
  }
}
