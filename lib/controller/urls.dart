import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

import 'package:ogrety_app/view/reusable/dialogs.dart';

const String API_URL = "https://ogrty.herokuapp.com/api/v1/";

mixin Urls {
  //
//------------------------//------------------------//------------------------//------------------------------------------------
//---------------------------------////BOOKING CYCLE////------------------------//
  static const String goVerNoRatesUrl = "${API_URL}governorates?paginate=false";
  static const String currentCarUrl = "${API_URL}station/current/car";

  static String carsInLineUrl({@required int fromId, @required int toId}) =>
      "${API_URL}station-inline/$fromId/$toId";
  static String carsInParkingUrl({@required int fromId, @required int toId}) =>
      "${API_URL}station/$fromId/$toId";
//------------------------//------------------------//------------------------//------------------------------------------------

  static String addReplyUrl({@required int commentId}) =>
      "${API_URL}comments/$commentId/replies";
  static const String addPostUrl = "${API_URL}posts";
  static String addReact({@required int id}) => "${API_URL}posts/$id";
  static String sharePostUrl({@required int id}) => "${API_URL}share/$id/post";
  static String updateOrDeletePostUrl({@required int id}) => "${API_URL}post/$id";
  static String removeReact({@required int id}) => "${API_URL}react/$id";
  static String fetchRepliesUrl({@required int page, @required int commentId}) =>
      "${API_URL}fetch/$commentId/replies?page=${page ?? 1}";
  static String fetchPostsUrl({@required int page}) =>
      "${API_URL}fetch/post?page=${page ?? 1}";
  static String addCommentUrl({@required int postId}) =>
      "${API_URL}posts/$postId/comments";
  static String fetchCommentsUrl({@required int postId, @required int page}) =>
      "${API_URL}fetch/$postId/comments?page=${page ?? 1}";
  static const String signUpUrl = "${API_URL}signup-phone";
  static const String adsUrl = "${API_URL}ads-random";
  static const String loginUrl = "${API_URL}login-phone";
  static const String verifyUrl = "${API_URL}verify";
  static const String forgetUrl = "${API_URL}forget";
  static const String profileUrl = "${API_URL}profile";
  static const String resetUrl = "${API_URL}verify-reset";
  static const checkCarUrl = "${API_URL}check-car";
  static const paymentUrl = "${API_URL}payment";
  static const transferUrl = "${API_URL}balance/transfer";
  static rateUrl({@required int id}) => "${API_URL}drivers/$id/rate";
  //------------------------//------------------------//------------------------//------------------------------------------------
  //---------------------------------////TRACKING CYCLE////------------------------//
  static const addTrustUrl = "${API_URL}trustable-request";
  static const myTrustReqUrl = "${API_URL}recipient/trustable-requests";
  static updateTrustUrl(id) => "${API_URL}trustable-request/$id";
  static const myTrustUsersUrl = "${API_URL}requester/trustable-requests";
  static followMe(id) => "${API_URL}follow/$id";
  static const fetchAllFollowReq = "${API_URL}follow";
  static const trackingSendCoordinatesUrl = "${API_URL}tracking";
  static trackingGetCoordinatesUrl(senderId) => "${API_URL}tracking/$senderId";

  //tracking/42
  //------------------------//------------------------//------------------------//------------------------------------------------

  static Map<String, String> addTrustMap({@required String phone}) => {
        "phone": phone,
      };
  static Map<String, String> updateTrustMap(bool accept) =>
      {"status": accept ? "accepted" : "rejected"};

  static const Map<String, String> authHeaders = {
    "Content-Type": "application/json",
  };
  static Map<String, String> myTrustReqHeadersMap(token) =>
      {"Authorization": "Bearer $token"};

  static Map<String, dynamic> signUpMap(username, password, phone) => {
        "password": password,
        "username": username,
        "phone": phone,
      };
  static Map<String, dynamic> signInMap(phone, password) => {
        "phone": phone,
        "password": password,
      };
  static Map<String, dynamic> verifyMap(phone, code) => {
        "phone": phone,
        "code": code,
      };
  static Map<String, dynamic> forgetMap(String phone) => {
        "phone": phone,
      };
  static Map<String, dynamic> resetMap(String phone, code, password) => {
        "phone": phone,
        "code": code,
        "password": password,
      };

  static Map<String, String> paymentHeaders({@required final String token}) =>
      {"Content-Type": "application/json", "Authorization": "Bearer $token"};

  static Map<String, String> checkCarMap({@required final String code}) =>
      {"code": "$code"};

  static Map<String, dynamic> addCommentMap({file, content}) => {
        "content": content,
        "photo": file,
      };
  static Map<String, dynamic> getCurrentCarAvailableMap(
          {@required int fromId, @required int toId}) =>
      {"from": fromId, "to": toId};

  static Map<String, dynamic> mapAddingWithoutFiles({content}) => {
        "content": content,
      };
  static Map<String, dynamic> addPostMap({@required List files, @required content}) => {
        "content": content,
        "photo": files,
      };
  static Map<String, dynamic> updatePostMap({@required List files, @required content}) =>
      {
        "content": content,
        "oldImg": files,
      };
  static Map<String, String> paymentMap({
    @required final String code,
    @required final String cost,
  }) =>
      {"code": "$code", "cost": "$cost"};
  static Map<String, dynamic> paymentBusMap(
          {@required final String code,
          @required final String cost,
          @required List<int> seatNumber}) =>
      {"code": "$code", "cost": "$cost", "seatNumber": seatNumber};
  static Map<String, String> transferMap(
          {@required final String cost, @required final String phone}) =>
      {
        "cost": cost,
        "phone": phone,
      };
  static Map<String, dynamic> addReactMap = {"flavor": "love"};

  static Map<String, dynamic> ratingMap(
          {@required final int rating, @required final String feedback}) =>
      {"rating": rating, "feedback": feedback};
  static String errorMessage = 'no';
  static Future<bool> checkNetworkError(context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      networkError(context);
      return true;
    }
    return false;
  }

  static Map<String, dynamic> sendCoordinatesMap(
          {@required num lat, @required num long}) =>
      {
        "coordinates": [lat, long]
      };

  static bool inComments = false;
}
