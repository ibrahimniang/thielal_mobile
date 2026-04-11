import 'package:flutter/material.dart';

class ContextExtensions {
  ContextExtensions._();
}

extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.of(this).size;

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  void unfocus() => FocusScope.of(this).unfocus();
}
