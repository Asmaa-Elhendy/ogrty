import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/auth_controller.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/reusable/myTextField.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import 'forget_password.dart';

class ResetPassword extends StatefulWidget {
  final String phone;

  ResetPassword({@required this.phone});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _formKey = GlobalKey<FormState>();
  String code, password;

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: height * .04, top: height * .04),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 36,
                      color: Color(0xff347CE0),
                      onPressed: () {
                        Navigator.pop(context);
                        UnFocus.unFocus(context);
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(height * .01),
                child: Text(
                  'Create new password',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(height * .015),
                child: Text(
                  'the new password must be different',
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(height * .012),
                        child: MyTextField(
                          label: 'Code',
                          hint: 'code',
                          textInputType: TextInputType.number,
                          preicon: Icon(
                            Icons.work_outline,
                            color: Color(0xff347CE0),
                          ),
                          suffixicon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Color(0xff347CE0),
                          ),
                          whileChange: (String val) {
                            code = val;
                          },
                          validate: (String val) {
                            if (val.isEmpty) return 'CODE !!';
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(height * .012),
                        child: MyTextField(
                          label: 'Confirm password',
                          hint: 'New password',
                          preicon: Icon(
                            Icons.work_outline,
                            color: Color(0xff347CE0),
                          ),
                          suffixicon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Color(0xff347CE0),
                          ),
                          whileChange: (val) {
                            password = val;
                          },
                          validate: (String val) {
                            if (val.isEmpty)
                              return 'this filed can\'t be empty';
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * .08,
                      ),
                      Container(
                        width: width * 0.30,
                        height: height * .06,
                        child: CustomButton(
                          msg: 'Save',
                          onPress: () async {
                            if (_formKey.currentState.validate()) {
                              await EasyLoading.show(status: 'Reset...');
                              UnFocus.unFocus(context);
                              try {
                                await AuthController.resetPassword(
                                  code: code,
                                  phone: widget.phone,
                                  password: password,
                                );

                                Urls.errorMessage == 'no'
                                    ? readyToTimeLine(AuthController.user.token)
                                    : errorWhileOperation(
                                        Urls.errorMessage, context);
                              } catch (e) {
                                print(e);
                              }
                              await EasyLoading.dismiss();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Text(
                        ' Didn\'t receive code?',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          await EasyLoading.showToast('Waiting');
                          try {
                            await AuthController.forgetPassword(
                                phone: widget.phone);
                          } catch (e) {
                            await EasyLoading.showToast(
                                'Error While sent code');
                            print(e);
                          }
                          await EasyLoading.showToast('Code sent');
                        },
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            color: Color(0xff347CE0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
