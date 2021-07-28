import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/model/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/database/local.dart';
import 'urls.dart';

class AuthController {
  static UserModel _userModel = UserModel();
  static UserModel get user => _userModel;

  static Future authFunc({
    @required String password,
    @required String phone,
    String username,
    bool login,
  }) async {
    final userData = json.encode(login
        ? Urls.signInMap(phone, password)
        : Urls.signUpMap(username, password, phone));

    try {
      http.Response response = await http.post(
        Uri.parse(
          login ? Urls.loginUrl : Urls.signUpUrl,
        ),
        headers: Urls.authHeaders,
        body: userData,
      );
      messageFunc(response.statusCode, response, true);
    } catch (e) {
      print(e);
    }
  }

  static Future verifyFunc({@required String phone, @required String code}) async {
    final userInput = json.encode(Urls.verifyMap(phone, code));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.verifyUrl,
        ),
        headers: Urls.authHeaders,
        body: userInput,
      );

      messageFunc(response.statusCode, response, false);
    } catch (e) {
      print(e);
    }
  }

  static Future forgetPassword({@required String phone}) async {
    final userInput = json.encode(Urls.forgetMap(phone));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.forgetUrl,
        ),
        headers: Urls.authHeaders,
        body: userInput,
      );
      messageFunc(response.statusCode, response, false);
    } catch (e) {
      print(e);
    }
  }

  static Future resetPassword(
      {@required String phone, @required String code, @required String password}) async {
    final userInput = json.encode(Urls.resetMap(phone, code, password));
    try {
      http.Response response = await http.post(
        Uri.parse(
          Urls.resetUrl,
        ),
        headers: Urls.authHeaders,
        body: userInput,
      );
      messageFunc(response.statusCode, response, true);
    } catch (e) {
      print(e);
    }
  }

  static okay(http.Response response) {
    _userModel = userModelFromJson(response.body);
    print('login token is : ${user.token}');
    DataInLocal.saveInLocal(
      token: _userModel.token,
      phone: _userModel.user.phone,
    );
    Urls.errorMessage = 'no';
  }

  static messageFunc(int responseCode, http.Response response, bool auth) {
    switch (responseCode) {
      case 200:
      case 201:
        {
          auth ? okay(response) : Urls.errorMessage = 'no';
          print(responseCode);
        }
        break;
      case 400:
        {
          Urls.errorMessage = 'phone Already In use';
          print(responseCode);
        }
        break;
      case 401:
        {
          Urls.errorMessage = 'Invalid Email or Password';
          print(responseCode);
        }
        break;
      case 404:
        {
          Urls.errorMessage = 'You did something NOT FOUND !';
          print(responseCode);
        }
        break;
      case 500:
        {
          Urls.errorMessage = 'Server Error : we have a problem just try again later';
          print(responseCode);
        }
        break;
      default:
        {
          Urls.errorMessage =
              'We have Unknown error just connect us later or feedback $responseCode';
          print(responseCode);
        }
    }
  }
}
