// To parse this JSON data, do
//
//     final adsModel = adsModelFromJson(jsonString);

import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
  AdsModel({
    this.content,
    this.photo,
    this.id,
  });

  String content;
  String photo;
  int id;

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
        content: json["content"] == null ? null : json["content"],
        photo: json["photo"] == null ? null : json["photo"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "content": content == null ? null : content,
        "photo": photo == null ? null : photo,
        "id": id == null ? null : id,
      };
}
