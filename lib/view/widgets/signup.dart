import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/auth_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/screens/verify.dart';
import '../reusable/myTextField.dart';
import 'package:get/get.dart';
import '../reusable/dialogs.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String username, password, phone, passwordConfirm;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool agree = false;

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UnFocus.unFocus(context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 45,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Get.back();
                            UnFocus.unFocus(context);
                          })),
                ),
                Text(
                  'Let\'s Go !',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text('create an account to get all features',
                      style: TextStyle(fontSize: 18, color: Colors.black45)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .9,
                  child: MyTextField(
                    hint: 'your name',
                    label: 'Full Name',
                    preicon: Icon(
                      Icons.account_circle,
                      color: Colors.blueAccent,
                    ),
                    whileChange: (val) {
                      username = val;
                    },
                    validate: (String val) {
                      if (val.isEmpty) return 'fill the filed';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .9,
                  child: MyTextField(
                    hint: 'mobile number..',
                    label: 'PhoneNumber',
                    prefix: '+2  ',
                    max: 11,
                    preicon: Icon(
                      Icons.phone_android_outlined,
                      color: Colors.blueAccent,
                    ),
                    textInputType: TextInputType.phone,
                    whileChange: (val) {
                      phone = val;
                      print(phone);
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
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .9,
                  child: MyTextField(
                    hint: 'password ?',
                    label: 'Password',
                    preicon: Icon(
                      Icons.lock,
                      color: Colors.blueAccent,
                    ),
                    whileChange: (val) {
                      password = val;
                    },
                    validate: (String val) {
                      if (val.isEmpty) return 'fill the filed';
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .9,
                  child: MyTextField(
                    hint: 'password ?',
                    label: 'Confirm Password',
                    preicon: Icon(
                      Icons.lock,
                      color: Colors.blueAccent,
                    ),
                    whileChange: (val) {
                      passwordConfirm = val;
                    },
                    validate: (String val) {
                      if (val.isEmpty) return 'fill the filed';
                      if (val != password) return 'password doesn\'t match';
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
                  child: Row(
                    children: [
                      Material(
                        child: Checkbox(
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I accept the policy and terms',
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.height * .06,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        primary: Colors.blue,
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onPressed: agree
                          ? () async {
                              if (_formKey.currentState.validate()) {
                                await EasyLoading.show(status: 'Waiting..');
                                UnFocus.unFocus(context);
                                try {
                                  await AuthController.authFunc(
                                    username: username,
                                    password: password,
                                    phone: '+2$phone',
                                    login: false,
                                  );
                                  Urls.errorMessage == 'no'
                                      ? Get.offAll(Verification(
                                          phone: '+2$phone',
                                          token: AuthController.user.token,
                                          name: username,
                                        ))
                                      : errorWhileOperation(Urls.errorMessage, context);
                                } catch (e) {
                                  print(e);
                                }
                                await EasyLoading.dismiss();
                              }
                            }
                          : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
