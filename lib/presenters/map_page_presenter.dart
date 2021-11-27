import 'dart:async';
import 'dart:math';

import 'package:bus_tracking_app/di/injector.dart';
import 'package:bus_tracking_app/models/location_coordinates.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPagePresenter extends ChangeNotifier {
  MapPagePresenter(
      {LocationCoordinates? startLatLng,
      LocationCoordinates? endLatLng,
      String? startPlaceId,
      String? endPlaceId}) {
    markers.add(Marker(
        position: LatLng(startLatLng!.lat!, startLatLng.lng!),
        markerId: MarkerId('(${startLatLng.lat!}, ${startLatLng.lng!})')));

    markers.add(Marker(
        position: LatLng(endLatLng!.lat!, endLatLng.lng!),
        markerId: MarkerId('(${endLatLng.lat!}, ${endLatLng.lng!})')));
    fetchPolylines(startPlaceId!, endPlaceId!);
  }

  final Injector _di = Injector();

  final Completer<GoogleMapController> controller = Completer();
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  bool isLoading = true;
  int polylineIdCounter = 0;

  void fetchPolylines(String startPlaceId, String endPlaceId) {
    _di.busTripsRepository
        .fetchPolylineRoute(startPlaceId, endPlaceId)
        .listen((event) {
      polylines.add(Polyline(points: [
        LatLng(event.startLocation!.lat!, event.startLocation!.lng!),
        LatLng(event.endLocation!.lat!, event.endLocation!.lng!)
      ], polylineId: PolylineId('p${polylineIdCounter++}')));
    }).onDone(() {
      isLoading = !isLoading;
      notifyListeners();
    });
  }
}
