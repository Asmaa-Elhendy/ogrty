import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/transfer_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'urls.dart';

class TransferController {
  static TransferModel _transferModel = TransferModel();
  static TransferModel get transferModel => _transferModel;

  static Future transferMoney(
      {@required String token, @required String phone, @required String cost}) async {
    final userInput = json.encode(Urls.transferMap(cost: cost, phone: phone));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.transferUrl,
        ),
        headers: Urls.paymentHeaders(token: token),
        body: userInput,
      );
      transferringMessage(response);
    } catch (e) {
      print(e);
    }
  }

  static transferringMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          Urls.errorMessage = 'no';
          _transferModel = transferModelFromJson(response.body);
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 201:
        {
          Urls.errorMessage = 'no';
          _transferModel = transferModelFromJson(response.body);
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 403:
        {
          Urls.errorMessage = 'You do\'nt have enough money';
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'you entered a not existing number';
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
              'We have Unknown error happen while transferring your money\ncheck your connection\nor tell us ${response.statusCode}';
          print(response.statusCode);
          print(response.body);
        }
    }
  }
}
