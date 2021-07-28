import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reusable/dialogs.dart';

class Likes extends StatefulWidget {
  @override
  _LikesState createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        UnFocus.unFocus(context);
      },
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .07,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              onPressed: () {
                                Get.back();
                                UnFocus.unFocus(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                size: 40,
                                color: Color(0xff347CE0),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "likes ",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: TextField(
                      controller: null,
                      autofocus: false,
                      style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'search',
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: width * .12, left: width * .09),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage("images/3.png"),
                          radius: 25),
                      title: Text(
                        'user name',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.more_horiz,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: width * .12, left: width * .09),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage("images/3.png"),
                          radius: 25),
                      title: Text(
                        'user name',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.more_horiz,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: width * .12, left: width * .09),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage("images/3.png"),
                          radius: 25),
                      title: Text(
                        'user name',
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.more_horiz,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
