import 'package:ogrety_app/model/posts_model.dart';
import '../../urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class PostsController {
  static PostsModel _postsModel = PostsModel();
  static PostsModel get posts => _postsModel;
  static var dio = Dio();

  static Future fetchPosts({@required String token, @required int page}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
            Urls.fetchPostsUrl(page: page),
          ),
          headers: Urls.myTrustReqHeadersMap(token));
      fetchingMessage(response, false);
    } catch (e) {
      print("$e in fecth post method");
    }
  }

  static Future sharePosts({@required String token, @required int id}) async {
    try {
      http.Response response = await http.post(
          Uri.parse(
            Urls.sharePostUrl(id: id),
          ),
          headers: Urls.paymentHeaders(token: token));
      fetchingMessage(response, false);
    } catch (e) {
      print("$e in share post method");
    }
  }

  static Future updateOrDeletePostMethod(
      {@required String token,
      @required List photos,
      @required String content,
      @required int id,
      @required bool delete}) async {
    if (delete) {
      try {
        http.Response response = await http.delete(
            Uri.parse(
              Urls.updateOrDeletePostUrl(id: id),
            ),
            headers: Urls.myTrustReqHeadersMap(token));
        fetchingMessage(response, true);
      } catch (e) {
        print("$e in delete post method");
      }
    } else {
      // FormData formData = FormData.fromMap(
      //   Urls.updatePostMap(content: content ?? "", files: photos),
      // );
      final userInput =
          json.encode(Urls.updatePostMap(content: content ?? "", files: photos));
      try {
        Response response = await dio.put(Urls.updateOrDeletePostUrl(id: id),
            data: userInput,
            options: Options(
              headers: Urls.myTrustReqHeadersMap(token),
            ));
        _addMessage(response);
      } catch (e) {
        Urls.errorMessage = 'Err in add comment method';
        print("$e in add comment method");
      }
    }
  }

  static Future addPostMethod({
    @required String token,
    @required List file,
    @required String content,
  }) async {
    List myFiles = [];
    FormData formData = FormData();
    for (var i in file) {
      if (file.isEmpty) {
        return;
      }
      String path = i;
      String filename = i.split('/').last;
      MultipartFile fileFinal = await MultipartFile.fromFile(
        path,
        filename: filename,
        contentType: MediaType('image', 'jpg'),
      );
      myFiles.add(fileFinal);
      formData = FormData.fromMap(
        Urls.addPostMap(content: content ?? "", files: myFiles),
      );
    }
    FormData newFormData = FormData.fromMap(Urls.mapAddingWithoutFiles(content: content));
    try {
      Response response = await dio.post(Urls.addPostUrl,
          data: file.isEmpty ? newFormData : formData,
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
      case 201:
        {
          Urls.errorMessage = 'no';
          print(response.statusCode);
          print(response.data);
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
          Urls.errorMessage =
              'We have Unknown error\ncheck your connection\nor tell us ${response.statusCode}';
          print(response.data);
          print(response.statusCode);
        }
    }
  }

  static fetchingMessage(http.Response response, bool delete) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          Urls.errorMessage = 'no';

          delete ? print('deleted') : _postsModel = postsModelFromJson(response.body);
          print(response.statusCode);
          print(response.body);
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
          Urls.errorMessage =
              'We have Unknown error\ncheck your connection\nor tell us ${response.statusCode}';
          print(response.body);
          print(response.statusCode);
        }
    }
  }
}
