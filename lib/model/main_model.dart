import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/model/room_event_class.dart';
import 'package:meeting_room_booking_system/model/room_event_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  late bool _isFirstLogin = true;
  BoxShadow _navbarShadow = const BoxShadow();
  double _blurRadiusNavbar = 0;
  Offset _offsetNavbar = Offset(0, 0);
  static ScrollController _layoutController = ScrollController();

  String _selectedDate = "";
  String _selectedArea = "";
  List _dataRoom = [];
  List _eventRoom = [];

  bool _autoScrollSearch = false;

  bool _profilePopup = false;

  bool _upBottonVisible = false;

  bool _shadowActive = false;

  bool _isScrolling = false;
  bool _isScrollAtEdge = false;
  double _scrollPosition = 0;

  final RoomEventDataSource _events =
      RoomEventDataSource(<RoomEvent>[], <CalendarResource>[]);

  ScrollController get layoutController => _layoutController;
  bool get shadowActive => _shadowActive;
  bool get profilePopup => _profilePopup;
  bool get autoScrollSearch => _autoScrollSearch;
  bool get upBottonVisible => _upBottonVisible;
  bool get isScrolling => _isScrolling;
  bool get isScrollAtEdge => _isScrollAtEdge;
  double get scrollPosition => _scrollPosition;

  String get selectedDate => _selectedDate;
  String get selectedArea => _selectedArea;
  List get dataRoom => _dataRoom;
  List get eventRoom => _eventRoom;

  RoomEventDataSource get events => _events;

  int _testScroll = 0;

  bool get isAuthenticated => _isAuthenticated;

  bool get firstLogin => _isFirstLogin;

  BoxShadow get navbarShadow => _navbarShadow;

  double get blurRadiusNavbar => _blurRadiusNavbar;
  Offset get offsetNavbar => _offsetNavbar;

  int get testScroll => _testScroll;

  void setUpBotton(bool value) {
    _upBottonVisible = value;
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
    print(_selectedDate);
    notifyListeners();
  }

  void setSelectedArea(String value) {
    _selectedArea = value;
    print(_selectedArea);
    notifyListeners();
  }

  void setDataAndEventRoom(List value) {
    _dataRoom = value;
    print(_dataRoom);
    notifyListeners();
  }

  setEventRoom(List value) {
    _eventRoom = value;
    print(_eventRoom);
    notifyListeners();
  }
}
