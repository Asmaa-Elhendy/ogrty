//     final transferModel = transferModelFromJson(jsonString);

import 'dart:convert';

TransferModel transferModelFromJson(String str) =>
    TransferModel.fromJson(json.decode(str));

String transferModelToJson(TransferModel data) => json.encode(data.toJson());

class TransferModel {
  TransferModel({
    this.id,
    this.sender,
    this.receiver,
    this.cost,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int sender;
  int receiver;
  int cost;
  DateTime createdAt;
  DateTime updatedAt;

  factory TransferModel.fromJson(Map<String, dynamic> json) => TransferModel(
        id: json["id"],
        sender: json["sender"],
        receiver: json["receiver"],
        cost: json["cost"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender": sender,
        "receiver": receiver,
        "cost": cost,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
