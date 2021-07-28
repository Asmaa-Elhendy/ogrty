import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/booking_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/booking/choose_service.dart';
import 'package:ogrety_app/view/widgets/componants/text_field.dart';

class GetReady extends StatefulWidget {
  final String token;
  GetReady({@required this.token});

  @override
  _GetReadyState createState() => _GetReadyState();
}

class _GetReadyState extends State<GetReady> {
  String from, to;
  int fromId, toId;
  Future getGoVer() async {
    await EasyLoading.show(status: 'Loading...');
    await BookingController.fetchAllGoVerNoRates(token: widget.token);
    await EasyLoading.dismiss();
    if (Urls.errorMessage == 'no') {
      setState(() {});
    } else {
      setState(() {});
      await errorWhileOperation(Urls.errorMessage, context)
          .then((value) => Navigator.pop(context));
    }
  }

  @override
  void initState() {
    super.initState();
    getGoVer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3085FB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 58.0),
          child: Center(
            child: Urls.errorMessage != 'no'
                ? Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'GOT ERR ${Urls.errorMessage}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 18.0),
                      //     child: InkWell(
                      //       onTap: () {
                      //         Navigator.pop(context);
                      //       },
                      //       child: Container(
                      //         width: 40,
                      //         height: 40,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10.0),
                      //           color: const Color(0xfffafafa),
                      //           border: Border.all(
                      //               width: 2.0, color: const Color(0xff347ce0)),
                      //         ),
                      //         child: Center(
                      //           child: Icon(
                      //             Icons.arrow_back,
                      //             color: Color(0xff347ce0),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      Text(
                        'GET YOUR\nTRIP READY',
                        style: TextStyle(
                          fontFamily: 'Arial Rounded MT',
                          fontSize: 40,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Image.asset(
                        'images/10.png',
                        width: 339.1,
                        height: 125.65,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                          ),
                          color: const Color(0xffffffff),
                          border: Border.all(width: 1.0, color: const Color(0xff2d51fe)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x29000000),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: EntryField(
                            readOnly: true,
                            width: 230.0,
                            prefixIcon: Text("From : "),
                            hintText: from == null ? "Choose One" : from,
                            hintColor: Colors.black,
                            suffixIcon: new DropdownButton(
                              items: BookingController.governoratesModel
                                  .map((e) => DropdownMenuItem(
                                        child: Text(
                                          e.nameAr,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  fromId = val.id;
                                  from = val.nameAr;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                          ),
                          color: const Color(0xffffffff),
                          border: Border.all(width: 1.0, color: const Color(0xff0052d0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: EntryField(
                            readOnly: true,
                            width: 230.0,
                            prefixIcon: Text("To : "),
                            hintText: to == null ? "Choose One" : to,
                            hintColor: Colors.black,
                            suffixIcon: new DropdownButton(
                              items: BookingController.governoratesModel
                                  .map((e) => DropdownMenuItem(
                                        child: Text(
                                          e.nameAr,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  toId = val.id;
                                  to = val.nameAr;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (toId != null && fromId != null) {
                            print(toId);
                            print(fromId);
                            Get.to(ChooseService(
                                token: widget.token, toId: toId, fromId: fromId));
                          } else {
                            await errorWhileOperation('Choose trip', context);
                          }
                        },
                        child: Container(
                          width: 170,
                          height: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color(0xffffffff),
                            border:
                                Border.all(width: 1.0, color: const Color(0xff347ce0)),
                          ),
                          child: Center(
                            child: Text(
                              'Show Available',
                              style: TextStyle(
                                fontFamily: 'Arial Rounded MT',
                                fontSize: 16,
                                color: const Color(0xff0052d0),
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
