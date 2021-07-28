// To parse this JSON data, do
//
//     final fetchCommentModel = fetchCommentModelFromJson(jsonString);

import 'dart:convert';

FetchCommentModel fetchCommentModelFromJson(String str) =>
    FetchCommentModel.fromJson(json.decode(str));

String fetchCommentModelToJson(FetchCommentModel data) =>
    json.encode(data.toJson());

class FetchCommentModel {
  FetchCommentModel({
    this.docs,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  List<Doc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  factory FetchCommentModel.fromJson(Map<String, dynamic> json) =>
      FetchCommentModel(
        docs: json["docs"] == null
            ? null
            : List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        totalDocs: json["totalDocs"] == null ? null : json["totalDocs"],
        limit: json["limit"] == null ? null : json["limit"],
        totalPages: json["totalPages"] == null ? null : json["totalPages"],
        page: json["page"] == null ? null : json["page"],
        pagingCounter:
            json["pagingCounter"] == null ? null : json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"] == null ? null : json["hasPrevPage"],
        hasNextPage: json["hasNextPage"] == null ? null : json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? null
            : List<dynamic>.from(docs.map((x) => x.toJson())),
        "totalDocs": totalDocs == null ? null : totalDocs,
        "limit": limit == null ? null : limit,
        "totalPages": totalPages == null ? null : totalPages,
        "page": page == null ? null : page,
        "pagingCounter": pagingCounter == null ? null : pagingCounter,
        "hasPrevPage": hasPrevPage == null ? null : hasPrevPage,
        "hasNextPage": hasNextPage == null ? null : hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class Doc {
  Doc({
    this.id,
    this.kind,
    this.author,
    this.images,
    this.content,
    this.isShared,
    this.parents,
    this.flavor,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String kind;
  Author author;
  List images;
  String content;
  bool isShared;
  List<int> parents;
  dynamic flavor;
  Metadata metadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["id"] == null ? null : json["id"],
        kind: json["kind"] == null ? null : json["kind"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        images: json["images"] == null
            ? null
            : List.from(json["images"].map((x) => x)),
        content: json["content"] == null ? null : json["content"],
        isShared: json["isShared"] == null ? null : json["isShared"],
        parents: json["parents"] == null
            ? null
            : List<int>.from(json["parents"].map((x) => x)),
        flavor: json["flavor"],
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
        "author": author == null ? null : author.toJson(),
        "images":
            images == null ? null : List<dynamic>.from(images.map((x) => x)),
        "content": content == null ? null : content,
        "isShared": isShared == null ? null : isShared,
        "parents":
            parents == null ? null : List<dynamic>.from(parents.map((x) => x)),
        "flavor": flavor,
        "metadata": metadata == null ? null : metadata.toJson(),
        "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}

class Author {
  Author({
    this.id,
    this.username,
    this.photo,
    this.role,
  });

  int id;
  String username;
  String photo;
  String role;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        photo: json["photo"] == null ? null : json["photo"],
        role: json["role"] == null ? null : json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "photo": photo == null ? null : photo,
        "role": role == null ? null : role,
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
