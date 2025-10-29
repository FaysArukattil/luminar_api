import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:luminar_api/models/productsall/resp_productsall.dart';
import 'package:luminar_api/models/user.dart';
import 'package:luminar_api/services/userservice.dart';

class Apiservice {
  final String baseurl = "https://freeapi.luminartechnohub.com";
  final logger = Logger();

  UserService userService = UserService();

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

  Future<bool> addproducts({
    required String name,
    required String description,
    required String price,
    required String stock,
    required String category,
    File? image,
  }) async {
    Uri url = Uri.parse("$baseurl/product-create/");

    var headers = {
      "accept": "application/json",
      "Authorization": "Bearer ${await UserService.getAccessToken()}",
    };

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;
    request.fields['stock'] = stock;
    request.fields['category'] = category;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          filename: image.path.split("/").last,
        ),
      );
    }

    logger.i("URL: $url");
    logger.i("Headers: $headers");
    logger.i("Fields: ${request.fields}");

    try {
      var streamresponse = await request.send();
      logger.i("Status Code: ${streamresponse.statusCode}");

      if (streamresponse.statusCode >= 200 &&
          streamresponse.statusCode <= 299) {
        var resp = await http.Response.fromStream(streamresponse);
        logger.i("Response: ${resp.body}");

        return true;
      } else {
        var resp = await http.Response.fromStream(streamresponse);
        logger.e("Error Response: ${resp.body}");
        return false;
      }
    } catch (e) {
      logger.e("E:::::::$e");
      return false;
    }
  }

  Future<List<Data>?> myproducts(String token) async {
    Uri url = Uri.parse("$baseurl/my-products/");
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
