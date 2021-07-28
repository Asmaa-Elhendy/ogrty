import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogrety_app/controller/booking_controller.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';
import 'package:ogrety_app/view/screens/choose_seat.dart';

import 'cars_inline_inparking.dart';

class ChooseService extends StatefulWidget {
  final String token;
  final int toId, fromId;

  ChooseService(
      {@required this.token, @required this.toId, @required this.fromId});

  @override
  _ChooseServiceState createState() => _ChooseServiceState();
}

class Services {
  final String title;
  final String assetImage;
  Services({@required this.title, @required this.assetImage});
}

class _ChooseServiceState extends State<ChooseService> {
  List<Services> services = [
    Services(title: 'CARS IN\nLINE', assetImage: "images/11.png"),
    Services(title: 'BOOK\nNOW', assetImage: "images/12.png"),
    Services(title: 'CARS IN\nPARKING', assetImage: "images/13.png"),
  ];
  getData() async {
    await EasyLoading.show(status: 'Get all data...');
    await BookingController.getAllCarsInLine(
        token: widget.token, fromId: widget.fromId, toId: widget.toId);
    if (Urls.errorMessage == 'no') {
      await BookingController.getAllCarsInParking(
          token: widget.token, fromId: widget.fromId, toId: widget.toId);
      if (Urls.errorMessage == 'no') {
        await BookingController.getCurrentCar(
            token: widget.token, fromId: widget.fromId, toId: widget.toId);
        if (Urls.errorMessage == 'no') {
          await EasyLoading.dismiss();
        } else {
          await EasyLoading.dismiss();
          await errorWhileOperation(Urls.errorMessage, context).then((value) {
            Navigator.pop(context);
          });
        }
      } else {
        await EasyLoading.dismiss();
        await errorWhileOperation(Urls.errorMessage, context).then((value) {
          Navigator.pop(context);
        });
      }
    } else {
      await EasyLoading.dismiss();
      await errorWhileOperation(Urls.errorMessage, context).then((value) {
        Navigator.pop(context);
      });
    }
    if (EasyLoading.isShow) {
      await EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3085FB),
      body: Urls.errorMessage != 'no'
          ? Center(
              child: Text('Waiting'),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Center(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xfffafafa),
                                border: Border.all(
                                    width: 2.0, color: const Color(0xff347ce0)),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xff347ce0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Choose from the\n available services',
                        style: TextStyle(
                          fontFamily: 'Arial Rounded MT',
                          fontSize: 40,
                          color: const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: services.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        itemBuilder: (c, i) => GestureDetector(
                          onTap: () {
                            switch (i) {
                              case 0:
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => CarsInLineOrInParking(
                                                token: widget.token,
                                                isParking: false,
                                              )));
                                }
                                break;
                              case 1:
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => ChooseSeat(
                                              token: widget.token,
                                              code: BookingController
                                                  .currentCarModel.code,
                                              numberOfSeat: BookingController
                                                  .currentCarModel
                                                  .numberOfSeats)));
                                }
                                break;
                              case 2:
                                {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => CarsInLineOrInParking(
                                                token: widget.token,
                                                isParking: true,
                                              )));
                                }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Container(
                              width: 352,
                              height: 105,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xffffffff),
                                border: Border.all(
                                    width: 1.0, color: const Color(0xff0052d0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xa6000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(services[i].assetImage),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      services[i].title,
                                      textHeightBehavior: TextHeightBehavior(
                                          applyHeightToFirstAscent: false),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff0052d0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 170,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color(0xffffffff),
                            border: Border.all(
                                width: 1.0, color: const Color(0xff347ce0)),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Arial Rounded MT',
                                fontSize: 24,
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
