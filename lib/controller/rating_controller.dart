import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/rating_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'urls.dart';

class RatingController {
  static RatingModel _ratingModel = RatingModel();
  static RatingModel get ratingModel => _ratingModel;

  static Future ratingDriver(
      {@required String token,
      @required int rating,
      @required String feedback,
      @required int id}) async {
    final userInput = json.encode(Urls.ratingMap(rating: rating, feedback: feedback));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.rateUrl(id: id),
        ),
        headers: Urls.paymentHeaders(token: token),
        body: userInput,
      );
      ratingMessage(response);
    } catch (e) {
      print(e);
    }
  }

  static ratingMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          Urls.errorMessage = 'no';
          _ratingModel = ratingModelFromJson(response.body);
          print(response.statusCode);
        }
        break;
      case 201:
        {
          Urls.errorMessage = 'no';
          _ratingModel = ratingModelFromJson(response.body);
          print(response.statusCode);
        }
        break;
      case 403:
        {
          Urls.errorMessage = '403';
          print(response.statusCode);
        }
        break;
      case 404:
        {
          Urls.errorMessage = '404';
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
