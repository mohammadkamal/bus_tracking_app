class LocationCoordinates {
  double? lat;
  double? lng;

  LocationCoordinates({this.lat, this.lng});

  factory LocationCoordinates.fromMap(Map<String, dynamic> map) {
    return LocationCoordinates(lat: map['lat'], lng: map['lng']);
  }
}
