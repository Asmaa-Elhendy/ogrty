import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/payment_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/rating.dart';
import 'choose_seat.dart';

class AfterScanningQr extends StatefulWidget {
  final String token, code;
  AfterScanningQr({@required this.token, @required this.code});
  @override
  _AfterScanningQrState createState() => _AfterScanningQrState();
}

class _AfterScanningQrState extends State<AfterScanningQr> {
  String cost;
  doPayment() async {
    await EasyLoading.show(status: 'Checking...');
    try {
      await PaymentController.checkCarFunc(
          token: widget.token, code: widget.code);
      if (Urls.errorMessage == 'no' &&
          PaymentController.checkCar.type == 'bus') {
        Get.offAll(ChooseSeat(
          token: widget.token,
          code: widget.code,
          numberOfSeat: PaymentController.checkCar.numberOfSeats,
        ));
        await EasyLoading.dismiss();
      } else if (Urls.errorMessage == 'no' &&
          PaymentController.checkCar.type != 'bus') {
        await paymentDialog(context,
            cost: cost, code: widget.code, token: widget.token, inBus: false);
        Get.offAll(Rating(token: widget.token));
      } else {
        await EasyLoading.dismiss();
        return errorWhileOperation(Urls.errorMessage, context);
      }
      await EasyLoading.dismiss();
    } catch (e) {
      print(e);
    }
    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    doPayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode : ${widget.code}'),
      ),
      body: Center(child: Text('Barcode : ${widget.code}')),
    );
  }
}
