import 'package:flutter/material.dart';
import 'package:ogrety_app/controller/booking_controller.dart';
import 'package:ogrety_app/view/screens/booking/car_profile.dart';

class CarsInLineOrInParking extends StatefulWidget {
  final String token;
  final bool isParking;
  CarsInLineOrInParking({@required this.token, @required this.isParking});

  @override
  _CarsInLineOrInParkingState createState() => _CarsInLineOrInParkingState();
}

class _CarsInLineOrInParkingState extends State<CarsInLineOrInParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Cars In ${widget.isParking ? "Parking" : "Line"}"),
      ),
      body: ListView.builder(
        itemBuilder: (c, i) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => CarProfile(
                          token: widget.token,
                          name: widget.isParking
                              ? BookingController.carsInParkingModel[i].owner.username
                              : BookingController.carsInLineModel[i].owner.username,
                          phone: widget.isParking
                              ? BookingController.carsInParkingModel[i].owner.phone
                              : BookingController.carsInLineModel[i].owner.phone,
                          fromId: widget.isParking
                              ? BookingController.carsInParkingModel[i].from
                              : BookingController.carsInLineModel[i].from,
                          imageUrl: widget.isParking ? 'images/14.png' : 'images/15.png',
                          rate: widget.isParking
                              ? BookingController.carsInParkingModel[i].owner.rating
                                  .toString()
                              : BookingController.carsInLineModel[i].owner.rating
                                  .toString(),
                          seats: widget.isParking
                              ? BookingController.carsInParkingModel[i].numberOfSeats
                                  .toString()
                              : BookingController.carsInLineModel[i].numberOfSeats
                                  .toString(),
                          type: widget.isParking
                              ? BookingController.carsInParkingModel[i].type
                              : BookingController.carsInLineModel[i].type,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Container(
              width: 370,
              height: 176,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x42000000),
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.isParking ? 'images/14.png' : 'images/15.png',
                      width: 72,
                      height: 141,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Model : ${widget.isParking ? BookingController.carsInParkingModel[i].type : BookingController.carsInLineModel[i].type}\nCapacity : ${widget.isParking ? BookingController.carsInParkingModel[i].numberOfSeats : BookingController.carsInLineModel[i].numberOfSeats} Person\nCode : ${widget.isParking ? BookingController.carsInParkingModel[i].code : BookingController.carsInLineModel[i].code}\nRate : ${widget.isParking ? BookingController.carsInParkingModel[i].owner.rating : BookingController.carsInLineModel[i].owner.rating} ',
                      style: TextStyle(
                        fontFamily: 'Arial Rounded MT',
                        fontSize: 21,
                        color: const Color(0xff0052d0),
                        fontWeight: FontWeight.w700,
                        height: 1.5238095238095237,
                      ),
                      textHeightBehavior:
                          TextHeightBehavior(applyHeightToFirstAscent: false),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        itemCount: widget.isParking
            ? BookingController.carsInParkingModel.length
            : BookingController.carsInLineModel.length,
      ),
    );
  }
}
