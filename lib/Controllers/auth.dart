import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petsecom/Constants/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:petsecom/Views/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();

  Future register({
    required String name,
    required String username,
    required String phone,
    required String address,
    required String email,
    required String password,
    required String images,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'username': username,
        'phone': phone,
        'address': address,
        'email': email,
        'password': password,
        'images': images,
      };

      final prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse('${url}register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];

        box.write('token', token.value);
        prefs.setBool('sregister', true);
        prefs.setString('_data', response.body);
        Get.offAll(() => const HomePage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          colorText: Colors.grey[800],
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;

      print(e.toString());
    }
  }

  Future login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'username': username,
        'password': password,
      };
      final prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        prefs.setBool('slogin', true);
        prefs.setString('_data', response.body);
        Get.offAll(() => const HomePage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          colorText: Colors.grey[800],
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;

      print(e.toString());
    }
  }
}
