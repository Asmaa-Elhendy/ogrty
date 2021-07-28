//     final ratingModel = ratingModelFromJson(jsonString);

import 'dart:convert';

RatingModel ratingModelFromJson(String str) =>
    RatingModel.fromJson(json.decode(str));

String ratingModelToJson(RatingModel data) => json.encode(data.toJson());

class RatingModel {
  RatingModel({
    this.id,
    this.user,
    this.rating,
    this.subject,
    this.subjectType,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int user;
  int rating;
  Subject subject;
  String subjectType;
  String feedback;
  DateTime createdAt;
  DateTime updatedAt;

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        id: json["id"],
        user: json["user"],
        rating: json["rating"],
        subject: Subject.fromJson(json["subject"]),
        subjectType: json["subjectType"],
        feedback: json["feedback"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "rating": rating,
        "subject": subject.toJson(),
        "subjectType": subjectType,
        "feedback": feedback,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Subject {
  Subject({
    this.id,
    this.username,
    this.photo,
    this.phone,
    this.cars,
    this.owners,
    this.rating,
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
  List<dynamic> cars;
  List<dynamic> owners;
  int rating;
  int wallet;
  bool enabled;
  List<dynamic> pushTokens;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json["id"],
        username: json["username"],
        photo: json["photo"],
        phone: json["phone"],
        cars: List<dynamic>.from(json["cars"].map((x) => x)),
        owners: List<dynamic>.from(json["owners"].map((x) => x)),
        rating: json["rating"],
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
        "cars": List<dynamic>.from(cars.map((x) => x)),
        "owners": List<dynamic>.from(owners.map((x) => x)),
        "rating": rating,
        "wallet": wallet,
        "enabled": enabled,
        "pushTokens": List<dynamic>.from(pushTokens.map((x) => x)),
        "role": role,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
