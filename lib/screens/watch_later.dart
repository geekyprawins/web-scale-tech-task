import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:webscaletech_task/models/launch_data.dart';
import 'package:webscaletech_task/services/firebase_service.dart';

import '../utils/constants.dart';

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
          return const Text(
            'Something went wrong',
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        int index = -1;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              index++;
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              final launchData = LaunchData.fromJson(data);
              return Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                elevation: 1.5,
                color: colors[index % colors.length],
                child: ListTile(
                  title: RichText(
                    text: TextSpan(children: [
                      const TextSpan(text: "Mission Name  "),
                      TextSpan(
                        text: launchData.missionName,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.pinkAccent,
                        ),
                      )
                    ]),
                  ),
                  subtitle: RichText(
                    text: TextSpan(children: [
                      const TextSpan(text: "Flight No "),
                      TextSpan(
                        text: launchData.flightNumber.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.pinkAccent,
                        ),
                      )
                    ]),
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(launchData.rocket.rocketName),
                      const Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                      )
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Remove from watch later?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Yes',
                                ),
                                onPressed: () {
                                  FirebaseService.deleteFromWatchLater(
                                      launchData);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Removed from Watch Later",
                                      ),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'No',
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
