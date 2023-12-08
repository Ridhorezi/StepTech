import 'dart:async';

import 'package:flutter/material.dart';
import 'package:step_tech/models/sneaker_model.dart';
import 'package:http/http.dart' as http;
import 'package:step_tech/services/config.dart';

class Helper {
  static var client = http.Client();
  // Male
  Future<List<Sneakers>> getMaleSneakers() async {
    try {
      var url = Uri.https(Config.apiUrl, Config.sneakers);

      var response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      if (response.statusCode == 200) {
        final maleList = sneakersFromJson(response.body);
        var male =
            maleList.where((element) => element.category == "Men's Running");
        return male.toList();
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        // Menangani status code lainnya
        throw Exception(
            "Failed get male sneakers list with status code: ${response.statusCode}");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getMaleSneakers: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in getMaleSneakers: $e");
      throw Exception("An error occurred: $e");
    }
  }

  // Female
  Future<List<Sneakers>> getFemaleSneakers() async {
    try {
      var url = Uri.https(Config.apiUrl, Config.sneakers);

      var response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      if (response.statusCode == 200) {
        final femaleList = sneakersFromJson(response.body);
        var female = femaleList
            .where((element) => element.category == "Women's Running");
        return female.toList();
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        // Menangani status code lainnya
        throw Exception(
            "Failed get female sneakers list with status code: ${response.statusCode}");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getFemaleSneakers: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in getFemaleSnekers: $e");
      throw Exception("An error occurred: $e");
    }
  }

  // Kids
  Future<List<Sneakers>> getKidsSneakers() async {
    try {
      var url = Uri.https(Config.apiUrl, Config.sneakers);

      var response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      });

      if (response.statusCode == 200) {
        final kidsList = sneakersFromJson(response.body);
        var kids =
            kidsList.where((element) => element.category == "Kids' Running");
        return kids.toList();
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception(
            "Failed get kids sneakers list with status code: ${response.statusCode}");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getKidsSneakers: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in getKidsSneakers: $e");
      throw Exception("An error occurred: $e");
    }
  }

  // Single Male
  Future<Sneakers> getMaleSneakersById(String id) async {
    try {
      var url = Uri.https(Config.apiUrl, "${Config.sneakers}/$id");

      var response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final sneaker = sneakersFromJsonById(response.body);
        return sneaker;
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception(
            "Failed to get male sneakers by ID with status code: ${response.statusCode}");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getMaleSneakersById: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in getMaleSneakersById: $e");
      throw Exception("An error occurred: $e");
    }
  }

  // Single Female
  Future<Sneakers> getFemaleSneakersById(String id) async {
    try {
      var url = Uri.https(Config.apiUrl, "${Config.sneakers}/$id");

      var response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final sneaker = sneakersFromJsonById(response.body);
        return sneaker;
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception(
            "Failed to get female sneakers by ID with status code: ${response.statusCode}");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getFemaleSneakersById: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in getFemaleSneakersById: $e");
      throw Exception("An error occurred: $e");
    }
  }

  // Single Kids
  Future<Sneakers> getKidsSneakersById(String id) async {
    try {
      var url = Uri.https(Config.apiUrl, "${Config.sneakers}/$id");

      var response = await client.get(url, headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final sneaker = sneakersFromJsonById(response.body);
        return sneaker;
      } else if (response.statusCode == 404) {
        throw Exception("Endpoint not found");
      } else if (response.statusCode == 500) {
        throw Exception("Internal server error");
      } else if (response.statusCode == 504) {
        throw Exception("Connection timeout");
      } else {
        throw Exception("Failed to get kids sneakers by ID");
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in getKidsSneakersById: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in getKidsSneakersById: $e");
      throw Exception("An error occurred: $e");
    }
  }

  Future<List<Sneakers>> search(String searchQuery) async {
    try {
      if (searchQuery.isNotEmpty) {
        var url = Uri.https(Config.apiUrl, "${Config.search}$searchQuery");
        var response = await client.get(url, headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
        });

        if (response.statusCode == 200) {
          final results = sneakersFromJson(response.body);
          return results;
        } else if (response.statusCode == 404) {
          throw Exception("Endpoint not found");
        } else if (response.statusCode == 500) {
          throw Exception("Internal server error");
        } else if (response.statusCode == 504) {
          throw Exception("Connection timeout");
        } else {
          throw Exception(
              "Failed to get sneakers list. Status code: ${response.statusCode}");
        }
      } else {
        // Jika searchQuery kosong, kembalikan daftar kosong atau lakukan sesuai kebutuhan
        return [];
      }
    } on TimeoutException catch (e) {
      // Handling khusus TimeoutException
      debugPrint("Timeout in search: $e");
      throw Exception("Timeout occurred: $e");
    } catch (e) {
      // Logging error
      debugPrint("Error in search: $e");
      throw Exception("An error occurred: $e");
    }
  }
}
