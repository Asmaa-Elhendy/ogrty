import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/reaction_model.dart';
import '../../urls.dart';

class ReactionsController {
  static ReactionsModel _reactionsModel = ReactionsModel();
  static ReactionsModel get reactions => _reactionsModel;

  static Future addReact({@required String token, @required int id}) async {
    final userInput = json.encode(Urls.addReactMap);
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.addReact(id: id),
        ),
        headers: Urls.paymentHeaders(token: token),
        body: userInput,
      );
      return reactMessage(response, true);
    } catch (e) {
      print(e);
    }
  }

  static Future removeReact({@required String token, @required int id}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse(
          Urls.removeReact(id: id),
        ),
        headers: Urls.myTrustReqHeadersMap(token),
      );
      reactMessage(response, false);
    } catch (e) {
      print(e);
    }
  }

  static reactMessage(http.Response response, bool add) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          Urls.errorMessage = 'no';
          add ? _reactionsModel = reactionsModelFromJson(response.body) : print('delete');
          print(response.statusCode);
          print(response.body);
          return _reactionsModel;
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
