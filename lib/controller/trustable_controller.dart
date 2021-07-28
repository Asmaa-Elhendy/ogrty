import 'package:http/http.dart' as http;
import 'package:ogrety_app/model/myTrust_model.dart';
import 'package:ogrety_app/model/my_trust_req_model.dart';
import 'dart:convert';
import 'urls.dart';
import 'package:flutter/cupertino.dart';

class TrustAbleController {
  static List<MyTrustReqModel> _myTrustReqModel = <MyTrustReqModel>[];
  static List<MyTrustReqModel> get myTrustReqModel => _myTrustReqModel;
  static List<MyTrustModel> _myTrustModel = <MyTrustModel>[];
  static List<MyTrustModel> get myTrustModel => _myTrustModel;

  static Future addTrustAble({@required String token, @required String phone}) async {
    final userData = json.encode(Urls.addTrustMap(phone: phone));
    try {
      http.Response response = await http.post(Uri.parse(Urls.addTrustUrl),
          headers: Urls.paymentHeaders(token: token), body: userData);
      addTrustMessage(response, false);
    } catch (e) {
      print(e);
    }
  }

  static Future fetchMyTrustReq({@required String token}) async {
    http.Response response = await http.get(Uri.parse(Urls.myTrustReqUrl),
        headers: Urls.myTrustReqHeadersMap(token));
    addTrustMessage(response, true);
  }

  static Future fetchMyTrustUsers({@required String token}) async {
    try {
      http.Response response = await http.get(Uri.parse(Urls.myTrustUsersUrl),
          headers: Urls.myTrustReqHeadersMap(token));
      trustUsersMessage(response);
    } catch (e) {
      print(e);
    }
  }

  static Future updateTrustAble(
      {@required String token, @required String id, @required bool accept}) async {
    final userData = json.encode(Urls.updateTrustMap(accept));
    try {
      http.Response response = await http.patch(Uri.parse(Urls.updateTrustUrl(id)),
          headers: Urls.paymentHeaders(token: token), body: userData);
      addTrustMessage(response, false);
    } catch (e) {
      print(e);
    }
  }

  static addTrustMessage(http.Response response, bool req) {
    switch (response.statusCode) {
      case 200:
        {
          print(response.statusCode);
          print(response.body);
          req == true
              ? _myTrustReqModel = myTrustReqModelFromJson(response.body)
              : print('we did not fetch');
          Urls.errorMessage = 'no';
        }
        break;
      case 201:
        {
          print(response.statusCode);
          print(response.body);
          req == true
              ? _myTrustReqModel = myTrustReqModelFromJson(response.body)
              : print('we did not fetch');
          Urls.errorMessage = 'no';
        }
        break;
      case 400:
        {
          Urls.errorMessage = 'Check Number you entered';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 403:
        {
          Urls.errorMessage = 'this number already exists';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'this number notFound';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server Error : we have a problem just try again later';
          print(response.statusCode);
          print(response.body);
        }
        break;
      default:
        {
          Urls.errorMessage =
              'We have Unknown error just connect us later or feedback ${response.statusCode}';
          print(response.statusCode);
          print(response.body);
        }
    }
  }

  static trustUsersMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          _myTrustModel = myTrustModelFromJson(response.body);
          Urls.errorMessage = 'no';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 201:
        {
          _myTrustModel = myTrustModelFromJson(response.body);
          Urls.errorMessage = 'no';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 400:
        {
          Urls.errorMessage = 'Check Number you entered';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 403:
        {
          Urls.errorMessage = 'this number already exists';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'this number notFound';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server Error : we have a problem just try again later';
          print(response.statusCode);
          print(response.body);
        }
        break;
      default:
        {
          Urls.errorMessage =
              'We have Unknown error just connect us later or feedback ${response.statusCode}';
          print(response.statusCode);
          print(response.body);
        }
    }
  }
}
