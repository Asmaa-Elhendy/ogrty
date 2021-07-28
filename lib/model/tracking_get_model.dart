// To parse this JSON data, do
//
//     final trackingGetModel = trackingGetModelFromJson(jsonString);

import 'dart:convert';

TrackingGetModel trackingGetModelFromJson(String str) =>
    TrackingGetModel.fromJson(json.decode(str));

String trackingGetModelToJson(TrackingGetModel data) => json.encode(data.toJson());

class TrackingGetModel {
  TrackingGetModel({
    this.coordinates,
    this.time,
  });

  List<num> coordinates;
  DateTime time;

  factory TrackingGetModel.fromJson(Map<String, dynamic> json) => TrackingGetModel(
        coordinates: json["coordinates"] == null
            ? null
            : List<num>.from(json["coordinates"].map((x) => x)),
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "coordinates":
            coordinates == null ? null : List<dynamic>.from(coordinates.map((x) => x)),
        "time": time == null ? null : time.toIso8601String(),
      };
}
