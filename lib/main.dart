import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webscaletech_task/models/launch_data.dart';
import 'package:webscaletech_task/services/firebase_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseService.getWatchLaterLaunches();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX Launches',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

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

  List<LaunchData> upcmngLaunches = [];

  void getLaunchData() async {
    final response =
        await Dio().get("https://api.spacexdata.com/v3/launches/upcoming");
    print(response.data.length);
    // print(response.data[0]["mission_name"]);
    for (int i = 0; i < response.data.length; i++) {
      print(response.data[i]["mission_name"]);
      LaunchData launchData = LaunchData.fromJson(response.data[i]);
      print(launchData.missionName);
      upcmngLaunches.add(launchData);
    }

    setState(() {
      print("Fetched ${upcmngLaunches.length} launches!");
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
          UpcomingLaunches(upcmngLaunches: upcmngLaunches),
          WatchLaterLaunches(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('All'), icon: Icon(Icons.home)),
          BottomNavyBarItem(
              title: Text('Watch Later'),
              icon: Icon(Icons.watch_later_outlined)),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class UpcomingLaunches extends StatelessWidget {
  const UpcomingLaunches({
    super.key,
    required this.upcmngLaunches,
  });

  final List<LaunchData> upcmngLaunches;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (upcmngLaunches.isEmpty)
          ? const CircularProgressIndicator()
          : ListView.builder(
              itemBuilder: (context, index) {
                final LaunchData launchData = upcmngLaunches[index];
                final String missionName = launchData.missionName;
                final String flightNo = launchData.flightNumber.toString();
                return Material(
                  elevation: 1.5,
                  color: Colors.tealAccent,
                  child: ListTile(
                    title: Text(missionName),
                    subtitle: Text(flightNo),
                    leading: Text(launchData.rocket.rocketName),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Add to watch later?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () {
                                    FirebaseService.addLaunchDataToCollection(
                                      launchData,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Added to Watch Later"),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.watch_later_outlined),
                    ),
                  ),
                );
              },
              itemCount: upcmngLaunches.length,
            ),
    );
  }
}

class WatchLaterLaunches extends StatefulWidget {
  const WatchLaterLaunches({Key? key}) : super(key: key);

  @override
  State<WatchLaterLaunches> createState() => _WatchLaterLaunchesState();
}

class _WatchLaterLaunchesState extends State<WatchLaterLaunches> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService.getWatchLaterStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            final wlData = LaunchData.fromJson(data);
            return ListTile(
              title: Text(wlData.missionName),
              subtitle: Text(wlData.flightNumber.toString()),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Remove from watch later?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              FirebaseService.deleteFromWatchLater(wlData);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Removed from Watch Later"),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
