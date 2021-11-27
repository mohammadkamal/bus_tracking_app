import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:bus_tracking_app/models/polyline_route.dart';

abstract class BusTripsRepository {
  Stream<LiveBusTrip> fetchLiveBusTrips();
  Stream<PolylineRoute> fetchPolylineRoute(String startPlaceId, String endPlaceId);
}
