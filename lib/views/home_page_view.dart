import 'package:bus_tracking_app/presenters/home_page_presenter.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  final HomePresenter _homePresenter;

  _HomePageViewState() : _homePresenter = HomePresenter();

  @override
  void initState() {
    _homePresenter.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homePresenter.homeTabs.elementAt(_homePresenter.currentTabIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _homePresenter.currentTabIndex,
        onTap: (index) => setState(() {
          _homePresenter.onTapChange(index);
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.map,
                color: Colors.black,
              ),
              label: 'Map'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.black,
              ),
              icon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey,
              ),
              label: 'Planner'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.warning_amber,
                color: Colors.grey,
              ),
              activeIcon: Icon(
                Icons.warning_amber,
                color: Colors.black,
              ),
              label: 'Warning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet_giftcard_outlined, color: Colors.grey),
              activeIcon: Icon(
                Icons.wallet_giftcard_outlined,
                color: Colors.black,
              ),
              label: 'Promotion')
        ],
      ),
    );
  }
}

class EmptyContainer extends StatelessWidget {
  final int? tabNumber;

  const EmptyContainer({Key? key, this.tabNumber}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text('Tab #$tabNumber'),
    );
  }
}
