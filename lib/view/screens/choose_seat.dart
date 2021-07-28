// import 'package:flutter/material.dart';
// import 'package:multi_select_item/multi_select_item.dart';
// import 'package:ptos/view/reusable/dialogs.dart';
// import 'package:get/get.dart';
// import 'package:ptos/view/screens/after_auth.dart';
// import 'package:ptos/view/screens/rating.dart';
//
// class ChooseSeat extends StatefulWidget {

//   @override
//   _ChooseSeatState createState() => new _ChooseSeatState();
// }
//
// class _ChooseSeatState extends State<ChooseSeat> {
//   List mainList;
//   MultiSelectController controller = new MultiSelectController();
//
//   @override
//   void initState() {
//     mainList = List(widget.numberOfSeat);
//     super.initState();
//     controller.disableEditingWhenNoneSelected = true;
//     controller.set(mainList.length);
//   }
//
//   // void add() {
//   //   mainList.add({"key": "${mainList.length + 1}"});
//   //
//   //   setState(() {
//   //     controller.set(mainList.length);
//   //   });
//   // }
//
//   // void delete() {
//   //   var list = controller.selectedIndexes;
//   //   list.sort((b, a) =>
//   //       a.compareTo(b)); //reoder from biggest number, so it wont error
//   //   list.forEach((element) {
//   //     mainList.removeAt(element);
//   //   });
//   //
//   //   setState(() {
//   //     controller.set(mainList.length);
//   //   });
//   // }
//
//   void selectAll() {
//     setState(() {
//       controller.toggleAll();
//     });
//   }
//

//   String cost;
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         var before = !controller.isSelecting;
//         setState(() {
//           controller.deselectAll();
//         });
//         return before;
//       },
//       child: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Selected ${controller.selectedIndexes.length}  ' +
//               controller.selectedIndexes.toString()),
//           // actions: [
//           //   controller.isSelecting
//           //       ? IconButton(
//           //           icon: Icon(Icons.select_all),
//           //           onPressed: selectAll,
//           //         )
//           //       : Text(''),
//           //   IconButton(
//           //     onPressed: () async {
//           //       await paying();
//           //     },
//           //     icon: Icon(Icons.add),
//           //   ),
//           // ],
//           actions: (controller.isSelecting)
//               ? [
//                   IconButton(
//                     icon: Icon(Icons.select_all),
//                     onPressed: selectAll,
//                   ),
//                   IconButton(
//                     onPressed: () async {
//                       await paying();
//                     },
//                     icon: Icon(Icons.add),
//                   ),
//                 ]
//               : [],
//         ),
//         body: GridView.builder(
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//           itemCount: mainList.length,
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {},
//               child: MultiSelectItem(
//                 isSelecting: controller.isSelecting,
//                 onSelected: () {
//                   setState(() {
//                     controller.toggle(index);
//                   });

//                 },
//                 child: Container(
//                   child: ListTile(
//                     title: new Text(" Title"),
//                     subtitle: new Text("Description"),
//                   ),
//                   decoration: controller.isSelected(index)
//                       ? new BoxDecoration(
//                           color: Colors.grey[300],
//                         )
//                       : new BoxDecoration(),
//                 ),
//               ),
//             );
//           },
//         ),
//         // floatingActionButton: new FloatingActionButton(
//         //   onPressed: add,
//         //   tooltip: 'Increment',
//         //   child: new Icon(Icons.add),
//         // ),
//       ),
//     );
//   }
//

// }

import 'package:flutter/material.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:get/get.dart';
import 'package:ogrety_app/controller/profile_controller.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';

class ChooseSeat extends StatefulWidget {
  final String token, code;
  final int numberOfSeat;
  ChooseSeat(
      {@required this.token, @required this.code, @required this.numberOfSeat});
  @override
  _ChooseSeatState createState() => new _ChooseSeatState();
}

class _ChooseSeatState extends State<ChooseSeat> {
  List mainList;
  MultiSelectController controller = new MultiSelectController();
  String cost;
  List<int> list = [];
  List<int> list2 = [];
  @override
  void initState() {
    super.initState();
    print(widget.numberOfSeat);
    mainList = List.generate(widget.numberOfSeat, (index) => index);
    controller.disableEditingWhenNoneSelected = true;
    controller.set(mainList.length);
    print(mainList);
  }

  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
  }

  paying() async {
    for (int i = 0; i < list.length; i++) {
      int item = list[i] + 1;
      list2.add(item);
    }
    print(list2);
    await paymentDialog(context,
        code: widget.code,
        cost: cost,
        token: widget.token,
        seatNumber: list2,
        inBus: true);
    Future.delayed(Duration(seconds: 2), () {
      list2.clear();
      print(list2);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        var before = !controller.isSelecting;
        setState(() {
          controller.deselectAll();
        });
        return before;
      },
      child: new Scaffold(
        backgroundColor: Color(0xff347CE0),
        body: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * .03, left: width * .05),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
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
                            top: height * .03, left: width * .08),
                        child: Text(
                          'Choose seat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * .01,
                            left: width * .08,
                            bottom: height * .01),
                        child: Text(
                          'your Selected Seat ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * .1,
                      ),
                      controller.selectedIndexes.length == 0
                          ? Icon(
                              Icons.event_seat,
                              color: Colors.white,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.select_all,
                                color: Colors.white,
                              ),
                              onPressed: selectAll,
                            ),
                      SizedBox(
                        width: width * .05,
                      ),
                      Text(
                        '${controller.selectedIndexes.length} ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Color(0xff347CE0),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
            ),
            Container(
              width: width * .05,
              height: height * .05,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: TextButton(
                onPressed: controller.selectedIndexes.length == 0
                    ? null
                    : () async {
                        await paying();
                      },
                child: Text('Pay'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: height * .05,
                  left: width * .17,
                  right: width * .17,
                  bottom: height * .03),
              child: Container(
                height: height - 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: mainList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: MultiSelectItem(
                        isSelecting: controller.isSelecting,
                        onSelected: () {
                          setState(() {
                            controller.toggle(index);
                          });
                          list = controller.selectedIndexes;
                          print(list);
                        },
                        child: Container(
                          child: Icon(
                            Icons.event_seat_outlined,
                            size: 45,
                            color: Colors.redAccent,
                          ),
                          decoration: controller.isSelected(index)
                              ? new BoxDecoration(
                                  color: Colors.grey[300],
                                )
                              : new BoxDecoration(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: width * .05,
              height: height * .17,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Center(
                child: Text(
                  'Total Balance : ${ProfileController?.profile?.wallet ?? "412"} ',
                  style: TextStyle(
                    color: Color(0xff347CE0),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
