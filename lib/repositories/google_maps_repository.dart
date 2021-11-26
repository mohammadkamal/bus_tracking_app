import 'package:bus_tracking_app/models/place_prediction.dart';

abstract class GoogleMapsRepository{
  Stream<PlacePrediction> fetchPlacesPredictions(String entry);
}