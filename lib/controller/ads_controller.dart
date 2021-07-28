import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ogrety_app/model/ads_model.dart';
import 'urls.dart';

class AdsController {
  static AdsModel _adsModel = AdsModel();
  static AdsModel get adsModel => _adsModel;

  static Future getRandomAdd(String token) async {
    try {
      http.Response response = await http.get(Uri.parse(Urls.adsUrl),
          headers: Urls.myTrustReqHeadersMap(token));
      getMessage(response);
    } catch (e) {
      print(e);
    }
  }

  static getMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          Urls.errorMessage = 'no';
          _adsModel = adsModelFromJson(response.body);
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
          Urls.errorMessage =
              'Server Error : we have a problem just try again later';
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
