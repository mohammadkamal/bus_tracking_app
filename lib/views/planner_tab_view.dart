import 'package:bus_tracking_app/models/place_prediction.dart';
import 'package:bus_tracking_app/presenters/planner_tab_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlannerTabView extends StatelessWidget {
  const PlannerTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your trip planner'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _SourceDestinationForm(),
          ],
        ),
      ),
    );
  }
}

class _SourceDestinationForm extends StatefulWidget {
  @override
  _SourceDestinationFormState createState() => _SourceDestinationFormState();
}

class _SourceDestinationFormState extends State<_SourceDestinationForm> {
  final PlannerTabPresenter _plannerTabPresenter;

  _SourceDestinationFormState() : _plannerTabPresenter = PlannerTabPresenter();

  @override
  void initState() {
    _plannerTabPresenter.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormField(
                  onChanged: (text) {},
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.my_location),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: InputDecorator(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.near_me_outlined),
                        hintText: 'Destination'),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PlacePrediction>(
                        onChanged: (newVal){},
                        value: _plannerTabPresenter
                            .placePredictionsDestination.first,
                        items: _plannerTabPresenter.placePredictionsDestination
                            .map((e) => DropdownMenuItem<PlacePrediction>(
                                  child: SizedBox(
                                    child: Text(
                                      e.description!,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                  ),
                                  value: e,
                                ))
                            .toList(),
                      ),
                    )),
              )
              /*
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    onFieldSubmitted: (entry) =>
                        _plannerTabPresenter.fetchPlacePredictionsDestination(entry),
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.near_me_outlined)),
                  ))*/
            ],
          ),
          const IconButton(
              onPressed: null, icon: Icon(CupertinoIcons.arrow_2_squarepath))
        ]));
  }
}
