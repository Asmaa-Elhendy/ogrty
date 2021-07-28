// To parse this JSON data, do
//
//     final governoratesModel = governoratesModelFromJson(jsonString);

import 'dart:convert';

List<GovernoratesModel> governoratesModelFromJson(String str) =>
    List<GovernoratesModel>.from(
        json.decode(str).map((x) => GovernoratesModel.fromJson(x)));

String governoratesModelToJson(List<GovernoratesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GovernoratesModel {
  GovernoratesModel({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  int id;
  String nameAr;
  String nameEn;

  factory GovernoratesModel.fromJson(Map<String, dynamic> json) => GovernoratesModel(
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
