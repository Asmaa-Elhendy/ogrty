import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/checkCar_model.dart';
import 'package:http/http.dart' as http;
import 'package:ogrety_app/model/payment_model.dart';
import 'dart:convert';
import 'urls.dart';

class PaymentController {
  static CheckCarModel _checkCarModel = CheckCarModel();
  static CheckCarModel get checkCar => _checkCarModel;
  static PaymentModel _paymentModel = PaymentModel();
  static PaymentModel get paymentModel => _paymentModel;

  static Future checkCarFunc({@required String token, @required String code}) async {
    final userInput = json.encode(Urls.checkCarMap(code: code));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.checkCarUrl,
        ),
        headers: Urls.paymentHeaders(token: token),
        body: userInput,
      );
      checkCarMessage(response);
    } catch (e) {
      print(e);
    }
  }

  static Future paymentFunc(
      {@required String token,
      @required String code,
      @required String cost,
      @required bool bus,
      List<int> seatNumber}) async {
    final userInput = json.encode(bus
        ? Urls.paymentBusMap(code: code, cost: cost, seatNumber: seatNumber)
        : Urls.paymentMap(code: code, cost: cost));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.paymentUrl,
        ),
        headers: Urls.paymentHeaders(token: token),
        body: userInput,
      );
      paymentMessage(response);
      print(cost);
    } catch (e) {
      print(e);
    }
  }

  static paymentMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          Urls.errorMessage = 'no';
          _paymentModel = paymentModelFromJson(response.body);
          print(response.statusCode);
        }
        break;
      case 201:
        {
          Urls.errorMessage = 'no';
          _paymentModel = paymentModelFromJson(response.body);
          print(response.statusCode);
        }
        break;
      case 400:
        {
          Urls.errorMessage = 'Car code not found. make sure from car\'s code';
          print(response.statusCode);
        }
        break;
      case 403:
        {
          Urls.errorMessage = 'Not enough cost to pay';
          print(response.statusCode);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'You did not sent the car\'s code or cost !';
          print(response.statusCode);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server Error : we have a problem just try again later';
          print(response.statusCode);
        }
        break;
      default:
        {
          Urls.errorMessage =
              'We have Unknown error just connect us later or feedback ${response.statusCode}';
          print(response.statusCode);
        }
    }
  }

  static checkCarMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          Urls.errorMessage = 'no';
          _checkCarModel = checkCarModelFromJson(response.body);
          print(response.statusCode);
        }
        break;
      case 201:
        {
          Urls.errorMessage = 'no';
          _checkCarModel = checkCarModelFromJson(response.body);
          print(response.statusCode);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'Car code not found. make sure from car\'s code';
          print(response.statusCode);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server Error : we have a problem just try again later';
          print(response.statusCode);
        }
        break;
      default:
        {
          Urls.errorMessage =
              'We have Unknown error just connect us later or feedback ${response.statusCode}';
          print(response.statusCode);
        }
    }
  }
}

// 400 no code or cost   , 403 not enough cost , 201 done transaction , 200 payment
