import 'dart:async';
import 'dart:math';

import 'package:bus_tracking_app/di/injector.dart';
import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPagePresenter extends ChangeNotifier {
  MapPagePresenter({
    LiveBusTrip? liveBusTrip,
  }) {
    markers.add(Marker(
        position: LatLng(
            liveBusTrip!.startLocation!.lat!, liveBusTrip.startLocation!.lng!),
        markerId: MarkerId(
            '(${liveBusTrip.startLocation!.lat!}, ${liveBusTrip.startLocation!.lng!})')));

    markers.add(Marker(
        position: LatLng(
            liveBusTrip.endLocation!.lat!, liveBusTrip.endLocation!.lng!),
        markerId: MarkerId(
            '(${liveBusTrip.endLocation!.lat!}, ${liveBusTrip.endLocation!.lng!})')));

    fetchPolylines(liveBusTrip.startPlaceId!, liveBusTrip.endPlaceId!);
    getImageFuture().then((value) {
      markers.add(Marker(
          icon: value,
          markerId: const MarkerId('car'),
          position: LatLng(liveBusTrip.startLocation!.lat!,
              liveBusTrip.startLocation!.lng!)));
    });
  }

  final Injector _di = Injector();

  final Completer<GoogleMapController> controller = Completer();
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  bool isLoading = true;
  bool arrived = false;
  int polylineIdCounter = 0;
  int polyIndex = 0;

  Future<BitmapDescriptor> getImageFuture() async {
    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size.fromHeight(50)),
        'assets/car_icon_for_map.png');
  }

  void fetchPolylines(String startPlaceId, String endPlaceId) {
    _di.busTripsRepository
        .fetchPolylineRoute(startPlaceId, endPlaceId)
        .listen((event) {
      polylines.add(Polyline(
          width: 5,
          color: Colors.green,
          points: [
            LatLng(event.startLocation!.lat!, event.startLocation!.lng!),
            LatLng(event.endLocation!.lat!, event.endLocation!.lng!)
          ],
          polylineId: PolylineId('p${polylineIdCounter++}')));
    }).onDone(() {
      isLoading = !isLoading;
      notifyListeners();
    });
  }

  Stream mockCarRoute() {
    return Stream.fromFuture(
        Future.delayed(Duration(seconds: Random().nextInt(8)), () {
      if (markers.last.position != polylines.last.points.first && !arrived) {
        Marker temp = markers.last.copyWith(
            positionParam: LatLng(
                polylines.elementAt(polyIndex++).points.first.latitude,
                polylines.elementAt(polyIndex++).points.first.longitude));
        markers.remove(markers.last);
        markers.add(temp);
      }
      if (markers.last.position == polylines.last.points.first && !arrived) {
        Marker temp = markers.last.copyWith(
            positionParam: LatLng(
                polylines.elementAt(polyIndex++).points.last.latitude,
                polylines.elementAt(polyIndex++).points.last.longitude));
        markers.remove(markers.last);
        markers.add(temp);
        arrived = true;
      }
      notifyListeners();
    }));
  }
}
