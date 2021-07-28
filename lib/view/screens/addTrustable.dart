import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/trustable_controller.dart';
import 'package:ogrety_app/view/screens/trackMe.dart';
import 'dart:ui';
import '../../controller/urls.dart';
import '../reusable/dialogs.dart';
import '../reusable/myTextField.dart';

class AddTrustAble extends StatefulWidget {
  final String token;
  AddTrustAble({@required this.token});
  @override
  _AddTrustAbleState createState() => _AddTrustAbleState();
}

class _AddTrustAbleState extends State<AddTrustAble> {
  String phone;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height * .23,
            decoration: BoxDecoration(
              color: Color(0xff347CE0),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [
                  SizedBox(
                    width: width * .08,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  SizedBox(
                    width: width * .15,
                  ),
                  Text(
                    'Add Trust ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
                  ),
                ]),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * .07, bottom: height * .02),
            child: Text(
              'Trustable request',
              style: TextStyle(
                  color: Color(0xff347CE0), fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Text('please enter number you can trust on him'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: MyTextField(
              hint: 'Phone number',
              label: 'Phone number',
              textInputType: TextInputType.number,
              prefix: '+2  ',
              preicon: Icon(
                Icons.phone_android_outlined,
                color: Color(0xff347CE0),
              ),
              max: 11,
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
              onSubmit: (val) async {
                await EasyLoading.show(status: 'Sending..');
                try {
                  await TrustAbleController.addTrustAble(
                      token: widget.token, phone: "+2$phone");
                  await EasyLoading.dismiss();
                  Urls.errorMessage == 'no'
                      ? done(context, 'Request Was Sent Successfully')
                      : errorWhileOperation(Urls.errorMessage, context);
                } catch (e) {
                  print(e);
                }
              },
              whileChange: (val) {
                phone = val;
                print(phone);
              },
            ),
          ),
          Container(
            width: 100,
            child: ElevatedButton(
                onPressed: () async {
                  await EasyLoading.show(status: 'Sending..');
                  try {
                    await TrustAbleController.addTrustAble(
                        token: widget.token, phone: "+2$phone");
                    await EasyLoading.dismiss();
                    Urls.errorMessage == 'no'
                        ? done(context, 'Request Was Sent Successfully')
                        : errorWhileOperation(Urls.errorMessage, context);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Add')),
          )
        ],
      ),
    );
  }

  done(context, message) async {
    Future.delayed(Duration(milliseconds: 500), () async {
      await EasyLoading.showInfo(
        message,
        duration: Duration(seconds: 3),
      );
    });
    Get.offAll(TrackMe(token: widget.token));
    await EasyLoading.dismiss();
  }
}
