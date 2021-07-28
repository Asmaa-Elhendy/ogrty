// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        photo: json["photo"] == null ? null : json["photo"],
        phone: json["phone"] == null ? null : json["phone"],
        trustable: json["trustable"] == null
            ? null
            : List<int>.from(json["trustable"].map((x) => x)),
        wallet: json["wallet"] == null ? null : json["wallet"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        pushTokens: json["pushTokens"] == null
            ? null
            : List<dynamic>.from(json["pushTokens"].map((x) => x)),
        role: json["role"] == null ? null : json["role"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "photo": photo == null ? null : photo,
        "phone": phone == null ? null : phone,
        "trustable": trustable == null
            ? null
            : List<dynamic>.from(trustable.map((x) => x)),
        "wallet": wallet == null ? null : wallet,
        "enabled": enabled == null ? null : enabled,
        "pushTokens": pushTokens == null
            ? null
            : List<dynamic>.from(pushTokens.map((x) => x)),
        "role": role == null ? null : role,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
