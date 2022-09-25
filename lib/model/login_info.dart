import 'package:flutter/material.dart';

class LoginInfoModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  late bool _isFirstLogin = true;

  bool get isAuthenticated => _isAuthenticated;

  bool get firstLogin => _isFirstLogin;

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
