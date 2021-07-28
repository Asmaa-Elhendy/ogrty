import 'package:flutter/material.dart';
import 'package:ogrety_app/view/widgets/login.dart';
import '../widgets/signup.dart';
import 'package:get/get.dart';

class Welcome2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            height: height,
            width: width,
            padding: EdgeInsets.all(height * .02),
            color: Color(0xff347CE0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('images/5.png'),
                  Image.asset('images/8.png'),
                  SizedBox(
                    height: height * .1,
                  ),
                  Container(
                    width: width * 0.27,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(SignUp());
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Color(0xff18437E), fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    width: width * .27,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: height * .02),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(Login());
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Color(0xff18437E), fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'HELP ? ',
                    style: TextStyle(color: Colors.white),
                  )
                ])));
  }
}
