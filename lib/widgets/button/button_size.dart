import 'package:flutter/material.dart';

class ButtonSize {
  EdgeInsetsGeometry longSize() {
    return const EdgeInsets.symmetric(horizontal: 100, vertical: 18);
  }

  EdgeInsetsGeometry mediumSize() {
    return const EdgeInsets.symmetric(horizontal: 50, vertical: 18);
  }

  EdgeInsetsGeometry smallSize() {
    return const EdgeInsets.symmetric(horizontal: 32, vertical: 18);
  }
}
