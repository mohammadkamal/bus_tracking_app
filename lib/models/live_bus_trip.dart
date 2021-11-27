import 'dart:convert';

import 'package:bus_tracking_app/models/location_coordinates.dart';

class LiveBusTrip {
  String? id;
  DateTime? tripStartTime;
  DateTime? tripEndTime;
  LocationCoordinates? startLocation;
  LocationCoordinates? endLocation;
  String? startPlaceId;
  String? endPlaceId;
  String? startPlaceName;
  String? endPlaceName;

  LiveBusTrip(
      {this.id,
      this.tripStartTime,
      this.tripEndTime,
      this.startLocation,
      this.endLocation,
      this.startPlaceId,
      this.endPlaceId,
      this.startPlaceName,
      this.endPlaceName});

  LiveBusTrip copyWith(
      String? id,
      DateTime? tripStartTime,
      DateTime? tripEndTime,
      LocationCoordinates? startLocation,
      LocationCoordinates? endLocation,
      String? startPlaceId,
      String? endPlaceId,
      String? startPlaceName,
      String? endPlaceName) {
    return LiveBusTrip(
        id: id ?? this.id,
        tripStartTime: tripStartTime ?? this.tripStartTime,
        tripEndTime: tripEndTime ?? this.tripEndTime,
        startLocation: startLocation ?? this.startLocation,
        endLocation: endLocation ?? this.endLocation,
        startPlaceId: startPlaceId ?? this.startPlaceId,
        endPlaceId: endPlaceId ?? this.endPlaceId,
        startPlaceName: startPlaceName ?? this.startPlaceName,
        endPlaceName: endPlaceName ?? this.endPlaceName);
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'tripStartTime':
          tripStartTime != null ? tripStartTime!.toIso8601String() : null,
      'tripEndTime':
          tripEndTime != null ? tripEndTime!.toIso8601String() : null,
      'startLocation': startLocation != null ? startLocation!.toMap() : null,
      'endLocation': endLocation != null ? endLocation!.toMap() : null,
      'startPlaceId': startPlaceId,
      'endPlaceId': endPlaceId,
      'startPlaceName': startPlaceName,
      'endPlaceName': endPlaceName
    }..removeWhere((key, value) => value == null);
  }

  factory LiveBusTrip.fromMap(Map<String, dynamic> map) {
    return LiveBusTrip(
        id: map['_id'],
        tripStartTime: map['tripStartTime'] == null
            ? null
            : DateTime.parse(map['tripStartTime']),
        tripEndTime: map['tripEndTime'] == null
            ? null
            : DateTime.parse(map['tripEndTime']),
        startLocation: map['startLocation'] == null
            ? null
            : LocationCoordinates.fromMap(map['startLocation']),
        endLocation: map['locationCoordinates'] == null
            ? null
            : LocationCoordinates.fromMap(map['locationCoordinates']),
        startPlaceId: map['startPlaceId'],
        endPlaceId: map['endPlaceId'],
        startPlaceName: map['startPlaceName'],
        endPlaceName: map['endPlaceName']);
  }

  String toJson() => json.encode(toMap());

  factory LiveBusTrip.fromJson(String source) =>
      LiveBusTrip.fromMap(json.decode(source));
}
