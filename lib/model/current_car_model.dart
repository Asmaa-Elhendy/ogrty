// To parse this JSON data, do
//
//     final currentCarModel = currentCarModelFromJson(jsonString);

import 'dart:convert';

CurrentCarModel currentCarModelFromJson(String str) =>
    CurrentCarModel.fromJson(json.decode(str));

String currentCarModelToJson(CurrentCarModel data) => json.encode(data.toJson());

class CurrentCarModel {
  CurrentCarModel({
    this.id,
    this.type,
    this.owner,
    this.photo,
    this.number,
    this.numberOfSeats,
    this.enabled,
    this.gove1,
    this.gove2,
    this.from,
    this.to,
    this.station,
    this.transportType,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String type;
  Owner owner;
  String photo;
  String number;
  int numberOfSeats;
  bool enabled;
  int gove1;
  int gove2;
  int from;
  int to;
  int station;
  String transportType;
  String code;
  DateTime createdAt;
  DateTime updatedAt;

  factory CurrentCarModel.fromJson(Map<String, dynamic> json) => CurrentCarModel(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        photo: json["photo"] == null ? null : json["photo"],
        number: json["number"] == null ? null : json["number"],
        numberOfSeats: json["numberOfSeats"] == null ? null : json["numberOfSeats"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        gove1: json["gove1"] == null ? null : json["gove1"],
        gove2: json["gove2"] == null ? null : json["gove2"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        station: json["station"] == null ? null : json["station"],
        transportType: json["transportType"] == null ? null : json["transportType"],
        code: json["code"] == null ? null : json["code"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "type": type == null ? null : type,
        "owner": owner == null ? null : owner.toJson(),
        "photo": photo == null ? null : photo,
        "number": number == null ? null : number,
        "numberOfSeats": numberOfSeats == null ? null : numberOfSeats,
        "enabled": enabled == null ? null : enabled,
        "gove1": gove1 == null ? null : gove1,
        "gove2": gove2 == null ? null : gove2,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "station": station == null ? null : station,
        "transportType": transportType == null ? null : transportType,
        "code": code == null ? null : code,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Owner {
  Owner({
    this.id,
    this.username,
    this.photo,
    this.phone,
    this.rating,
    this.role,
  });

  int id;
  String username;
  String photo;
  String phone;
  int rating;
  String role;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        photo: json["photo"] == null ? null : json["photo"],
        phone: json["phone"] == null ? null : json["phone"],
        rating: json["rating"] == null ? null : json["rating"],
        role: json["role"] == null ? null : json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "photo": photo == null ? null : photo,
        "phone": phone == null ? null : phone,
        "rating": rating == null ? null : rating,
        "role": role == null ? null : role,
      };
}
