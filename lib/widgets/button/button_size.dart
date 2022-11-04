import 'package:flutter/material.dart';

class ButtonSize {
  EdgeInsetsGeometry longSize() {
    return const EdgeInsets.symmetric(horizontal: 100, vertical: 20);
  }

  EdgeInsetsGeometry mediumSize() {
    return const EdgeInsets.symmetric(horizontal: 50, vertical: 20);
  }

  EdgeInsetsGeometry smallSize() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
  }

  EdgeInsetsGeometry loginButotn() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 17);
  }

  EdgeInsetsGeometry itemQtyButton() {
    return const EdgeInsets.symmetric(horizontal: 5, vertical: 5);
  }
}
