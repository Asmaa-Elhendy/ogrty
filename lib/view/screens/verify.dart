import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/auth_controller.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/screens/forget_password.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import '../reusable/dialogs.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Verification extends StatefulWidget {
  final String phone, token, name;

  Verification({@required this.phone, @required this.token, this.name});

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  var _formKey = GlobalKey<FormState>();
  String code;
  FocusNode _pinPutFocusNode = FocusNode();
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(height / 13),
                  child: Text(
                    'Verify phone number ',
                    style: TextStyle(
                      color: Color(0xff347CE0),
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Text(widget.phone,
                    style:
                        TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(height / 18),
                        child: PinPut(
                          fieldsCount: 6,
                          onChanged: (String val) {
                            code = val;
                          },
                          validator: (String val) {
                            if (val.isEmpty) return 'Code can not be empty';
                            return null;
                          },
                          focusNode: _pinPutFocusNode,
                          submittedFieldDecoration: _pinPutDecoration.copyWith(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          selectedFieldDecoration: _pinPutDecoration,
                          followingFieldDecoration: _pinPutDecoration.copyWith(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: Colors.deepPurpleAccent.withOpacity(.5),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ' Didn\'t receive code?',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () async {
                          await EasyLoading.showToast('Waiting');
                          UnFocus.unFocus(context);
                          try {
                            await AuthController.forgetPassword(
                              phone: widget.phone,
                            );
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
                      Padding(
                        padding: EdgeInsets.all(height / 25),
                        child: Container(
                          width: width * 0.30,
                          child: CustomButton(
                            msg: 'verify',
                            onPress: () async {
                              if (_formKey.currentState.validate()) {
                                await EasyLoading.show(status: 'Waiting..');
                                try {
                                  await AuthController.verifyFunc(
                                    phone: widget.phone,
                                    code: code,
                                  );
                                  Urls.errorMessage == 'no'
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: width * .4,
                                              height: height * .2,
                                              child: AlertDialog(
                                                  content:
                                                      SingleChildScrollView(
                                                child:
                                                    Column(children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        height * .01),
                                                    child: Icon(
                                                      Icons
                                                          .verified_user_rounded,
                                                      color: Colors.blue,
                                                      size: 45,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Verified!',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  Text(
                                                    'your account have successfully verified',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .05,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .4,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .06,
                                                    child: RawMaterialButton(
                                                      child: Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      fillColor: Colors.blue,
                                                      onPressed: () {
                                                        readyToTimeLine(
                                                            widget.token);
                                                      },
                                                    ),
                                                  ),
                                                ]),
                                              )),
                                            );
                                          })
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
                      ),
                    ],
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
    await EasyLoading.show(status: 'Getting you ready');
    await ProfileController.getProfile(token: token);
    await EasyLoading.dismiss();
    Urls.errorMessage == 'no'
        ? Get.offAll(MyTimeline(
            token: token,
          ))
        : errorWhileOperation(Urls.errorMessage, context);
  }
}
