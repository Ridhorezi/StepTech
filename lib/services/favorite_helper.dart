import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/models/favorites/add_to_favorite.dart';
import 'package:step_tech/models/favorites/get_products.dart';
import 'package:step_tech/services/config.dart';
import 'package:http/http.dart' as http;

class FavoriteHelper {
  static var client = http.Client();

  Future<bool> addToFavorite(AddToFavorite model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('token');

      if (userToken == null) {
        // Handle the case when the token is null (user not logged in)
        return false;
      }

      Map<String, String> requestHeaders = {
        "Content-Type": "application/json",
        "token": 'Bearer $userToken',
      };

      var url = Uri.https(Config.apiUrl, Config.addFavoriteUrl);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          model.toJson(),
        ),
      );

      if (response.statusCode == 200) {
        // You can modify this part based on the actual response from the server
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
        // You can modify this part based on the actual response from the server
        return false;
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in addToFavorite: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<List<Product>> getFavorite() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('token');

      if (userToken == null) {
        // Handle the case when the token is null (user not logged in)
        return [];
      }

      Map<String, String> requestHeaders = {
        "Content-Type": "application/json",
        "token": 'Bearer $userToken',
      };

      var url = Uri.https(Config.apiUrl, Config.getFavoriteUrl);

      var response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        List<Product> favorite = [];

        if (jsonData is List && jsonData.isNotEmpty) {
          var products = jsonData[0]['products'];

          favorite = List<Product>.from(
            products.map(
              (product) => Product.fromJson(product),
            ),
          );
        }

        return favorite;
      } else if (response.statusCode == 400) {
        throw Exception("Bad request");
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception("Failed to get Favorite");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getFavorite: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('token');

      if (userToken == null) {
        // Handle the case when the token is null (user not logged in)
        return false;
      }

      Map<String, String> requestHeaders = {
        "Content-Type": "application/json",
        "token": 'Bearer $userToken',
      };

      var url = Uri.https(Config.apiUrl, "${Config.addFavoriteUrl}/$id");

      var response = await client.delete(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        // You can modify this part based on the actual response from the server
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
        // You can modify this part based on the actual response from the server
        return false;
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in deleteItem: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
