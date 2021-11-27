import 'dart:async';

import 'package:bus_tracking_app/models/location_coordinates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageView extends StatefulWidget {
  final LocationCoordinates? locationCoordinates;
  const MapPageView({Key? key, this.locationCoordinates}) : super(key: key);

  @override
  _MapPageViewState createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.locationCoordinates!.lat!, widget.locationCoordinates!.lng!),
          zoom: 14.4746,
        ),
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
