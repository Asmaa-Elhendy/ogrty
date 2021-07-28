import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/payment_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'myTextField.dart';
import 'package:ogrety_app/view/screens/rating.dart';

Future<void> submitRandomOperation(
    {@required String message,
    @required BuildContext context,
    @required Function func1,
    @required Function func2}) {
  return showCupertinoDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Warning'),
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await func1();
          },
          child: Text(
            'Ok',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
        TextButton(
          onPressed: () {
            func2();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    ),
  );
}

Future<void> errorWhileOperation(errorMessage, BuildContext context) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('What Happen ?'),
            content: Text(errorMessage.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Try Again',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Tell us',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ));
}

Future<void> networkError(BuildContext context) {
  return showCupertinoDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Network error'),
            content: Text('Check your network connection and open the application again'),
            actions: <Widget>[
              TextButton(
                onPressed: () => exit(0),
                child: Text(
                  'CLOSE',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ));
}

Future<void> paymentDialog(BuildContext context,
    {String cost, String code, String token, bool inBus, List<int> seatNumber}) {
  final _formKey = GlobalKey<FormState>();
  UnFocus.unFocus(context);
  return showCupertinoDialog<void>(
      context: context,
      builder: (context) => GestureDetector(
            onTap: () {
              UnFocus.unFocus(context);
            },
            child: AlertDialog(
              title: Text('Pay from your waller'),
              content: Form(
                key: _formKey,
                child: MyTextField(
                    hint: 'your pounds',
                    label: 'Cost',
                    textInputType: TextInputType.number,
                    whileChange: (String val) {
                      cost = val;
                    },
                    validate: (String val) {
                      if (val.isEmpty) return 'cost can not be empty';
                      return null;
                    }),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await EasyLoading.show(status: 'Paying..');
                      UnFocus.unFocus(context);
                      try {
                        await PaymentController.paymentFunc(
                          token: token,
                          code: code,
                          cost: cost,
                          bus: inBus,
                          seatNumber: seatNumber,
                        );
                        Urls.errorMessage == 'no'
                            ? await done(context, 'Payment Done', token: token)
                            : await failed(context, Urls.errorMessage);
                      } catch (e) {
                        print(e);
                      }
                      await EasyLoading.dismiss();
                    }
                  },
                  child: Text(
                    'PAY',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CLOSE',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ));
}

done(context, message, {String token}) async {
  Navigator.pop(context);
  Future.delayed(Duration(milliseconds: 800), () async {
    await EasyLoading.showInfo(
      message,
      duration: Duration(seconds: 3),
    );
  });
  await EasyLoading.dismiss();
  token == null ? print('no token in done method') : Get.offAll(Rating(token: token));
}

failed(context, message) async {
  Navigator.pop(context);
  errorWhileOperation(message, context);
}

mixin UnFocus {
  static FocusScopeNode currentFocus;
  static void unFocus(context) {
    currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
