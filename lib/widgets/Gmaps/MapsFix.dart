import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../Constants/constants.dart';

class MapsFix extends StatefulWidget {
  const MapsFix({Key? key}) : super(key: key);

  @override
  State<MapsFix> createState() => _MapsFixState();
}

class _MapsFixState extends State<MapsFix> {
  GoogleMapController? _controller;
  LatLng? _userLocation;
  List<dynamic>? storeData; // Store the API data here

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchStoreData(); // Fetch store data when the widget initializes
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

  Future<void> _fetchStoreData() async {
    final UrlStore = '${url}get-biodata-client';

    try {
      final http.Response response = await http.get(Uri.parse(UrlStore));
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        setState(() {
          storeData = decodedResponse['data'];
        });
      } else {
        print("Error - Status Code: ${response.statusCode}");
        print("Error - Message: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 2.0,
        elevation: 1.0,
        title: Text(
          "Maps View",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: _userLocation == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 450,
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
                          zoom: 14.0, // Adjust the initial zoom level as needed
                        ),
                        markers: Set<Marker>.of([
                          Marker(
                            markerId: MarkerId("user_location"),
                            position: _userLocation!,
                            infoWindow: InfoWindow(
                              title: 'Your Location',
                              snippet: 'Your Address',
                            ),
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
                            padding: EdgeInsets.symmetric(vertical: 5),
                            width: double.infinity,
                            height: 250,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: storeData!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: _buildStoreBox(storeData![index]),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "${urlImage}storage/${store['logo']}",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 120,
                            child: Text(
                              store['store_name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              store['address'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.topRight,
                  child: Text('data'),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
