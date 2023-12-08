import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/models/auth/login_model.dart';
import 'package:step_tech/models/auth/signup_model.dart';
import 'package:step_tech/models/auth_response/login_res_model.dart';
import 'package:step_tech/models/auth_response/profile_model.dart';
import 'package:step_tech/services/config.dart';

class AuthHelper {
  static var client = http.Client();
  // Male
  Future<bool> login(LoginModel model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      };

      var url = Uri.https(Config.apiUrl, Config.loginUrl);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        String userToken = loginResponseModelFromJson(response.body).token;

        String userId = loginResponseModelFromJson(response.body).id;

        await prefs.setString('token', userToken);

        await prefs.setString('userId', userId);

        await prefs.setBool('isLogged', true);

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
      debugPrint("Timeout in login: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<bool> register(SignupModel model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      };

      var url = Uri.https(Config.apiUrl, Config.signupUrl);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(model.toJson()),
      );
      if (response.statusCode == 201) {
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
      debugPrint("Timeout in register: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<ProfileResponseModel> getProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userToken = prefs.getString('token');

      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
        "token": 'Bearer $userToken'
      };

      var url = Uri.https(Config.apiUrl, Config.getUserUrl);

      var response = await client.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        var profile = profileResponseFromJson(response.body);
        return profile;
      } else if (response.statusCode == 400) {
        throw Exception("Bad request");
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception("Failed get the profile");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getProfile: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
