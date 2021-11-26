import 'package:bus_tracking_app/di/injector.dart';
import 'package:bus_tracking_app/models/place_prediction.dart';
import 'package:flutter/foundation.dart';

class PlannerTabPresenter extends ChangeNotifier {
  final List<PlacePrediction> placePredictionsDestination = [];

  final Injector _di = Injector();

  PlacePrediction? currentDestination;
  PlacePrediction? currentSource;

  void fetchPlacePredictionsDestination(String searchEntry) {
    _di.googleMapsRepository
        .fetchPlacesPredictions(searchEntry)
        .listen((prediction) {
      placePredictionsDestination.add(prediction);
    }).onDone(notifyListeners);
  }
}
