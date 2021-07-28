import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/auth_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/reusable/myTextField.dart';
import 'package:get/get.dart';
import 'reset_password.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var _formKey = GlobalKey<FormState>();
  String phone;

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        UnFocus.unFocus(context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.04),
                child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 36,
                    color: Color(0xff347CE0),
                    onPressed: () {
                      Navigator.pop(context);
                      UnFocus.unFocus(context);
                    }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(height / 20),
                    child: Text(
                      'Forgot password ?',
                      style: TextStyle(
                          color: Color(0xff347CE0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Enter your phone number bellow',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(' to receive verification code',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.all(height / 40),
                    child: Image.asset('images/7.png'),
                  ),
                  Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(height * .02),
                              child: MyTextField(
                                  hint: 'mobile number..',
                                  label: 'PhoneNumber',
                                  prefix: '+2  ',
                                  preicon: Icon(
                                    Icons.phone_android_outlined,
                                    color: Color(0xff347CE0),
                                  ),
                                  textInputType: TextInputType.number,
                                  max: 11,
                                  whileChange: (val) {
                                    phone = val;
                                  },
                                  validate: (String val) {
                                    if (val.isEmpty) return 'this filed can\'t be empty';
                                    RegExp phoneRegExp = new RegExp(
                                      r"^01[0125][0-9]{8}$",
                                    );
                                    if (phoneRegExp.hasMatch(val)) {
                                      return null;
                                    } else {
                                      return 'Invalid Number';
                                    }
                                  })),
                          Padding(
                            padding: EdgeInsets.all(height * .01),
                            child: Text(
                              'Remember password ? login',
                              style: TextStyle(
                                  color: Color(0xff347CE0), fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                              width: width * 0.30,
                              child: CustomButton(
                                msg: 'Check',
                                onPress: () async {
                                  if (_formKey.currentState.validate()) {
                                    await EasyLoading.show(status: 'Waiting...');
                                    UnFocus.unFocus(context);
                                    try {
                                      await AuthController.forgetPassword(
                                        phone: "+2$phone",
                                      );

                                      Urls.errorMessage == 'no'
                                          ? Get.to(ResetPassword(
                                              phone: "+2$phone",
                                            ))
                                          : errorWhileOperation(
                                              Urls.errorMessage, context);
                                    } catch (e) {
                                      print(e);
                                    }
                                    await EasyLoading.dismiss();
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String msg;
  final VoidCallback onPress;

  CustomButton({this.msg, this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: Color(0xff347CE0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        msg,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
