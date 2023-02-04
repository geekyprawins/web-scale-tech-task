import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webscaletech_task/models/launch_data.dart';

class FirebaseService{


  static void addLaunchDataToCollection(LaunchData launchData) async {
    var launchDataCollection = FirebaseFirestore.instance.collection("launches");
    await launchDataCollection.add(launchData.toJson()).then((value) => print("Added to Firestore!"));
  }


}