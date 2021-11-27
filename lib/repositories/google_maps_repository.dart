import 'package:bus_tracking_app/models/location_coordinates.dart';
import 'package:bus_tracking_app/models/place_prediction.dart';

abstract class GoogleMapsRepository{
  Stream<PlacePrediction> fetchPlacesPredictions(String entry);
  Stream<LocationCoordinates> fetchPlaceDetails(String placeId);
}