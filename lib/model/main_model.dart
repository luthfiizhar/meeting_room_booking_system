import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class MainModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  late bool _isFirstLogin = true;
  BoxShadow _navbarShadow = const BoxShadow();
  double _blurRadiusNavbar = 0;
  Offset _offsetNavbar = Offset(0, 0);
  static ScrollController _layoutController = ScrollController();

  bool _autoScrollSearch = false;

  bool _profilePopup = false;

  bool _upBottonVisible = false;

  bool _shadowActive = false;

  bool _isScrolling = false;
  bool _isScrollAtEdge = false;
  double _scrollPosition = 0;

  ScrollController get layoutController => _layoutController;
  bool get shadowActive => _shadowActive;
  bool get profilePopup => _profilePopup;
  bool get autoScrollSearch => _autoScrollSearch;
  bool get upBottonVisible => _upBottonVisible;
  bool get isScrolling => _isScrolling;
  bool get isScrollAtEdge => _isScrollAtEdge;
  double get scrollPosition => _scrollPosition;

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
}
