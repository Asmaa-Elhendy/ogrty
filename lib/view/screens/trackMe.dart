import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/follow_controller.dart';
import 'package:ogrety_app/controller/trustable_controller.dart';
import 'dart:ui';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/openMap.dart';
import 'package:ogrety_app/view/screens/timeLine.dart';
import 'package:ogrety_app/view/screens/trackNotification.dart';

import 'following_requests_screen.dart';

class TrackMe extends StatefulWidget {
  final String token;
  TrackMe({@required this.token});
  @override
  _TrackMeState createState() => _TrackMeState();
}

class _TrackMeState extends State<TrackMe> {
  getData() async {
    await EasyLoading.show(status: 'Loading..');
    await TrustAbleController.fetchMyTrustUsers(token: widget.token);
    await EasyLoading.dismiss();
    Urls.errorMessage == 'no'
        ? setState(() {})
        : errorWhileOperation(Urls.errorMessage, context)
            .then((value) => Navigator.pop(context));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Stack(children: [
                Container(
                  height: height * .3,
                  width: width,
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Container(
                  width: width,
                  height: height * .23,
                  decoration: BoxDecoration(
                    color: Color(0xff347CE0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (C) => MyTimeline(token: widget.token)));
                              }),
                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Text(
                              'Track Me ',
                              style: TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white, width: 0.5)),
                              child: TextButton(
                                  onPressed: () {
                                    Get.to(TrustRequest(token: widget.token));
                                  },
                                  child: Text(
                                    'My Trust Req',
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: width * .1,
                  right: width * .1,
                  top: height * .19,
                  child: InkWell(
                    onTap: () {
                      Get.to(FollowRequests(
                        token: widget.token,
                      ));
                    },
                    child: Container(
                      width: width * .85,
                      height: height * .07,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(.5), blurRadius: 7.0)
                          ],
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          'Show Follow Req',
                          style: TextStyle(
                              color: Color(0xff347CE0),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
              TrustAbleController.myTrustModel.isEmpty
                  ? Text('No Users')
                  : Container(
                      height:
                          MediaQuery.of(context).size.height - 400, //to use screen size
                      child: ListView.builder(
                        itemCount: TrustAbleController.myTrustModel.length,
                        itemBuilder: (c, i) {
                          return CustomListTile(
                            name: TrustAbleController.myTrustModel[i].recipient.username,
                            imgPath: TrustAbleController.myTrustModel[i].recipient.photo,
                            token: widget.token,
                            id: TrustAbleController.myTrustModel[i].recipient.id,
                          );
                        },
                      )),
              // CustomButton(
              //   msg: 'Add new',
              //   onPress: () {},
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String imgPath;
  final String name;
  final String token;
  final int id;
  CustomListTile({this.name, this.imgPath, @required this.token, @required this.id});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: height * .01, left: width * .02),
        child: Row(
          children: [
            // CircleAvatar(  //radius:3
            //  // width: width*.15 ,
            //  //  height: height*.2,
            //   child:  Image.asset(imgPath)
            // ),
            Container(
              height: height * .05,
              width: width * .13,
              child: Image.network(imgPath),
            ),
            SizedBox(
              width: width * .033,
            ),
            Container(
              width: width * .5,
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xff347CE0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () async {
                await EasyLoading.show(status: 'Sending....');
                await FollowController.followMe(token: token, id: id);
                await EasyLoading.dismiss();
                Urls.errorMessage == 'no'
                    ? Get.to(OpenMap(
                        token: token,
                        ifISender: true,
                        id: null,
                      ))
                    : errorWhileOperation(Urls.errorMessage, context);
              },
              child: Text(
                'Follow Me',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
