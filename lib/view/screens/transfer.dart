import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/controller/transfer_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/reusable/myTextField.dart';
import 'forget_password.dart';

class Transfer extends StatefulWidget {
  final String token;
  Transfer({@required this.token});
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  String phone, cost;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff347CE0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.05, bottom: height * .02),
              child: Center(
                  child: Text('Balance Services',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30))),
            ),
            Container(
              height: height * .7,
              width: width * .84,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * .03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(
                        '  to :',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff347CE0),
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: MyTextField(
                          hint: 'enter phone number',
                          label: 'phone',
                          whileChange: (value) {
                            phone = value;
                          },
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
                          }),
                    ),
                    Text('  amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff347CE0),
                            fontSize: 20)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: MyTextField(
                          hint: 'enter the amount ..',
                          textInputType: TextInputType.number,
                          label: 'Cost',
                          whileChange: (val) {
                            cost = val;
                            print(cost);
                          },
                          validate: (String val) {
                            if (val.isEmpty) return 'cost can not be empty';
                            return null;
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text('The available balance is :',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff347CE0),
                                fontSize: 20)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(ProfileController?.profile?.wallet?.toString() ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff347CE0),
                                fontSize: 20)),
                      ),
                    ),
                    Center(
                      child: CustomButton(
                        msg: 'Transfer',
                        onPress: () async {
                          try {
                            if (_formKey.currentState.validate()) {
                              await EasyLoading.show(status: 'Transferring ..');
                              await TransferController.transferMoney(
                                  token: widget.token, phone: '+2$phone', cost: cost);
                              Urls.errorMessage == 'no'
                                  ? done('Transferring done')
                                  : errorWhileOperation(Urls.errorMessage, context);
                              await EasyLoading.dismiss();
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

done(message) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    await EasyLoading.showInfo(
      message,
      duration: Duration(seconds: 3),
    );
  });
  await EasyLoading.dismiss();
}
