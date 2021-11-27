import 'package:bus_tracking_app/presenters/planner_tab_presenter.dart';
import 'package:bus_tracking_app/views/map_page_view.dart';
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormField(
                  controller: _plannerTabPresenter.sourceTextController,
                  onChanged: (text) {},
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.my_location),
                  ),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    controller: _plannerTabPresenter.destinationTextController,
                    onFieldSubmitted: (entry) => _plannerTabPresenter
                        .fetchPlacePredictionsDestination(entry,
                            onComplete: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapPageView()));
                    }),
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.near_me_outlined)),
                  ))
            ],
          ),
          const IconButton(
              onPressed: null, icon: Icon(CupertinoIcons.arrow_2_squarepath))
        ]));
  }
}

class _PlacePredictionsDropDown extends StatefulWidget {
  @override
  _PlacePredictionsDropDownState createState() =>
      _PlacePredictionsDropDownState();
}

class _PlacePredictionsDropDownState extends State<_PlacePredictionsDropDown> {
  final PlannerTabPresenter _plannerTabPresenter;

  _PlacePredictionsDropDownState()
      : _plannerTabPresenter = PlannerTabPresenter();

  @override
  void initState() {
    _plannerTabPresenter.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.width * 0.5,
      child: ListView.builder(
        itemCount: _plannerTabPresenter.placePredictionsDestination.length,
        itemBuilder: (_, index) => Text(
          _plannerTabPresenter.placePredictionsDestination[index].description!,
          overflow: TextOverflow.ellipsis,
        ),
        shrinkWrap: true,
      ),
    );
  }
}
