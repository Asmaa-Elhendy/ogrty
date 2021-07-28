// To parse this JSON data, do
//
//     final reactionsModel = reactionsModelFromJson(jsonString);

import 'dart:convert';

ReactionsModel reactionsModelFromJson(String str) =>
    ReactionsModel.fromJson(json.decode(str));

String reactionsModelToJson(ReactionsModel data) => json.encode(data.toJson());

class ReactionsModel {
  ReactionsModel({
    this.id,
    this.kind,
    this.author,
    this.images,
    this.content,
    this.isShared,
    this.parents,
    this.flavor,
    this.directParent,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kind;
  int author;
  List<String> images;
  String content;
  bool isShared;
  List<dynamic> parents;
  String flavor;
  dynamic directParent;
  Metadata metadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory ReactionsModel.fromJson(Map<String, dynamic> json) => ReactionsModel(
        id: json["id"] == null ? null : json["id"],
        kind: json["kind"] == null ? null : json["kind"],
        author: json["author"] == null ? null : json["author"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        content: json["content"] == null ? null : json["content"],
        isShared: json["isShared"] == null ? null : json["isShared"],
        parents: json["parents"] == null
            ? null
            : List<dynamic>.from(json["parents"].map((x) => x)),
        flavor: json["flavor"] == null ? null : json["flavor"],
        directParent: json["directParent"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "kind": kind == null ? null : kind,
        "author": author == null ? null : author,
        "images":
            images == null ? null : List<dynamic>.from(images.map((x) => x)),
        "content": content == null ? null : content,
        "isShared": isShared == null ? null : isShared,
        "parents":
            parents == null ? null : List<dynamic>.from(parents.map((x) => x)),
        "flavor": flavor == null ? null : flavor,
        "directParent": directParent,
        "metadata": metadata == null ? null : metadata.toJson(),
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Metadata {
  Metadata({
    this.reactions,
    this.comments,
  });

  int reactions;
  int comments;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        reactions: json["reactions"] == null ? null : json["reactions"],
        comments: json["comments"] == null ? null : json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "reactions": reactions == null ? null : reactions,
        "comments": comments == null ? null : comments,
      };
}
