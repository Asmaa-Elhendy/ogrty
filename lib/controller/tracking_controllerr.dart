import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ogrety_app/model/tracking_get_model.dart';
import 'urls.dart';
import 'package:flutter/cupertino.dart';

class TrackingController {
  static TrackingGetModel _trackingGetModel = TrackingGetModel();
  static TrackingGetModel get trackingGetModel => _trackingGetModel;
  static Future sendCoordinatesToTrack(
      {@required String token, @required num lat, @required num long}) async {
    final String userInput = json.encode(Urls.sendCoordinatesMap(lat: lat, long: long));
    try {
      http.Response response = await http.post(Uri.parse(Urls.trackingSendCoordinatesUrl),
          headers: Urls.paymentHeaders(token: token), body: userInput);
      getMessage(response, false);
    } catch (e) {
      print(e);
    }
  }

  static Future getCoordinatesToTrack(
      {@required String token, @required int senderId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(Urls.trackingGetCoordinatesUrl(senderId)),
          headers: Urls.paymentHeaders(token: token));
      getMessage(response, true);
    } catch (e) {
      print(e);
    }
  }

  static getMessage(http.Response response, bool get) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          Urls.errorMessage = 'no';
          get
              ? _trackingGetModel = trackingGetModelFromJson(response.body)
              : print('post');
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
