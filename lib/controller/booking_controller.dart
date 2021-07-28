import 'package:flutter/foundation.dart';
import 'package:ogrety_app/model/cars_inParking_model.dart';
import 'package:ogrety_app/model/cars_inline_model.dart';
import 'package:ogrety_app/model/current_car_model.dart';
import 'package:ogrety_app/model/governorates_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'urls.dart';

class BookingController {
  static List<GovernoratesModel> _governoratesModel = <GovernoratesModel>[];
  static List<GovernoratesModel> get governoratesModel => _governoratesModel;
  static List<CarsInLineModel> _carsInLineModel = <CarsInLineModel>[];
  static List<CarsInLineModel> get carsInLineModel => _carsInLineModel;
  static List<CarsInParkingModel> _carsInParkingModel = <CarsInParkingModel>[];
  static List<CarsInParkingModel> get carsInParkingModel => _carsInParkingModel;
  static CurrentCarModel _currentCarModel = CurrentCarModel();
  static CurrentCarModel get currentCarModel => _currentCarModel;

  static Future fetchAllGoVerNoRates({@required String token}) async {
    try {
      http.Response response = await http.get(Uri.parse(Urls.goVerNoRatesUrl),
          headers: Urls.myTrustReqHeadersMap(token));
      putOnModel(response, 1);
    } catch (e) {
      print(e);
    }
  }

  static Future getAllCarsInLine(
      {@required String token, @required int fromId, @required int toId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(Urls.carsInLineUrl(fromId: fromId, toId: toId)),
          headers: Urls.myTrustReqHeadersMap(token));
      putOnModel(response, 2);
    } catch (e) {
      print(e);
    }
  }

  static Future getAllCarsInParking(
      {@required String token, @required int fromId, @required int toId}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(Urls.carsInParkingUrl(fromId: fromId, toId: toId)),
          headers: Urls.myTrustReqHeadersMap(token));
      putOnModel(response, 3);
    } catch (e) {
      print(e);
    }
  }

  static Future getCurrentCar(
      {@required String token, @required int fromId, @required int toId}) async {
    final userInput =
        json.encode(Urls.getCurrentCarAvailableMap(fromId: fromId, toId: toId));
    try {
      http.Response response = await http.post(
        Uri.parse(Urls.currentCarUrl),
        headers: Urls.paymentHeaders(token: token),
        body: userInput,
      );
      putOnModel(response, 4);
    } catch (e) {
      print(e);
    }
  }

  static putOnModel(http.Response response, int which) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          Urls.errorMessage = 'no';
          switchFunc(which, response);
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 403:
        {
          Urls.errorMessage = '403';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 404:
        {
          Urls.errorMessage = '404';
          print(which);
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server down try again later';
          print(response.statusCode);
          print(response.body);
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

  static switchFunc(int which, http.Response response) {
    switch (which) {
      case 1:
        {
          _governoratesModel = governoratesModelFromJson(response.body);
        }
        break;
      case 2:
        {
          _carsInLineModel = carsInLineModelFromJson(response.body);
        }
        break;
      case 3:
        {
          _carsInParkingModel = carsInParkingModelFromJson(response.body);
        }
        break;
      case 4:
        {
          _currentCarModel = currentCarModelFromJson(response.body);
        }
    }
  }
}
