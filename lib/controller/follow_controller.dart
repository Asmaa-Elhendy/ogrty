import 'package:http/http.dart' as http;
import 'package:ogrety_app/model/fetch_all_follow_model.dart';
import 'package:ogrety_app/model/follow_me_model.dart';
import 'urls.dart';
import 'package:flutter/cupertino.dart';

class FollowController {
  static FollowMeModel _followMeModel = FollowMeModel();
  static FollowMeModel get followMeModel => _followMeModel;
  static List<FetchAllFollowModel> _fetchAllFollowModel = <FetchAllFollowModel>[];
  static List<FetchAllFollowModel> get fetchAllFollowModel => _fetchAllFollowModel;

  static Future followMe({@required String token, @required int id}) async {
    try {
      http.Response response = await http.post(Uri.parse(Urls.followMe(id)),
          headers: Urls.myTrustReqHeadersMap(token));
      getMessage(response, true);
    } catch (e) {
      print(e);
    }
  }

  static Future fetchAllFollowReq({
    @required String token,
  }) async {
    try {
      http.Response response = await http.get(Uri.parse(Urls.fetchAllFollowReq),
          headers: Urls.myTrustReqHeadersMap(token));
      getMessage(response, false);
    } catch (e) {
      print(e);
    }
  }

  static getMessage(http.Response response, bool followMe) {
    switch (response.statusCode) {
      case 200:
      case 201:
        {
          Urls.errorMessage = 'no';
          followMe
              ? _followMeModel = followMeModelFromJson(response.body)
              : _fetchAllFollowModel = fetchAllFollowModelFromJson(response.body);
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
