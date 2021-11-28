import 'package:bus_tracking_app/enums/location_type.dart';
import 'package:bus_tracking_app/models/live_bus_trip.dart';
import 'package:bus_tracking_app/models/place_prediction.dart';
import 'package:bus_tracking_app/presenters/planner_tab_presenter.dart';
import 'package:bus_tracking_app/views/map_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlannerTabView extends StatelessWidget {
  const PlannerTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlannerTabPresenter(),
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your trip planner'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [_SourceDestinationForm(), const SavedRoutes()],
            ),
          ),
        );
      },
    );
  }
}

class _SourceDestinationForm extends StatefulWidget {
  @override
  _SourceDestinationFormState createState() => _SourceDestinationFormState();
}

class _SourceDestinationFormState extends State<_SourceDestinationForm> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlannerTabPresenter>(builder: (_, presenter, __) {
      return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(12)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    controller: presenter.sourceTextController,
                    onTap: () {
                      presenter.sourceTextController.clear();
                      presenter.placePredictionsSource.clear();
                      presenter.placePredictionsSource.add(PlacePrediction(
                          description: 'My current location',
                          structuredFormatting: StructuredFormatting(
                              mainText: 'My current location',
                              secondaryText: 'My current location')));
                    },
                    onFieldSubmitted: (entry) {
                      presenter.fetchPlacePredictions(
                          entry, LocationType.source, onComplete: () {
                        showBottomSheet(
                            context: context,
                            builder: (_) {
                              return _PlacePredictionsDropDown(
                                locationType: LocationType.source,
                                presenter: presenter,
                              );
                            });
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.my_location),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          controller: presenter.destinationTextController,
                          onTap: () {
                            presenter.placePredictionsDestination.clear();
                          },
                          onFieldSubmitted: (entry) => presenter
                              .fetchPlacePredictions(
                                  entry, LocationType.destination,
                                  onComplete: () {
                            showBottomSheet(
                                context: context,
                                builder: (_) {
                                  return _PlacePredictionsDropDown(
                                    locationType: LocationType.destination,
                                    presenter: presenter,
                                  );
                                });
                          }),
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.near_me_outlined)),
                        ))
                  ],
                )
              ],
            ),
            IconButton(
                onPressed: presenter.onSwitchTap,
                icon: const Icon(CupertinoIcons.arrow_2_squarepath)),
          ]));
    });
  }
}

class _PlacePredictionsDropDown extends StatefulWidget {
  final PlannerTabPresenter presenter;
  final LocationType locationType;

  const _PlacePredictionsDropDown(
      {Key? key, required this.presenter, required this.locationType})
      : super(key: key);
  @override
  _PlacePredictionsDropDownState createState() =>
      _PlacePredictionsDropDownState();
}

class _PlacePredictionsDropDownState extends State<_PlacePredictionsDropDown> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.presenter,
      builder: (_, __) {
        return Consumer<PlannerTabPresenter>(builder: (_, presenter, __) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: ListView.builder(
              itemCount: widget.locationType == LocationType.destination
                  ? presenter.placePredictionsDestination.length
                  : presenter.placePredictionsSource.length,
              itemBuilder: (_, index) => InkWell(
                onTap: () => presenter
                    .onPredictionSelected(index, widget.locationType, then: () {
                  Navigator.of(context).pop();
                }),
                child: Text(
                  widget.locationType == LocationType.destination
                      ? presenter
                          .placePredictionsDestination[index].description!
                      : presenter.placePredictionsSource[index].description!,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              shrinkWrap: true,
            ),
          );
        });
      },
    );
  }
}

class SavedRoutes extends StatefulWidget {
  const SavedRoutes({Key? key}) : super(key: key);

  @override
  _SavedRoutesState createState() => _SavedRoutesState();
}

class _SavedRoutesState extends State<SavedRoutes> {
  @override
  Widget build(BuildContext context) {
    return Selector<PlannerTabPresenter, bool>(
        selector: (_, presenter) => presenter.savedRoutes.isNotEmpty,
        builder: (_, isSavedNotEmpty, __) {
          if (isSavedNotEmpty) {
            return Consumer<PlannerTabPresenter>(builder: (_, presenter, __) {
              return ListView.builder(
                itemCount: presenter.savedRoutes.length,
                itemBuilder: (_, index) {
                  return _SavedRouteItem(
                    liveBusTrip: presenter.savedRoutes.elementAt(index),
                  );
                },
                shrinkWrap: true,
              );
            });
          } else {
            return Container();
          }
        });
  }
}

class _SavedRouteItem extends StatelessWidget {
  final LiveBusTrip? liveBusTrip;

  const _SavedRouteItem({Key? key, this.liveBusTrip}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MapPageView(
                    liveBusTrip: liveBusTrip,
                  )));
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, top: 8, right: 20, bottom: 8),
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.car_rental),
                      Container(
                        child: const Text(
                          '1680-MR',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: const EdgeInsets.only(
                            left: 8, top: 3, right: 8, bottom: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[400]),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.directions),
                      Text(liveBusTrip!.startPlaceName!)
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer),
                      Text('Trip taken on ${liveBusTrip!.tripStartTime!.month}'
                          '/${liveBusTrip!.tripStartTime!.day}'
                          '/${liveBusTrip!.tripStartTime!.year}')
                    ],
                  )
                ],
              ),
              Column(
                children: const [
                  Text(
                    '26 km',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('From you')
                ],
              )
            ],
          ),
        ));
  }
}
