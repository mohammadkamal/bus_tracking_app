import 'dart:convert';
import 'dart:developer';

import 'package:bus_tracking_app/api_end_points.dart';
import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:bus_tracking_app/repositories/bus_trips_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class BusTripsRepositoryImplementation implements BusTripsRepository {
  @override
  Stream<LiveBusTrip> fetchLiveBusTrips() {
    return Stream.fromFuture(
            http.get(Uri.parse(ApiEndPoints.mockServer + '/livetrips')))
        .flatMap((response) {
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        log('fetchLiveBusTrips: $resBody');
        return _getLiveTripsFromList(resBody);
      } else {
        throw Exception('Bus trip error code: ${response.statusCode}');
      }
    });
  }

  Stream<LiveBusTrip> _getLiveTripsFromList(List liveTrips) async* {
    for (var liveBusTrip in liveTrips) {
      yield LiveBusTrip.fromMap(liveBusTrip);
    }
  }
}
