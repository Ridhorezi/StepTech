import 'package:flutter/material.dart';
import 'package:step_tech/models/auth/profile_model.dart';
import 'package:step_tech/services/profile_helper.dart';

class ProfileNotifier extends ChangeNotifier {
  late ProfileModel _profileData;

  ProfileModel get profileData => _profileData;

  set profileData(ProfileModel newData) {
    _profileData = newData;
    notifyListeners();
  }

  bool _responseBool = false;
  bool get responseBool => _responseBool;
  set responseBool(bool newState) {
    _responseBool = newState;
    notifyListeners();
  }

  Future<bool> updateProfile(ProfileModel model) async {
    try {
      responseBool = await ProfileHelper().updateProfile(model);
      return responseBool;
    } catch (e) {
      return false;
    }
  }
}
