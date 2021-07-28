import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class DataInLocal {
  static Future<void> saveInLocal({@required String token, phone}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = 'token';
    final String value = token;
    final String pKey = 'phone';
    final String pValue = phone;
    prefs.setString(key, value);
    prefs.setString(pKey, pValue);
    print('value was stored');
  }

  static Future<String> readTokenFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = 'token';
    final String value = prefs.get(key) ?? '0';
    print('reading from local , token is : $value ');
    return value;
  }

  static Future<void> useValueToNavigate(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = 'token';
    final String value = prefs.get(key) ?? '0';
    final String pKey = 'phone';
    final String pValue = prefs.get(pKey) ?? '0';
    if (value != '0' && pValue != '0') {
      await EasyLoading.show(status: 'Refreshing');
      await ProfileController.getProfile(token: value);
      await EasyLoading.dismiss();
      Urls.errorMessage == 'no'
          ? Get.offAll(MyTimeline(
              token: value,
            ))
          : errorWhileOperation(Urls.errorMessage, context);
    }
    // Get.off(AfterAuth(
    //   token: value,
    //   phone: pValue,
    // ));
    print('token in database : $value');
  }
}
