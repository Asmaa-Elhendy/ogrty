import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/add_comment_model.dart';
import 'package:ogrety_app/model/fetch_comments_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class CommentsController {
  static FetchCommentModel _commentsModel = FetchCommentModel();
  static FetchCommentModel get comments => _commentsModel;
  static AddCommentModel _addCommentModel = AddCommentModel();
  static AddCommentModel get addCommentModel => _addCommentModel;
  static set setAddCommentModel(AddCommentModel model) {
    _addCommentModel = model;
  }

  static var dio = Dio();

  static Future fetchCommentsByPostId({
    @required String token,
    @required int postId,
    @required int page,
  }) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
            Urls.fetchCommentsUrl(postId: postId, page: page),
          ),
          headers: Urls.myTrustReqHeadersMap(token));
      _fetchingMessage(response);
    } catch (e) {
      print("$e in fecth post method");
    }
  }

  static Future addComment({
    @required String token,
    @required int postId,
    @required File file,
    @required String content,
  }) async {
    String filename = file == null ? null : file.path.split('/').last;
    FormData formData = FormData.fromMap(
      file == null
          ? Urls.mapAddingWithoutFiles(content: content)
          : Urls.addCommentMap(
              content: content,
              file: file == null
                  ? null
                  : await MultipartFile.fromFile(
                      file.path,
                      filename: filename,
                      contentType: MediaType('image', 'jpg'),
                    ),
            ),
    );
    try {
      Response response = await dio.post(Urls.addCommentUrl(postId: postId),
          data: formData,
          options: Options(
            headers: Urls.myTrustReqHeadersMap(token),
          ));
      _addMessage(response);
    } catch (e) {
      Urls.errorMessage = 'Err in add comment method';
      print("$e in add comment method");
    }
  }

  static _addMessage(Response response) {
    switch (response.statusCode) {
      case 200:
        {
          _addCommentModel = AddCommentModel.fromJson(response.data);
          Urls.errorMessage = 'no';
          print(response.statusCode);
          print(response.data);
        }
        break;
      case 201:
        {
          _addCommentModel = AddCommentModel.fromJson(response.data);
          Urls.errorMessage = 'no';
          print(response.data);
          print(response.statusCode);
        }
        break;
      case 403:
        {
          Urls.errorMessage = 'Forbidden access';
          print(response.statusCode);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'Posts not found !';
          print(response.statusCode);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server down try again later';
          print(response.statusCode);
        }
        break;
      default:
        {
          Urls.errorMessage = 'We have Unknown error\ncheck your connection\nor tell us ${response.statusCode}';
          print(response.data);
          print(response.statusCode);
        }
    }
  }

  static _fetchingMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          Urls.errorMessage = 'no';
          _commentsModel = fetchCommentModelFromJson(response.body);
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 201:
        {
          Urls.errorMessage = 'no';
          _commentsModel = fetchCommentModelFromJson(response.body);
          print(response.body);
          print(response.statusCode);
        }
        break;
      case 403:
        {
          Urls.errorMessage = 'Forbidden access';
          print(response.statusCode);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'Posts not found !';
          print(response.statusCode);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server down try again later';
          print(response.statusCode);
        }
        break;
      default:
        {
          Urls.errorMessage = 'We have Unknown error\ncheck your connection\nor tell us ${response.statusCode}';
          print(response.body);
          print(response.statusCode);
        }
    }
  }
}
