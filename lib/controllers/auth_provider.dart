import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/models/auth/login_model.dart';
import 'package:step_tech/models/auth/signup_model.dart';
import 'package:step_tech/services/auth_helper.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isObsecure = false;
  bool get isObsecure => _isObsecure;
  set isObsecure(bool newState) {
    _isObsecure = newState;
    notifyListeners();
  }

  bool _processing = false;
  bool get processing => _processing;
  set processing(bool newState) {
    _processing = newState;
    notifyListeners();
  }

  bool _loginResponseBool = false;
  bool get loginResponseBool => _loginResponseBool;
  set loginResponseBool(bool newState) {
    _loginResponseBool = newState;
    notifyListeners();
  }

  bool _responseBool = false;
  bool get responseBool => _responseBool;
  set responseBool(bool newState) {
    _responseBool = newState;
    notifyListeners();
  }

  bool? _loggeIn;
  bool get loggeIn => _loggeIn ?? false;
  set loggeIn(bool newState) {
    _loggeIn = newState;
    notifyListeners();
  }

  Future<bool> userLogin(LoginModel model) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    processing = true;
    try {
      bool response = await AuthHelper().login(model);
      processing = false;
      loginResponseBool = response;

      // Simpan token atau status login ke SharedPreferences
      if (response) {
        prefs.setBool('isLogged', true);
        // Simpan token jika Anda menggunakannya
        // prefs.setString('token', 'token_value');
      }

      loggeIn = prefs.getBool('isLogged') ?? false;
      return loginResponseBool;
    } catch (e) {
      processing = false;
      // Tangkap pesan kesalahan dan lempar kembali pesan tersebut
      throw Exception('Failed to login');
    }
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.setBool('isLogged', false);
    loggeIn = prefs.getBool('isLogged') ?? false;
  }

  Future<bool> registerUser(SignupModel model) async {
    try {
      responseBool = await AuthHelper().register(model);
      return responseBool;
    } catch (e) {
      // Tangkap pesan kesalahan dan lempar kembali pesan tersebut
      throw Exception('Failed to register');
    }
  }

  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loggeIn = prefs.getBool('isLogged') ?? false;
  }
}
