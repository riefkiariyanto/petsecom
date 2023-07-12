import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps_Page extends StatefulWidget {
  const Maps_Page({super.key});

  @override
  State<Maps_Page> createState() => _Maps_PageState();
}

class _Maps_PageState extends State<Maps_Page> {
  late GoogleMapController mapController;
  final LatLng initialPosition = LatLng(37.42796133580664, -122.085749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId('marker_1'),
            position: initialPosition,
            infoWindow: InfoWindow(
              title: 'Marker 1',
              snippet: 'This is the first marker',
            ),
          ),
        },
      ),
    );
  }
}
