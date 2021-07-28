import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/trustable_controller.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';

import 'addTrustable.dart';

class TrustRequest extends StatefulWidget {
  final String token;
  TrustRequest({@required this.token});
  @override
  _TrustRequest createState() => _TrustRequest();
}

class _TrustRequest extends State<TrustRequest> {
  getData() async {
    await EasyLoading.show(status: 'Loading');
    await TrustAbleController.fetchMyTrustReq(token: widget.token);
    await EasyLoading.dismiss();
    setState(() {});
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
    return GestureDetector(
        onTap: () {
          UnFocus.unFocus(context);
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                    color: Color(0xff347CE0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                          UnFocus.unFocus(context);
                        }),
                    Text(
                      'Trust Req',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(AddTrustAble(
                          token: widget.token,
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 0.5)),
                          child: Text(
                            'Add Trust Person',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              TrustAbleController.myTrustReqModel.isEmpty
                  ? Center(
                      child: Text(EasyLoading.isShow ? 'load' : 'No Req For Now'),
                    )
                  : Container(
                      width: width,
                      height: height - 340,
                      child: ListView.builder(
                        itemBuilder: (c, i) {
                          return Container(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: width * .02, right: width * .02),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white,
                                elevation: 10,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Image.network(TrustAbleController
                                          .myTrustReqModel[i].requester.photo),
                                      title: Text(
                                        TrustAbleController
                                            .myTrustReqModel[i].requester.username,
                                      ),
                                      subtitle: Text('Sent a follow request '),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: width * .08,
                                            top: height * .05,
                                            bottom: height * .02,
                                          ),
                                          child: TextButton(
                                            onPressed: () async {
                                              await TrustAbleController.updateTrustAble(
                                                  accept: true,
                                                  token: widget.token,
                                                  id: TrustAbleController
                                                      .myTrustReqModel[i].id
                                                      .toString());
                                              TrustAbleController.myTrustReqModel
                                                  .removeAt(i);
                                              setState(() {});
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  color: Color(0xff347CE0),
                                                ),
                                                SizedBox(
                                                  width: width * .02,
                                                ),
                                                Text(
                                                  'Accept',
                                                  style: TextStyle(
                                                    color: Color(0xff347CE0),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * .04,
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25),
                                                  side: BorderSide(
                                                      color: Color(0xff347CE0))),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * .08,
                                              top: height * .05,
                                              bottom: height * .02),
                                          child: TextButton(
                                            onPressed: () async {
                                              await TrustAbleController.updateTrustAble(
                                                  accept: false,
                                                  token: widget.token,
                                                  id: TrustAbleController
                                                      .myTrustReqModel[i].id
                                                      .toString());
                                              TrustAbleController.myTrustReqModel
                                                  .removeAt(i);
                                              setState(() {});
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: width * .02,
                                                ),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * .04,
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25),
                                                  side: BorderSide(color: Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: TrustAbleController.myTrustReqModel.length,
                      ),
                    )
            ],
          ),
        ));
  }
}
