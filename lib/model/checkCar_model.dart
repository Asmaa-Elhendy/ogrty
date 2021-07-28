//     final checkCarModel = checkCarModelFromJson(jsonString);

import 'dart:convert';

CheckCarModel checkCarModelFromJson(String str) =>
    CheckCarModel.fromJson(json.decode(str));

String checkCarModelToJson(CheckCarModel data) => json.encode(data.toJson());

class CheckCarModel {
  CheckCarModel({
    this.id,
    this.type,
    this.owner,
    this.currentDriver,
    this.currentJourney,
    this.photo,
    this.number,
    this.numberOfSeats,
    this.enabled,
    this.transportType,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String type;
  int owner;
  CurrentDriver currentDriver;
  int currentJourney;
  String photo;
  String number;
  int numberOfSeats;
  bool enabled;
  String transportType;
  String code;
  DateTime createdAt;
  DateTime updatedAt;

  factory CheckCarModel.fromJson(Map<String, dynamic> json) => CheckCarModel(
        id: json["id"],
        type: json["type"],
        owner: json["owner"],
        currentDriver: CurrentDriver.fromJson(json["current_driver"]),
        currentJourney: json["current_journey"],
        photo: json["photo"],
        number: json["number"],
        numberOfSeats: json["numberOfSeats"],
        enabled: json["enabled"],
        transportType: json["transportType"],
        code: json["code"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "owner": owner,
        "current_driver": currentDriver.toJson(),
        "current_journey": currentJourney,
        "photo": photo,
        "number": number,
        "numberOfSeats": numberOfSeats,
        "enabled": enabled,
        "transportType": transportType,
        "code": code,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class CurrentDriver {
  CurrentDriver({
    this.id,
    this.username,
    this.photo,
    this.phone,
    this.role,
  });

  int id;
  String username;
  String photo;
  String phone;
  String role;

  factory CurrentDriver.fromJson(Map<String, dynamic> json) => CurrentDriver(
        id: json["id"],
        username: json["username"],
        photo: json["photo"],
        phone: json["phone"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "photo": photo,
        "phone": phone,
        "role": role,
      };
}
