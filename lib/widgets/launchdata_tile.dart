import 'package:flutter/material.dart';

import '../models/launch_data.dart';
import '../services/firebase_service.dart';
import '../utils/constants.dart';

class LaunchDataTile extends StatelessWidget {
  const LaunchDataTile({
    super.key,
    required this.launchData,
    required this.index,
  });

  final LaunchData launchData;
  final int index;

  @override
  Widget build(BuildContext context) {
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
                    'Add to watch later?',
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        'Yes',
                      ),
                      onPressed: () {
                        FirebaseService.addLaunchDataToCollection(
                          launchData,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Added to Watch Later",
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
            Icons.watch_later_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
