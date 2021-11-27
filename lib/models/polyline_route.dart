import 'dart:convert';

import 'package:bus_tracking_app/models/location_coordinates.dart';

class PolylineRoute {
  LocationCoordinates? endLocation;
  LocationCoordinates? startLocation;

  PolylineRoute({this.endLocation, this.startLocation});

  PolylineRoute copyWith(
      LocationCoordinates? endLocation, LocationCoordinates? startLocation) {
    return PolylineRoute(
        endLocation: endLocation ?? this.endLocation,
        startLocation: startLocation ?? this.startLocation);
  }

  Map<String, dynamic> toMap() {
    return {'end_location': endLocation, 'start_location': startLocation}
      ..removeWhere((key, value) => value == null);
  }

  factory PolylineRoute.fromMap(Map<String, dynamic> map) {
    return PolylineRoute(
        endLocation: map['end_location'] == null
            ? null
            : LocationCoordinates.fromMap(map['end_location']),
        startLocation: map['start_location'] == null
            ? null
            : LocationCoordinates.fromMap(map['start_location']));
  }

  String toJson() => json.encode(toMap());

  factory PolylineRoute.fromJson(String source) =>
      PolylineRoute.fromMap(json.decode(source));
}
