// To parse this JSON data, do
//
//     final myTrustModel = myTrustModelFromJson(jsonString);

import 'dart:convert';

List<MyTrustModel> myTrustModelFromJson(String str) => List<MyTrustModel>.from(
    json.decode(str).map((x) => MyTrustModel.fromJson(x)));

String myTrustModelToJson(List<MyTrustModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyTrustModel {
  MyTrustModel({
    this.id,
    this.requester,
    this.recipient,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  Recipient requester;
  Recipient recipient;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory MyTrustModel.fromJson(Map<String, dynamic> json) => MyTrustModel(
        id: json["id"],
        requester: Recipient.fromJson(json["requester"]),
        recipient: Recipient.fromJson(json["recipient"]),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requester": requester.toJson(),
        "recipient": recipient.toJson(),
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Recipient {
  Recipient({
    this.id,
    this.username,
    this.photo,
    this.phone,
    this.trustable,
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
  int wallet;
  bool enabled;
  List<dynamic> pushTokens;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  factory Recipient.fromJson(Map<String, dynamic> json) => Recipient(
        id: json["id"],
        username: json["username"],
        photo: json["photo"],
        phone: json["phone"],
        trustable: List<int>.from(json["trustable"].map((x) => x)),
        wallet: json["wallet"],
        enabled: json["enabled"],
        pushTokens: List<dynamic>.from(json["pushTokens"].map((x) => x)),
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "photo": photo,
        "phone": phone,
        "trustable": List<dynamic>.from(trustable.map((x) => x)),
        "wallet": wallet,
        "enabled": enabled,
        "pushTokens": List<dynamic>.from(pushTokens.map((x) => x)),
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
