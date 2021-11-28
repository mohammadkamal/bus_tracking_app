import 'package:bus_tracking_app/di/injector.dart';
import 'package:bus_tracking_app/enums/location_type.dart';
import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:bus_tracking_app/models/place_prediction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlannerTabPresenter extends ChangeNotifier {
  final List<PlacePrediction> placePredictionsDestination = [];
  final List<PlacePrediction> placePredictionsSource = [];
  final List<LiveBusTrip> savedRoutes = [];

  final Injector _di = Injector();

  PlacePrediction? currentDestination;
  PlacePrediction? currentSource;

  final TextEditingController sourceTextController =
      TextEditingController(text: 'Your Current Location');
  final TextEditingController destinationTextController =
      TextEditingController();

  void fetchPlacePredictions(String searchEntry, LocationType locationType,
      {VoidCallback? onComplete}) {
    _di.googleMapsRepository
        .fetchPlacesPredictions(searchEntry)
        .listen((prediction) {
      switch (locationType) {
        case LocationType.source:
          placePredictionsSource.add(prediction);
          break;
        case LocationType.destination:
          placePredictionsDestination.add(prediction);
          break;
      }
    }).onDone(() {
      switch (locationType) {
        case LocationType.source:
          currentSource = placePredictionsSource.first;
          break;
        case LocationType.destination:
          currentDestination = placePredictionsDestination.first;
          break;
      }
      notifyListeners();
      onComplete!();
    });
  }

  void fetchPlaceDetailsDestination(String placeId,
      {VoidCallback? onComplete}) {
    _di.googleMapsRepository
        .fetchPlaceDetails(placeId)
        .listen((event) {})
        .onDone(onComplete!);
  }

  void fetchLiveBusTrips(String source, String destination) {
    _di.busTripsRepository.fetchLiveBusTrips().listen((liveBusTrip) {
      savedRoutes.add(liveBusTrip);
    }).onDone(notifyListeners);
  }

  void onPredictionSelected(int index, LocationType locationType,
      {VoidCallback? then}) {
    switch (locationType) {
      case LocationType.source:
        currentSource = placePredictionsSource.elementAt(index);
        sourceTextController.text =
            currentSource!.structuredFormatting!.mainText!;
        break;
      case LocationType.destination:
        currentDestination = placePredictionsDestination.elementAt(index);
        destinationTextController.text =
            currentDestination!.structuredFormatting!.mainText!;
        break;
    }
    if (currentDestination != null && currentSource != null) {
      savedRoutes.clear();
      fetchLiveBusTrips(currentSource!.structuredFormatting!.mainText!,
          currentDestination!.structuredFormatting!.mainText!);
    }
    then!();
  }

  void onSwitchTap() {
    String tempText = sourceTextController.text;
    sourceTextController.text = destinationTextController.text;
    destinationTextController.text = tempText;

    PlacePrediction? tempPrediction =
        currentSource == null ? currentSource : null;
    currentSource = currentDestination;
    currentDestination = tempPrediction;
  }
}
