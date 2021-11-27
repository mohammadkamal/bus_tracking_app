import 'package:bus_tracking_app/di/injector.dart';
import 'package:bus_tracking_app/models/place_prediction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlannerTabPresenter extends ChangeNotifier {
  final List<PlacePrediction> placePredictionsDestination = [];

  final Injector _di = Injector();

  PlacePrediction? currentDestination;
  PlacePrediction? currentSource;

  final TextEditingController sourceTextController =
      TextEditingController(text: 'Your Current Location');
  final TextEditingController destinationTextController =
      TextEditingController();

  void fetchPlacePredictionsDestination(String searchEntry,
      {VoidCallback? onComplete}) {
    _di.googleMapsRepository
        .fetchPlacesPredictions(searchEntry)
        .listen((prediction) {
      placePredictionsDestination.add(prediction);
    }).onDone(() {
      currentDestination = placePredictionsDestination.first;
      notifyListeners();
      fetchPlaceDetailsDestination(placePredictionsDestination.first.placeId!,
          onComplete: onComplete!);
      //onComplete!();
    });
  }

  void fetchPlaceDetailsDestination(String placeId,
      {VoidCallback? onComplete}) {
    _di.googleMapsRepository.fetchPlaceDetails(placeId).listen((event) {
    });
  }
}
