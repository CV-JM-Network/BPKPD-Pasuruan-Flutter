import 'package:flutter/cupertino.dart';

import 'login_response.dart';

class UserProvider with ChangeNotifier {
  Data? _user;

  Data? get user => _user;

  void setUser(Data user) {
    _user = user;
    notifyListeners();
  }
}