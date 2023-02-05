import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webscaletech_task/screens/upcoming_launches.dart';
import 'package:webscaletech_task/screens/watch_later.dart';
import 'package:webscaletech_task/models/launch_data.dart';

import '../utils/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getLaunchData();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  List<LaunchData> upcomingLaunches = [];

  void getLaunchData() async {
    final response = await Dio().get(url);
    print(response.data.length);
    // print(response.data[0]["mission_name"]);
    for (int i = 0; i < response.data.length; i++) {
      print(response.data[i]["mission_name"]);
      LaunchData launchData = LaunchData.fromJson(response.data[i]);
      print(launchData.missionName);
      upcomingLaunches.add(launchData);
    }

    setState(() {
      print("Fetched ${upcomingLaunches.length} launches!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpaceX Upcoming Launches"),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: <Widget>[
          UpcomingLaunches(upcomingLaunches: upcomingLaunches),
          const WatchLaterLaunches(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.purpleAccent,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: const Text(
              'All',
            ),
            icon: const Icon(
              Icons.home,
            ),
            activeColor: Colors.white,
            inactiveColor: Colors.white54,
          ),
          BottomNavyBarItem(
            title: const Text(
              'Watch Later',
            ),
            icon: const Icon(
              Icons.watch_later_outlined,
            ),
            activeColor: Colors.white,
            inactiveColor: Colors.white54,
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
