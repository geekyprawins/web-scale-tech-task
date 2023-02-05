import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webscaletech_task/models/launch_data.dart';

class FirebaseService {

  static void addLaunchDataToCollection(LaunchData launchData) async {
    var launchDataCollection =
        FirebaseFirestore.instance.collection("launches");
    await launchDataCollection.doc(launchData.missionName)
        .set(launchData.toJson())
        .then((value) => print("Added to Firestore!"));
  }

  static Future<List<LaunchData>> getWatchLaterLaunches() async {
    List<LaunchData> watchLaterData = [];
    var launchDataCollection =
        FirebaseFirestore.instance.collection("launches");
    await launchDataCollection.get().then((querySnapshots) {
      for (var qs in querySnapshots.docs) {
        LaunchData launchData = LaunchData.fromJson(qs.data());
        print("Fetched watch later: ${launchData.missionName}");
        watchLaterData.add(launchData);
      }
    });
    return watchLaterData.toList();
  }

  static Stream<QuerySnapshot> getWatchLaterStream()  {
    final Stream<QuerySnapshot> wlStream = FirebaseFirestore.instance.collection('launches').snapshots();
    return wlStream;
  }

  static void deleteFromWatchLater(LaunchData ld)  {
    var launchDataCollection =
    FirebaseFirestore.instance.collection("launches");
    launchDataCollection.doc(ld.missionName).delete();
  }
}
