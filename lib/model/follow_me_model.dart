// To parse this JSON data, do
//
//     final followMeModel = followMeModelFromJson(jsonString);

import 'dart:convert';

FollowMeModel followMeModelFromJson(String str) =>
    FollowMeModel.fromJson(json.decode(str));

String followMeModelToJson(FollowMeModel data) => json.encode(data.toJson());

class FollowMeModel {
  FollowMeModel({
    this.id,
    this.sender,
    this.receiver,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int sender;
  int receiver;
  DateTime createdAt;
  DateTime updatedAt;

  factory FollowMeModel.fromJson(Map<String, dynamic> json) => FollowMeModel(
        id: json["id"] == null ? null : json["id"],
        sender: json["sender"] == null ? null : json["sender"],
        receiver: json["receiver"] == null ? null : json["receiver"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sender": sender == null ? null : sender,
        "receiver": receiver == null ? null : receiver,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
