import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/model/database/local.dart';
import 'package:ogrety_app/view/screens/welcome2.dart';
import 'package:get/get.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataInLocal.useValueToNavigate(context);
    return Scaffold(
      backgroundColor: Color(0xff347CE0),
      body: Padding(
        padding: EdgeInsets.all(height * .04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * .11,
            ),
            Image.asset(
              'images/1.png',
              width: width * .8,
              height: height * .10,
            ),
            Padding(
              padding: EdgeInsets.all(height * .01),
              child: Image.asset('images/9.png'),
            ),
            Padding(
              padding: EdgeInsets.all(height * .01),
              child: Text('Your ride, on demande',
                  style: TextStyle(color: Colors.white, fontSize: 21)),
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                  TextSpan(
                    text: 'Whether you\'re headed to work, the airport, or out on the ',
                  ),
                  TextSpan(
                      text: 'town, Uber connects you with a reliable ride in minutes'),
                  TextSpan(text: ' One tap and a car comes directly to you.'),
                ])),
            SizedBox(
              height: height * .11,
            ),
            Center(
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () async {
                bool network = await Urls.checkNetworkError(context);
                network ? print('no internet') : Get.off(Welcome2());
              },
              child: Text(
                "GET START",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
