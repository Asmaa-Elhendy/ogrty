import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/follow_controller.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/openMap.dart';

class FollowRequests extends StatefulWidget {
  final String token;
  FollowRequests({@required this.token});
  @override
  _FollowRequests createState() => _FollowRequests();
}

class _FollowRequests extends State<FollowRequests> {
  getData() async {
    await EasyLoading.show(status: 'Loading');
    await FollowController.fetchAllFollowReq(token: widget.token);
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
                decoration: BoxDecoration(
                    color: Color(0xff347CE0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * .08, left: width * .07, bottom: height * .05),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Get.back();
                            UnFocus.unFocus(context);
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: height * .08, left: width * .08, bottom: height * .05),
                      child: Text(
                        'Notification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              FollowController.fetchAllFollowModel.isEmpty
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
                                      leading: Image.network(
                                        FollowController
                                            .fetchAllFollowModel[i].sender.photo,
                                      ),
                                      title: Text(FollowController
                                          .fetchAllFollowModel[i].sender.username),
                                      subtitle: Text('Click to show map'),
                                      onTap: () {
                                        Get.to(OpenMap(
                                          token: widget.token,
                                          ifISender: false,
                                          id: FollowController
                                              .fetchAllFollowModel[i].sender.id,
                                        ));
                                      },
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Padding(
                                    //       padding: EdgeInsets.only(
                                    //         left: width * .08,
                                    //         top: height * .05,
                                    //         bottom: height * .02,
                                    //       ),
                                    //       child: TextButton(
                                    //         onPressed: () async {
                                    //           await TrustAbleController.updateTrustAble(
                                    //               accept: true,
                                    //               token: widget.token,
                                    //               id: TrustAbleController
                                    //                   .myTrustReqModel[i].id
                                    //                   .toString());
                                    //           TrustAbleController.myTrustReqModel
                                    //               .removeAt(i);
                                    //           setState(() {});
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Icon(
                                    //               Icons.verified_rounded,
                                    //               color: Color(0xff347CE0),
                                    //             ),
                                    //             SizedBox(
                                    //               width: width * .02,
                                    //             ),
                                    //             Text(
                                    //               'Accept',
                                    //               style: TextStyle(
                                    //                 color: Color(0xff347CE0),
                                    //                 fontSize: 15,
                                    //               ),
                                    //             ),
                                    //             SizedBox(
                                    //               width: width * .04,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         style: TextButton.styleFrom(
                                    //           shape: RoundedRectangleBorder(
                                    //               borderRadius: BorderRadius.circular(25),
                                    //               side: BorderSide(
                                    //                   color: Color(0xff347CE0))),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Padding(
                                    //       padding: EdgeInsets.only(
                                    //           left: width * .08,
                                    //           top: height * .05,
                                    //           bottom: height * .02),
                                    //       child: TextButton(
                                    //         onPressed: () async {
                                    //           await TrustAbleController.updateTrustAble(
                                    //               accept: false,
                                    //               token: widget.token,
                                    //               id: TrustAbleController
                                    //                   .myTrustReqModel[i].id
                                    //                   .toString());
                                    //           TrustAbleController.myTrustReqModel
                                    //               .removeAt(i);
                                    //           setState(() {});
                                    //         },
                                    //         child: Row(
                                    //           children: [
                                    //             Icon(
                                    //               Icons.delete,
                                    //               color: Colors.red,
                                    //             ),
                                    //             SizedBox(
                                    //               width: width * .02,
                                    //             ),
                                    //             Text(
                                    //               'Delete',
                                    //               style: TextStyle(
                                    //                 color: Colors.red,
                                    //                 fontSize: 15,
                                    //               ),
                                    //             ),
                                    //             SizedBox(
                                    //               width: width * .04,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         style: TextButton.styleFrom(
                                    //           shape: RoundedRectangleBorder(
                                    //               borderRadius: BorderRadius.circular(25),
                                    //               side: BorderSide(color: Colors.red)),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: FollowController.fetchAllFollowModel.length,
                      ),
                    )
            ],
          ),
        ));
  }
}
