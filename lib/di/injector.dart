import 'package:bus_tracking_app/repositories/google_maps_repository.dart';
import 'package:bus_tracking_app/repositories/google_maps_repository_implementation.dart';

class Injector {
  static final _singleton = Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  GoogleMapsRepository get googleMapsRepository {
    return GoogleMapsRepositoryImplementation();
  }
}
