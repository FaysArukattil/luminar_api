import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:luminar_api/models/productsall/resp_productsall.dart';
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
      var body = jsonEncode({"email": email, "password": password});

      logger.i("$baseurl/login");
      logger.i("headers::$headers");
      logger.i("body:$body");

      final response = await http.post(url, headers: headers, body: body);
      logger.w(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // Check if response has a 'data' field, otherwise use the json directly
        var userData = json['data'] ?? json;
        var user = User.fromJson(userData);
        return user;
      }
    } catch (e) {
      logger.e("E:::::::$e");
    }
    return null;
  }

  Future<bool?> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String pincode,
    required String place,
  }) async {
    Uri url = Uri.parse("$baseurl/registration/");
    var headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
    };
    var body = jsonEncode({
      "name": name,
      "phone": phone,
      "place": place,
      "pincode": pincode,
      "email": email,
      "password": password,
    });
    logger.i("$baseurl/registration/");
    logger.i("hedders::$headers");
    logger.i("body::$body");
    try {
      final response = await http.post(url, headers: headers, body: body);
      logger.i(response.body);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      logger.e("$e");
      return false;
    }
  }

  Future<List<Data>?> getproducts(String token) async {
    Uri url = Uri.parse("$baseurl/products-all/");
    var headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    logger.i("headers::$headers");
    logger.i("url::$baseurl");
    try {
      final response = await http.get(url, headers: headers);
      logger.i(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var resp = RespProductsall.fromJson(json);
        logger.i("Products Fetched Successfully");

        return resp.data;
      }
    } catch (e) {
      logger.e("E:::::::$e");
    }
    return null;
  }
}
