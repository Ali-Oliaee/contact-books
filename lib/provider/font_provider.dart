import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FontProvider with ChangeNotifier {
  String _currentFont = 'Ubuntu';

  String get currentFont => _currentFont;

  void toggleFont(String selectedFont) {
    _currentFont = selectedFont;
    notifyListeners();
  }
}
