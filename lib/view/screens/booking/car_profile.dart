import 'package:flutter/material.dart';
import 'package:ogrety_app/controller/booking_controller.dart';

class CarProfile extends StatefulWidget {
  final String imageUrl, type, name, rate, seats, phone, token;
  final int fromId;
  CarProfile(
      {@required this.fromId,
      @required this.token,
      @required this.imageUrl,
      @required this.type,
      @required this.name,
      @required this.phone,
      @required this.rate,
      @required this.seats});
  @override
  _CarProfileState createState() => _CarProfileState();
}

class Profile {
  final String name;
  final IconData iconData;
  final String title;
  Profile({@required this.iconData, @required this.name, @required this.title});
}

class _CarProfileState extends State<CarProfile> {
  String get srt {
    return BookingController.governoratesModel
        .firstWhere((element) => element.id == widget.fromId)
        .nameEn;
  }

  List<Profile> prof = [];

  @override
  void initState() {
    super.initState();
    prof = [
      Profile(iconData: Icons.person, name: widget.name, title: 'Driver'),
      Profile(iconData: Icons.star, name: widget.rate, title: 'Rate'),
      Profile(iconData: Icons.phone, name: widget.phone, title: 'Mobile'),
      Profile(iconData: Icons.reduce_capacity, name: widget.seats, title: 'Capacity'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xb0000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          widget.imageUrl,
                        ),
                        Text(
                          widget.type.toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            color: const Color(0xff313450),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          srt.toUpperCase() ?? "",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: const Color(0xff313450),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ListView.separated(
                separatorBuilder: (c, i) => Container(
                  height: 10,
                  color: Colors.grey[100],
                ),
                itemCount: prof?.length,
                shrinkWrap: true,
                itemBuilder: (c, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              prof[i].iconData,
                              color: Color(0xFF0052D0),
                              size: 22,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              prof[i].title,
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xff0052d0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          prof[i].name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color(0xff313450),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
