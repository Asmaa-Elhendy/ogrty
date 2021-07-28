import 'package:flutter/cupertino.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/profile_model.dart';
import 'package:http/http.dart' as http;

class ProfileController {
  static ProfileModel _profileModel = ProfileModel();
  static ProfileModel get profile => _profileModel;
  static set profileData(ProfileModel profileModel) {
    _profileModel = profileModel;
  }

  static Future getProfile({
    @required String token,
  }) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
            Urls.profileUrl,
          ),
          headers: Urls.myTrustReqHeadersMap(token));
      _fetchingMessage(response);
    } catch (e) {
      print("$e in fecth post method");
    }
  }

  static _fetchingMessage(http.Response response) {
    switch (response.statusCode) {
      case 200:
        {
          Urls.errorMessage = 'no';
          _profileModel = profileModelFromJson(response.body);
          print(response.statusCode);
          print(response.body);
        }
        break;
      case 201:
        {
          Urls.errorMessage = 'no';
          _profileModel = profileModelFromJson(response.body);
          print(response.body);
          print(response.statusCode);
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
