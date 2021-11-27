import 'dart:convert';
import 'dart:developer';

import 'package:bus_tracking_app/api_end_points.dart';
import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:bus_tracking_app/models/polyline_route.dart';
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

  @override
  Stream<PolylineRoute> fetchPolylineRoute(
      String startPlaceId, String endPlaceId) {
    return Stream.fromFuture(http.get(Uri.parse(ApiEndPoints.mockServer +
            '/polyline' +
            '?start_place_id=' +
            startPlaceId +
            '&end_place_id=' +
            endPlaceId)))
        .flatMap((response) {
      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);
        return _getPolylineRoutesFromList(resBody);
      } else {
        throw Exception(
            'Failed to get polyline routes, error code: ${response.statusCode}');
      }
    });
  }

  Stream<PolylineRoute> _getPolylineRoutesFromList(List polylineRoutes) async* {
    for (var polyline in polylineRoutes) {
      yield PolylineRoute.fromMap(polyline);
    }
  }
}
