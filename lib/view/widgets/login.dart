import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/auth_controller.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/screens/forget_password.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import '../reusable/dialogs.dart';
import '../reusable/myTextField.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String password, phone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                          UnFocus.unFocus(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 45,
                          color: Color(0xff347CE0),
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome \nBack',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff347CE0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Image.asset('images/6.png'),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .9,
                  child: MyTextField(
                    hint: 'mobile number..',
                    label: 'PhoneNumber',
                    prefix: '+2  ',
                    preicon: Icon(
                      Icons.phone_android_outlined,
                      color: Color(0xff347CE0),
                    ),
                    max: 11,
                    textInputType: TextInputType.phone,
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
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .9,
                  child: MyTextField(
                    hint: 'your password..',
                    label: 'Password',
                    preicon: Icon(
                      Icons.lock,
                      color: Color(0xff347CE0),
                    ),
                    whileChange: (val) {
                      password = val;
                    },
                    validate: (String val) {
                      if (val.isEmpty) return 'this filed can\'t be empty';
                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(ForgetPassword());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forget Password ?',
                        style: TextStyle(
                          color: Color(0xff347CE0),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.height * .06,
                  child: RawMaterialButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    fillColor: Color(0xff347CE0),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await EasyLoading.show(status: 'loading');
                        UnFocus.unFocus(context);
                        try {
                          await AuthController.authFunc(
                            password: password,
                            phone: '+2$phone',
                            login: true,
                          );

                          Urls.errorMessage == 'no'
                              ? readyToTimeLine(AuthController.user.token)
                              : errorWhileOperation(Urls.errorMessage, context);
                        } catch (e) {
                          print(e);
                        }
                        await EasyLoading.dismiss();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  readyToTimeLine(String token) async {
    await ProfileController.getProfile(token: token);
    Urls.errorMessage == 'no'
        ? Get.offAll(MyTimeline(
            token: token,
          ))
        : errorWhileOperation(Urls.errorMessage, context);
  }
}
