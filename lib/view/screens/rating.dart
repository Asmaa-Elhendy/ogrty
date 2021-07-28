import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/payment_controller.dart';
import 'package:ogrety_app/controller/rating_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import 'forget_password.dart';

class Rating extends StatefulWidget {
  final String token;
  Rating({@required this.token});
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double rating = 3.0;
  String feedback;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        UnFocus.unFocus(context);
      },
      child: Scaffold(
        backgroundColor: Color(0xff347CE0),
        body: ListView(
          children: [
            Container(
              height: height,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      // crossAxisAlignment:,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.offAll(MyTimeline(token: widget.token));
                            }),
                        SizedBox(
                          width: width * .24,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: height * .03, top: height * .065),
                          child: Text(
                            'Rate Us',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    Image.asset('images/rate2.png'),
                    SizedBox(
                      height: height * .01,
                    ),
                    Container(
                        width: width,
                        height: height - 250,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      'Driver\'s Name',
                                      style: TextStyle(
                                          color: Color(0xff347CE0),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                      'Rate your ride',
                                      style: TextStyle(
                                          color: Color(0xff347CE0),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RatingBar.builder(
                                    initialRating: rating,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      this.rating = rating;
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text(
                                      'Give us a feedback',
                                      style: TextStyle(
                                          color: Color(0xff347CE0),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(
                                          right: width * .02,
                                          left: width * .02,
                                          bottom: height * .02),
                                      height: height * .16,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        child: TextField(
                                          cursorHeight: 50,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Leave your comment ......',
                                            border: InputBorder.none,
                                          ),
                                          maxLines: 3,
                                          onChanged: (value) {
                                            feedback = value;
                                          },
                                        ),
                                      )),
                                  CustomButton(
                                    msg: 'Rate',
                                    onPress: () async {
                                      print(rating);
                                      try {
                                        await EasyLoading.show(
                                            status: 'Rating...');
                                        await RatingController.ratingDriver(
                                          id: PaymentController
                                              .paymentModel.driver,
                                          token: widget.token,
                                          rating: rating.round(),
                                          feedback: feedback,
                                        );
                                        Urls.errorMessage == 'no'
                                            ? done('Thanks for rating',
                                                widget.token)
                                            : errorWhileOperation(
                                                Urls.errorMessage, context);
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

done(message, token) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    await EasyLoading.showInfo(
      message,
      duration: Duration(seconds: 2),
    );
  });
  Get.offAll(MyTimeline(token: token));
  await EasyLoading.dismiss();
}
