import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../Constants/constants.dart';
import '../../Controllers/auth.dart';

class CartApiHelper {
  static Future<List<dynamic>> getItemCart() async {
    final urlCart = '${url}list-cart';
    final authController = Get.find<AuthController>();
    final userID = await authController.getUserID();

    try {
      http.Response response = await http.get(Uri.parse(urlCart));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> data = jsonData['data'];

        // Filter data based on user_id
        List filteredData =
            data.where((item) => item['id_user'] == userID).toList();

        return filteredData;
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
