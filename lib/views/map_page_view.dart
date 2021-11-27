import 'dart:async';

import 'package:bus_tracking_app/models/location_coordinates.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageView extends StatefulWidget {
  final LocationCoordinates? startLocation;
  final LocationCoordinates? endLocation;
  const MapPageView({Key? key, this.startLocation, this.endLocation})
      : super(key: key);

  @override
  _MapPageViewState createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = {};
  final List<LatLng> points = [];

  @override
  void initState() {
    markers.add(Marker(
        position:
            LatLng(widget.startLocation!.lat!, widget.startLocation!.lng!),
        markerId: MarkerId(
            '(${widget.startLocation!.lat!}, ${widget.startLocation!.lng!})')));

    markers.add(Marker(
        position: LatLng(widget.endLocation!.lat!, widget.endLocation!.lng!),
        markerId: MarkerId(
            '(${widget.endLocation!.lat!}, ${widget.endLocation!.lng!})')));

    points.add(LatLng(widget.startLocation!.lat!, widget.startLocation!.lng!));
    points.add(LatLng(widget.endLocation!.lat!, widget.endLocation!.lng!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target:
              LatLng(widget.startLocation!.lat!, widget.startLocation!.lng!),
          zoom: 14.4746,
        ),
        markers: markers,
        polylines: {Polyline(points: points, polylineId: PolylineId('p'))},
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
