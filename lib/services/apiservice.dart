import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:luminar_api/models/user.dart';

class Apiservice {
  final String baseurl = "https://freeapi.luminartechnohub.com";
  final logger = Logger();

  Future<User?> login({required String email, required String password}) async {
    Uri url = Uri.parse("$baseurl/login");
    try {
      var headers = {
        "accept": "application/json",
        "Content-Type": "application/json",
      };
      var body = jsonEncode({"email": "$email", "password": "$password"});

      logger.i("$baseurl/login");
      logger.i("headers::$headers");
      logger.i("body:$body");

      final response = await http.post(url, headers: headers, body: body);
      logger.w("${response.body}");
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var user = await User.fromJson(json);
        return user;
      }
    } catch (e) {
      logger.e("E:::::::$e");
    }
  }
}
