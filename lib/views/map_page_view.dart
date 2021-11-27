import 'package:bus_tracking_app/models/location_coordinates.dart';
import 'package:bus_tracking_app/presenters/map_page_presenter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPageView extends StatefulWidget {
  final LocationCoordinates? startLocation;
  final LocationCoordinates? endLocation;
  final String? startPlaceId;
  final String? endPlaceId;
  const MapPageView(
      {Key? key,
      this.startLocation,
      this.endLocation,
      this.startPlaceId,
      this.endPlaceId})
      : super(key: key);

  @override
  _MapPageViewState createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  MapPagePresenter? mapPagePresenter;
  @override
  void initState() {
    mapPagePresenter = MapPagePresenter(
        startLatLng: widget.startLocation,
        endLatLng: widget.endLocation,
        startPlaceId: widget.startPlaceId,
        endPlaceId: widget.endPlaceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ChangeNotifierProvider.value(
          value: mapPagePresenter,
          builder: (_, __) {
            return Selector<MapPagePresenter, bool>(
              selector: (_, presenter) => presenter.isLoading,
              builder: (_, isLoading, __) {
                if (isLoading) {
                  return Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                } else {
                  return Consumer<MapPagePresenter>(
                      builder: (_, presenter, __) {
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.startLocation!.lat!,
                            widget.startLocation!.lng!),
                        zoom: 14.4746,
                      ),
                      markers: presenter.markers,
                      polylines: presenter.polylines,
                      onMapCreated: (controller) {
                        presenter.controller.complete(controller);
                      },
                    );
                  });
                }
              },
            );
          },
        ));
  }
}
