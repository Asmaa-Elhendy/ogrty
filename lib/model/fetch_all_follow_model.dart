// To parse this JSON data, do
//
//     final fetchAllFollowModel = fetchAllFollowModelFromJson(jsonString);

import 'dart:convert';

List<FetchAllFollowModel> fetchAllFollowModelFromJson(String str) =>
    List<FetchAllFollowModel>.from(
        json.decode(str).map((x) => FetchAllFollowModel.fromJson(x)));

String fetchAllFollowModelToJson(List<FetchAllFollowModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchAllFollowModel {
  FetchAllFollowModel({
    this.id,
    this.sender,
    this.receiver,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  Sender sender;
  int receiver;
  DateTime createdAt;
  DateTime updatedAt;

  factory FetchAllFollowModel.fromJson(Map<String, dynamic> json) => FetchAllFollowModel(
        id: json["id"] == null ? null : json["id"],
        sender: json["sender"] == null ? null : Sender.fromJson(json["sender"]),
        receiver: json["receiver"] == null ? null : json["receiver"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "sender": sender == null ? null : sender.toJson(),
        "receiver": receiver == null ? null : receiver,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Sender {
  Sender({
    this.id,
    this.username,
    this.photo,
    this.phone,
    this.trustable,
    this.center,
    this.currentJourney,
    this.wallet,
    this.enabled,
    this.pushTokens,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String username;
  String photo;
  String phone;
  List<int> trustable;
  int center;
  dynamic currentJourney;
  int wallet;
  bool enabled;
  List<dynamic> pushTokens;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        photo: json["photo"] == null ? null : json["photo"],
        phone: json["phone"] == null ? null : json["phone"],
        trustable: json["trustable"] == null
            ? null
            : List<int>.from(json["trustable"].map((x) => x)),
        center: json["center"] == null ? null : json["center"],
        currentJourney: json["current_journey"],
        wallet: json["wallet"] == null ? null : json["wallet"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        pushTokens: json["pushTokens"] == null
            ? null
            : List<dynamic>.from(json["pushTokens"].map((x) => x)),
        role: json["role"] == null ? null : json["role"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "photo": photo == null ? null : photo,
        "phone": phone == null ? null : phone,
        "trustable":
            trustable == null ? null : List<dynamic>.from(trustable.map((x) => x)),
        "center": center == null ? null : center,
        "current_journey": currentJourney,
        "wallet": wallet == null ? null : wallet,
        "enabled": enabled == null ? null : enabled,
        "pushTokens":
            pushTokens == null ? null : List<dynamic>.from(pushTokens.map((x) => x)),
        "role": role == null ? null : role,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
