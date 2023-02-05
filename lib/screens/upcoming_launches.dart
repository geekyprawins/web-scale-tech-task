import 'package:flutter/material.dart';

import 'package:webscaletech_task/models/launch_data.dart';
import 'package:webscaletech_task/services/firebase_service.dart';

import '../utils/constants.dart';
import '../widgets/launchdata_tile.dart';

class UpcomingLaunches extends StatelessWidget {
  const UpcomingLaunches({
    super.key,
    required this.upcomingLaunches,
  });

  final List<LaunchData> upcomingLaunches;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (upcomingLaunches.isEmpty)
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  final LaunchData launchData = upcomingLaunches[index];

                  return LaunchDataTile(launchData: launchData, index: index);
                },
                itemCount: upcomingLaunches.length,
              ),
            ),
    );
  }
}
