import 'package:bus_tracking_app/models/live_bus_trip.dart';

abstract class BusTripsRepository {
  Stream<LiveBusTrip> fetchLiveBusTrips();
}
