import 'dart:convert';

import 'package:bus_tracking_app/api_end_points.dart';
import 'package:bus_tracking_app/models/place_prediction.dart';
import 'package:bus_tracking_app/repositories/google_maps_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class GoogleMapsRepositoryImplementation implements GoogleMapsRepository {
  @override
  Stream<PlacePrediction> fetchPlacesPredictions(String entry) {
    return Stream.fromFuture(http.get(Uri.parse(ApiEndPoints.gooleMapsApi +
            ApiEndPoints.googlePlacesAutoComplete +
            '?input=$entry' +
            '&key=${ApiEndPoints.googlePlacesApiKey}')))
        .flatMap((response) {
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return _getPredictionsFromList(jsonBody['predictions']);
      } else {
        throw Exception('Error handling the Api');
      }
    });
  }
}

Stream<PlacePrediction> _getPredictionsFromList(List predictions) async* {
  for (var prediction in predictions) {
    yield PlacePrediction.fromMap(prediction);
  }
}
