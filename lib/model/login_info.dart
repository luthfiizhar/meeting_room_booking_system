import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class LoginInfoModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  late bool _isFirstLogin = true;
  BoxShadow _navbarShadow = const BoxShadow();
  double _blurRadiusNavbar = 0;
  Offset _offsetNavbar = Offset(0, 0);

  bool _shadowActive = false;

  bool get shadowActive => _shadowActive;

  int _testScroll = 0;

  bool get isAuthenticated => _isAuthenticated;

  bool get firstLogin => _isFirstLogin;

  BoxShadow get navbarShadow => _navbarShadow;

  double get blurRadiusNavbar => _blurRadiusNavbar;
  Offset get offsetNavbar => _offsetNavbar;

  int get testScroll => _testScroll;

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
