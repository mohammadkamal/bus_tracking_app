import 'dart:convert';

class LiveBusTrip {
  DateTime? tripStartTime;
  DateTime? tripEndTime;

  LiveBusTrip({this.tripStartTime, this.tripEndTime});

  LiveBusTrip copyWith(DateTime? tripStartTime, DateTime? tripEndTime) {
    return LiveBusTrip(
        tripStartTime: tripStartTime ?? this.tripStartTime,
        tripEndTime: tripEndTime ?? this.tripEndTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'tripStartTime':
          tripStartTime != null ? tripStartTime!.toIso8601String() : null,
      'tripEndTime': tripEndTime != null ? tripEndTime!.toIso8601String() : null
    }..removeWhere((key, value) => value == null);
  }

  factory LiveBusTrip.fromMap(Map<String, dynamic> map) {
    return LiveBusTrip(
        tripStartTime: map['tripStartTime'] == null
            ? null
            : DateTime.parse(map['tripStartTime']),
        tripEndTime: map['tripEndTime'] == null
            ? null
            : DateTime.parse(map['tripEndTime']));
  }

  String toJson() => json.encode(toMap());

  factory LiveBusTrip.fromJson(String source) =>
      LiveBusTrip.fromMap(json.decode(source));
}
