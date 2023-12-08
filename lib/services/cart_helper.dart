import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_tech/models/cart/add_to_cart.dart';
import 'package:step_tech/models/cart/get_products.dart';
import 'package:step_tech/models/orders/orders_res.dart';
import 'package:step_tech/services/config.dart';
import 'package:http/http.dart' as http;

class CartHelper {
  static var client = http.Client();
  Future<bool> addToCart(AddToCart model) async {
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

      var url = Uri.https(Config.apiUrl, Config.addCartUrl);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          model.toJson(),
        ),
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
      debugPrint("Timeout in addToCart: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<List<Product>> getCart() async {
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

      var url = Uri.https(Config.apiUrl, Config.getCartUrl);

      var response = await client.get(
        url,
        headers: requestHeaders,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        List<Product> cart = [];

        var products = jsonData[0]['products'];

        cart = List<Product>.from(
          products.map(
            (product) => Product.fromJson(product),
          ),
        );

        return cart;
      } else if (response.statusCode == 400) {
        throw Exception("Bad request");
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception("Failed to get cart");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getCart: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<bool> deleteItem(String id) async {
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

      var url = Uri.https(Config.apiUrl, "${Config.addCartUrl}/$id");

      var response = await client.delete(
        url,
        headers: requestHeaders,
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
      debugPrint("Timeout in deleteItem: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<List<PaidOrders>> getOrders() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userToken = prefs.getString('token');

      if (userToken != null) {
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
          "token": 'Bearer $userToken'
        };

        var url = Uri.https(Config.apiUrl, Config.orders);

        var response = await client.get(
          url,
          headers: requestHeaders,
        );

        if (response.statusCode == 200) {
          var products = paidOrdersFromJson(response.body);

          return products;
        } else if (response.statusCode == 400) {
          throw Exception("Bad request");
        } else if (response.statusCode == 404) {
          throw Exception("Endpoint not found");
        } else if (response.statusCode == 500) {
          throw Exception("Internal server error");
        } else if (response.statusCode == 504) {
          throw Exception("Connection timeout");
        } else {
          throw Exception("Failed to get orders");
        }
      } else {
        throw Exception("User token is null");
      }
    } on TimeoutException catch (e) {
      debugPrint("Timeout in getOrders: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
