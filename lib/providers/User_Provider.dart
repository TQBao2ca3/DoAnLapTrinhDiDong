import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int _userId = 0;

  int get userId => _userId;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  void clearUserId() {
    _userId = 0;
    notifyListeners();
  }
}
