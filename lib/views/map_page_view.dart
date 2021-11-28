import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:bus_tracking_app/presenters/map_page_presenter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPageView extends StatefulWidget {
  final LiveBusTrip? liveBusTrip;
  const MapPageView({Key? key, this.liveBusTrip}) : super(key: key);

  @override
  _MapPageViewState createState() => _MapPageViewState();
}

class _MapPageViewState extends State<MapPageView> {
  MapPagePresenter? mapPagePresenter;
  @override
  void initState() {
    mapPagePresenter = MapPagePresenter(
      liveBusTrip: widget.liveBusTrip,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: mapPagePresenter,
        builder: (_, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('BMTC'),
              centerTitle: true,
              actions: const [Icon(Icons.person)],
            ),
            body: Selector<MapPagePresenter, bool>(
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
                    return StreamBuilder(
                      builder: (_, snapshot) {
                        return GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                widget.liveBusTrip!.startLocation!.lat!,
                                widget.liveBusTrip!.startLocation!.lng!),
                            zoom: 14.4746,
                          ),
                          markers: presenter.markers,
                          polylines: presenter.polylines,
                          onMapCreated: (controller) {
                            presenter.controller.complete(controller);
                          },
                        );
                      },
                      stream: presenter.mockCarRoute(),
                    );
                  });
                }
              },
            ),
            bottomSheet: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]),
              child: Selector<MapPagePresenter, bool>(
                selector: (_, presenter) => presenter.arrived,
                builder: (_, arrived, __) {
                  if (arrived) {
                    return Container(
                        alignment: Alignment.center,
                        child: const Text('You have arrived'));
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        _TripDetails(
                          startDate: widget.liveBusTrip!.tripStartTime!,
                          endDate: widget.liveBusTrip!.tripEndTime!,
                        ),
                        _FromDetails(
                          startDate: widget.liveBusTrip!.tripStartTime!,
                          tripSource: widget.liveBusTrip!.startPlaceName,
                        ),
                        _ToDetails(
                          endDate: widget.liveBusTrip!.tripEndTime!,
                          tripDestination: widget.liveBusTrip!.endPlaceName,
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}

class _TripDetails extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const _TripDetails({Key? key, required this.startDate, required this.endDate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Distance'),
            const Text('26 km'),
            Text('Trip taken on ${startDate.month}'
                '/${startDate.day}'
                '/${startDate.year}')
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                const Text('Travel Time: '),
                Text(
                    endDate.difference(startDate).inMinutes.toString() + ' min')
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.watch),
                    Text('${startDate.hour}:${startDate.minute}')
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.watch),
                    Text('${endDate.hour}:${endDate.minute}')
                  ],
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class _FromDetails extends StatelessWidget {
  final DateTime startDate;
  final String? tripSource;

  const _FromDetails({Key? key, required this.startDate, this.tripSource})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.arrow_upward),
        Column(
          children: [
            Text(
              'From ${tripSource ?? '...'}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(monthDigitToString(startDate.month) +
                ' ${startDate.day}, ${startDate.hour}:${startDate.minute}')
          ],
        ),
        OutlinedButton(
            onPressed: null,
            child: Row(
              children: [
                const Icon(Icons.alarm),
                Text('Set Alarm'.toUpperCase())
              ],
            ))
      ],
    );
  }
}

class _ToDetails extends StatelessWidget {
  final DateTime endDate;
  final String? tripDestination;

  const _ToDetails({Key? key, required this.endDate, this.tripDestination})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.arrow_downward),
        Column(
          children: [
            Text(
              'To ${tripDestination ?? '...'}',
              overflow: TextOverflow.ellipsis,
            ),
            Text(monthDigitToString(endDate.month) +
                ' ${endDate.day}, ${endDate.hour}:${endDate.minute}')
          ],
        ),
        OutlinedButton(
            onPressed: null,
            child: Row(
              children: [
                const Icon(Icons.payment),
                Text('Pay online'.toUpperCase())
              ],
            ))
      ],
    );
  }
}

String monthDigitToString(int digit) {
  switch (digit) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return 'Error';
  }
}
