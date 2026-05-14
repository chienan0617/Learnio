import 'package:learnio/base.dart';

class AuthController {
  static final AuthController instance = AuthController._internal();
  AuthController._internal();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    Data.app.put("logged_in", true);
    rebuild('main');
  }

  void logout() {
    _isLoggedIn = false;
    Data.app.put("logged_in", false);
    rebuild('main');
  }

  void checkAuth() {
    _isLoggedIn = Data.app.get<bool>("logged_in", false);
  }

  bool hasFinishedIntro() {
    return Data.app.get<bool>("tutored", false);
  }

  void finishIntro() {
    Data.app.put("tutored", true);
    rebuild('main');
  }
}
