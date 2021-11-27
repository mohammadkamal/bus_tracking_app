import 'package:bus_tracking_app/views/home_page_view.dart';
import 'package:bus_tracking_app/views/planner_tab_view.dart';
import 'package:flutter/foundation.dart';

class HomePresenter extends ChangeNotifier {
  int currentTabIndex = 0;

  final homeTabs = [
    const EmptyContainer(
      tabNumber: 0,
    ),
    const PlannerTabView(),
    const EmptyContainer(
      tabNumber: 2,
    ),
    const EmptyContainer(
      tabNumber: 3,
    )
  ];

  void onTapChange(int newIndex) {
    currentTabIndex = newIndex;
    notifyListeners();
  }
}
