import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:step_tech/models/orders/orders_req.dart';
import 'package:step_tech/services/config.dart';

class PaymentHelper {
  static var client = http.Client();

  Future<String> payment(Order model) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE',
      };

      var url = Uri.https(Config.paymentBaseUrl, Config.paymentUrl);

      var response = await client.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          model.toJson(),
        ),
      );

      if (response.statusCode == 200) {
        var payment = jsonDecode(response.body);
        return payment['url'];
      } else if (response.statusCode == 400) {
        throw Exception("Bad request");
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        return 'failed';
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in payment: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in payment: $e");
      throw Exception("An error occurred: $e");
    }
  }
}
