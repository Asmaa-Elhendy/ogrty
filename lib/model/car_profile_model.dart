// To parse this JSON data, do
//
//     final singleCarModel = singleCarModelFromJson(jsonString);

import 'dart:convert';

SingleCarModel singleCarModelFromJson(String str) =>
    SingleCarModel.fromJson(json.decode(str));

String singleCarModelToJson(SingleCarModel data) => json.encode(data.toJson());

class SingleCarModel {
  SingleCarModel({
    this.id,
    this.type,
    this.owner,
    this.currentDriver,
    this.currentJourney,
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
  int currentDriver;
  int currentJourney;
  String photo;
  String number;
  int numberOfSeats;
  bool enabled;
  From gove1;
  From gove2;
  From from;
  From to;
  int station;
  String transportType;
  String code;
  DateTime createdAt;
  DateTime updatedAt;

  factory SingleCarModel.fromJson(Map<String, dynamic> json) => SingleCarModel(
        id: json["id"] == null ? null : json["id"],
        type: json["type"] == null ? null : json["type"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        currentDriver: json["current_driver"] == null ? null : json["current_driver"],
        currentJourney: json["current_journey"] == null ? null : json["current_journey"],
        photo: json["photo"] == null ? null : json["photo"],
        number: json["number"] == null ? null : json["number"],
        numberOfSeats: json["numberOfSeats"] == null ? null : json["numberOfSeats"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        gove1: json["gove1"] == null ? null : From.fromJson(json["gove1"]),
        gove2: json["gove2"] == null ? null : From.fromJson(json["gove2"]),
        from: json["from"] == null ? null : From.fromJson(json["from"]),
        to: json["to"] == null ? null : From.fromJson(json["to"]),
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
        "current_driver": currentDriver == null ? null : currentDriver,
        "current_journey": currentJourney == null ? null : currentJourney,
        "photo": photo == null ? null : photo,
        "number": number == null ? null : number,
        "numberOfSeats": numberOfSeats == null ? null : numberOfSeats,
        "enabled": enabled == null ? null : enabled,
        "gove1": gove1 == null ? null : gove1.toJson(),
        "gove2": gove2 == null ? null : gove2.toJson(),
        "from": from == null ? null : from.toJson(),
        "to": to == null ? null : to.toJson(),
        "station": station == null ? null : station,
        "transportType": transportType == null ? null : transportType,
        "code": code == null ? null : code,
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class From {
  From({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  int id;
  String nameAr;
  String nameEn;

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json["id"] == null ? null : json["id"],
        nameAr: json["nameAr"] == null ? null : json["nameAr"],
        nameEn: json["nameEn"] == null ? null : json["nameEn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "nameAr": nameAr == null ? null : nameAr,
        "nameEn": nameEn == null ? null : nameEn,
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
