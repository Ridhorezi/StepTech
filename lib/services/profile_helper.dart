import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/models/auth/profile_model.dart';
import 'package:step_tech/services/config.dart';

class ProfileHelper {
  static var client = http.Client();

  Future<bool> updateProfile(ProfileModel model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userToken = prefs.getString('token');

      Map<String, String> requestHeaders = {
        "Content-Type": "application/json",
        "token": 'Bearer $userToken'
      };

      var url = Uri.https(Config.apiUrl, Config.updateProfileUrl);

      var response = await client.put(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        throw Exception("Bad request");
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        return false;
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in updateProfile: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in updateProfile: $e");
      throw Exception("An error occurred: $e");
    }
  }
}
