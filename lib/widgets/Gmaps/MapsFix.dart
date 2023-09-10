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
                  height: 500,
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
                Container(
                  alignment: Alignment.bottomCenter,
                  child: storeData == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: double.infinity,
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: storeData!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: _buildStoreBox(storeData![index]),
                              );
                            },
                          ),
                        ),
                )
              ],
            ),
    );
  }

  Widget _buildStoreBox(dynamic store) {
    return Container(
      width: 160, // Adjust the width as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(3, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "${urlImage}storage/${store['logo']}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            store['store_name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Icon(Icons.location_on),
              Text(
                store['address'],
                style: TextStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
