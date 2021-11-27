import 'dart:convert';

class LocationCoordinates {
  double? lat;
  double? lng;

  LocationCoordinates({this.lat, this.lng});

  LocationCoordinates copyWith(double? lat, double? lng) {
    return LocationCoordinates(lat: lat ?? this.lat, lng: lng ?? this.lng);
  }

  Map<String, dynamic> toMap() {
    return {'lat': lat, 'lng': lng}..removeWhere((key, value) => value == null);
  }

  factory LocationCoordinates.fromMap(Map<String, dynamic> map) {
    return LocationCoordinates(lat: map['lat'], lng: map['lng']);
  }

  String toJson() => json.encode(toMap());

  factory LocationCoordinates.fromJson(String source) =>
      LocationCoordinates.fromMap(json.decode(source));
}
