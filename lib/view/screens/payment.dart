import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/view/screens/after_scanning_qr.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:ogrety_app/controller/payment_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/choose_seat.dart';
import 'package:ogrety_app/view/screens/rating.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'forget_password.dart';
import 'dart:ui';
import 'package:get/get.dart';

class WayToPayment extends StatefulWidget {
  final String token;
  WayToPayment({@required this.token});
  @override
  _WayToPayment createState() => _WayToPayment();
}

class _WayToPayment extends State<WayToPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var status = await Permission.camera.request();
                if (status.isDenied) {
                  print('denied');
                  openAppSettings();
                }
                if (status.isGranted) {
                  print('g');
                  Get.to(QrScanner(
                    token: widget.token,
                  ));
                }
              },
              child: Text('Scan Qr'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                Get.offAll(Payment(token: widget.token));
              },
              child: Text('Type code manually'),
            ),
          ],
        ),
      ),
    );
  }
}

class QrScanner extends StatefulWidget {
  final String token;
  QrScanner({@required this.token});
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          result == null
              ? Expanded(
                  flex: 5,
                  // To ensure the Scanner view is properly sizes after rotation
                  // we need to listen for Flutter SizeChanged notification and update controller
                  child: NotificationListener<SizeChangedLayoutNotification>(
                    onNotification: (notification) {
                      Future.microtask(
                          () => controller?.updateDimensions(qrKey));
                      return false;
                    },
                    child: SizeChangedLayoutNotifier(
                      key: const Key('qr-size-notifier'),
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ),
                  ),
                )
              : Text(''),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Barcode data: ${result.code}')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print(result.code);
        result == null
            ? print('no')
            : Get.off(AfterScanningQr(
                token: widget.token,
                code: result.code,
              ));
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class Payment extends StatefulWidget {
  final String token;
  Payment({@required this.token});

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> with SingleTickerProviderStateMixin {
  var _formKey = GlobalKey<FormState>();
  String code, cost;
  FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        UnFocus.unFocus(context);
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width * .04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.offAll(MyTimeline(token: widget.token));
                                },
                                icon: Icon(Icons.arrow_back_ios)),
                            Text(
                              'Payment',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff347CE0)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .021,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * .01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available balance',
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff347CE0)),
                                  ),
                                  SizedBox(height: height * .02),
                                  Text(
                                      '${ProfileController?.profile?.wallet} EGP',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xff347CE0)))
                                ],
                              ),
                              SizedBox(
                                width: width * .3,
                              ),
                              IconButton(
                                  icon: (Icon(
                                    Icons.closed_caption_disabled,
                                    color: Color(0xff347CE0),
                                    size: 70,
                                  )),
                                  onPressed: () async {
                                    // try {
                                    //   await EasyLoading.showToast(
                                    //       'Camera closed',
                                    //       duration: Duration(seconds: 1));
                                    //   widget.controller.pauseCamera();
                                    //   print('camera closed');
                                    // } catch (e) {
                                    //   print(e);
                                    // }
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * .05,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * .04,
                        bottom: height * .2,
                        left: width * .04,
                        right: width * .04),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Color(0xff347CE0))),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: height / 18,
                          right: height / 18,
                          top: height / 25,
                          bottom: height / 25),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: height * .01),
                            child: Text(
                              'Enter the code to pay',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff347CE0),
                                  fontSize: 20),
                            ),
                          ),
                          PinPut(
                            fieldsCount: 5,
                            onChanged: (String val) {
                              code = val;
                            },
                            validator: (String val) {
                              if (val.isEmpty) return 'Code can not be empty';
                              if (val.length != 5) return 'Code not completed';
                              return null;
                            },
                            focusNode: _pinPutFocusNode,
                            submittedFieldDecoration:
                                _pinPutDecoration.copyWith(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            selectedFieldDecoration: _pinPutDecoration,
                            followingFieldDecoration:
                                _pinPutDecoration.copyWith(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Color(0xff347CE0).withOpacity(.5),
                              ),
                            ),
                          ),
                          Container(
                            child: CustomButton(
                              msg: 'Check',
                              onPress: () async {
                                if (_formKey.currentState.validate()) {
                                  await EasyLoading.show(status: 'Checking...');
                                  UnFocus.unFocus(context);
                                  // widget.controller?.dispose();
                                  try {
                                    await PaymentController.checkCarFunc(
                                        token: widget.token, code: code);
                                    if (Urls.errorMessage == 'no' &&
                                        PaymentController.checkCar.type ==
                                            'bus') {
                                      Get.offAll(ChooseSeat(
                                        token: widget.token,
                                        code: code,
                                        numberOfSeat: PaymentController
                                            .checkCar.numberOfSeats,
                                      ));
                                      await EasyLoading.dismiss();
                                    } else if (Urls.errorMessage == 'no' &&
                                        PaymentController.checkCar.type !=
                                            'bus') {
                                      await paymentDialog(context,
                                          cost: cost,
                                          code: code,
                                          token: widget.token,
                                          inBus: false);
                                      Get.offAll(Rating(token: widget.token));
                                    } else {
                                      await EasyLoading.dismiss();
                                      return errorWhileOperation(
                                          Urls.errorMessage, context);
                                    }
                                    await EasyLoading.dismiss();
                                  } catch (e) {
                                    print(e);
                                  }
                                  await EasyLoading.dismiss();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
