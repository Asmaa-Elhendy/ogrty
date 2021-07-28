//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  PaymentModel({
    this.id,
    this.user,
    this.driver,
    this.car,
    this.cost,
    this.seatNumber,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int user;
  int driver;
  int car;
  int cost;
  List<int> seatNumber;
  DateTime createdAt;
  DateTime updatedAt;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        user: json["user"],
        driver: json["driver"],
        car: json["car"],
        cost: json["cost"],
        seatNumber: List<int>.from(json["seatNumber"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "driver": driver,
        "car": car,
        "cost": cost,
        "seatNumber": List<dynamic>.from(seatNumber.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
