// To parse this JSON data, do
//
//     final launchData = launchDataFromJson(jsonString);

import 'dart:convert';

LaunchData launchDataFromJson(String str) => LaunchData.fromJson(json.decode(str));

String launchDataToJson(LaunchData data) => json.encode(data.toJson());

class LaunchData {
  LaunchData({
    required this.flightNumber,
    required this.missionName,
    required this.launchYear,
    required this.launchDateUnix,
    required this.launchDateUtc,
    required this.launchDateLocal,
    required this.rocket,
    required this.launchSite,
  });

  final int flightNumber;
  final String missionName;
  final String launchYear;
  final int launchDateUnix;
  final DateTime launchDateUtc;
  final DateTime launchDateLocal;
  final Rocket rocket;
  final LaunchSite launchSite;

  factory LaunchData.fromJson(Map<String, dynamic> json) => LaunchData(
    flightNumber: json["flight_number"] ,
    missionName: json["mission_name"],
    launchYear: json["launch_year"],
    launchDateUnix: json["launch_date_unix"],
    launchDateUtc: DateTime.parse(json["launch_date_utc"]),
    launchDateLocal: DateTime.parse(json["launch_date_local"]),
    rocket: Rocket.fromJson(json["rocket"]),
    launchSite: LaunchSite.fromJson(json["launch_site"]),
  );

  Map<String, dynamic> toJson() => {
    "flight_number": flightNumber,
    "mission_name": missionName,
    "launch_year": launchYear,
    "launch_date_unix": launchDateUnix,
    "launch_date_utc": launchDateUtc.toIso8601String(),
    "launch_date_local": launchDateLocal.toIso8601String(),
    "rocket": rocket.toJson(),
    "launch_site": launchSite.toJson(),
  };
}

class LaunchSite {
  LaunchSite({
    required this.siteId,
    required this.siteName,
    required this.siteNameLong,
  });

  final String siteId;
  final String siteName;
  final String siteNameLong;

  factory LaunchSite.fromJson(Map<String, dynamic> json) => LaunchSite(
    siteId: json["site_id"],
    siteName: json["site_name"],
    siteNameLong: json["site_name_long"],
  );

  Map<String, dynamic> toJson() => {
    "site_id": siteId,
    "site_name": siteName,
    "site_name_long": siteNameLong,
  };
}

class Rocket {
  Rocket({
    required this.rocketId,
    required this.rocketName,
    required this.rocketType,
  });

  final String rocketId;
  final String rocketName;
  final String rocketType;

  factory Rocket.fromJson(Map<String, dynamic> json) => Rocket(
    rocketId: json["rocket_id"],
    rocketName: json["rocket_name"],
    rocketType: json["rocket_type"],
  );

  Map<String, dynamic> toJson() => {
    "rocket_id": rocketId,
    "rocket_name": rocketName,
    "rocket_type": rocketType,
  };
}
