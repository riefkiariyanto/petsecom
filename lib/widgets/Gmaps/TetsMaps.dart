import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../Constants/constants.dart';
import '../../Controllers/MapsController.dart';

class TestMaps extends StatefulWidget {
  const TestMaps({Key? key}) : super(key: key);

  @override
  State<TestMaps> createState() => _TestMapsState();
}

class _TestMapsState extends State<TestMaps> {
  var controller = Get.put(MapsController());

  GoogleMapController? _controller;
  LatLng? _userLocation;
  List<Map<String, dynamic>> storeData = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchStoreData();
  }

  Future<void> _fetchStoreData() async {
    final UrlStore = '${url}get-biodata-client';

    try {
      final http.Response response = await http.get(Uri.parse(UrlStore));
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        setState(() {
          storeData = (decodedResponse['data'] as List<dynamic>).map((store) {
            return {
              'id': store['id'],
              'name': store['store_name'],
              'location': LatLng(
                double.parse(store['latitude'].toString()),
                double.parse(store['longitude'].toString()),
              ),
              'logo': store['logo'], // Add the logo information
            };
          }).toList();
        });
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Failed to get user location: $e');
    }
  }

  void _navigateToStoreLocation(LatLng location) {
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16.0),
      );
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const int radiusOfEarth = 6371; // Earth's radius in kilometers
    double lat1 = start.latitude * pi / 180.0;
    double lon1 = start.longitude * pi / 180.0;
    double lat2 = end.latitude * pi / 180.0;
    double lon2 = end.longitude * pi / 180.0;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarth * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        toolbarHeight: 45,
        bottomOpacity: 0.0,
        elevation: 1.0,
        shape: RoundedRectangleBorder(),
        title: Text(
          "Maps",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.brown[50],
          ),
        ),
        centerTitle: true,
      ),
      body: _userLocation == null || storeData.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 470,
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          setState(() {
                            _controller = controller;
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: _userLocation!,
                          zoom: 14.0,
                        ),
                        markers: Set<Marker>.of([
                          Marker(
                            markerId: MarkerId("user_location"),
                            position: _userLocation!,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure),
                            infoWindow: InfoWindow(
                              title: 'Your Location',
                              snippet: controller.address.value,
                            ),
                          ),
                          for (var store in storeData)
                            Marker(
                              markerId: MarkerId(store['id'].toString()),
                              position: store['location'],
                              infoWindow: InfoWindow(
                                  title: store['name'],
                                  snippet:
                                      'Distance: ${_calculateDistance(_userLocation!, store['location']).toStringAsFixed(2)} km'),
                            ),
                        ]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: storeData == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            height: 150,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: storeData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    _navigateToStoreLocation(
                                        storeData[index]['location']);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: _buildStoreBox(storeData[index]),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildStoreBox(dynamic store) {
    return GestureDetector(
      onTap: () {
        _navigateToStoreLocation(store['location']);
        _controller?.showMarkerInfoWindow(MarkerId(store['id'].toString()));
      },
      child: Container(
        height: 20,
        width: 80,
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "${urlImage}storage/${store['logo']}",
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(2),
                child: Text(
                  store['name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  '${_calculateDistance(_userLocation!, store['location']).toStringAsFixed(2)} km',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
