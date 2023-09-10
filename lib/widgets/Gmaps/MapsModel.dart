import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Constants/constants.dart';

// class StoreLocation {
//   final int id;
//   final String storeName;
//   final String address;
//   final double latitude;
//   final double longitude;

//   StoreLocation({
//     required this.id,
//     required this.storeName,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//   });
// }

// Future<List<StoreLocation>> fetchStoreLocations() async {
//   final response = await http.get(Uri.parse('${url}get-biodata-client/'));

//   if (response.statusCode == 200) {
//     final List<dynamic> data = json.decode(response.body);

//     List<StoreLocation> storeLocations = data.map((item) {
//       return StoreLocation(
//         id: item['id'] as int,
//         storeName: item['store_name'] as String,
//         address: item['address'] as String,
//         latitude: double.parse(item['latitude'] as String),
//         longitude: double.parse(item['longitude'] as String),
//       );
//     }).toList();

//     return storeLocations;
//   } else {
//     throw Exception('Failed to load store locations');
//   }
// }
