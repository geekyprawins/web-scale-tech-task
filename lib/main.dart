import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:webscaletech_task/models/launch_data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  void initState() {
    super.initState();
    getLaunchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpaceX"),
      ),
      body: Center(
        child:
        (upcmngLaunches.isEmpty) ?
        CircularProgressIndicator() :
        ListView.builder(itemBuilder: (context, index) {
          final String name = upcmngLaunches[index].missionName;
          final String flightNo = upcmngLaunches[index].flightNumber.toString();
          return ListTile(title: Text(name),
            subtitle: Text(flightNo),);
        },
        itemCount: upcmngLaunches.length,
        )

        // FutureBuilder(
        //   builder: (BuildContext context, AsyncSnapshot<List<LaunchData>> snapshot) {
        //   return ListView.builder(itemBuilder: (context, index) {
        //     final String name = snapshot.data![index].missionName;
        //     final String flightNo = snapshot.data![index].flightNumber.toString();
        //     return ListTile(title: Text(name),
        //       subtitle: Text(flightNo),);
        //   },);
        // },
        //   future: getLaunchData(),
        // ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
