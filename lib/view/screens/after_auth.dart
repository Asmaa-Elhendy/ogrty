// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ogrety_app/view/screens/booking/get_ready.dart';
// import 'package:ogrety_app/view/screens/following_requests_screen.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ogrety_app/controller/profile_controller.dart';
// import 'package:ogrety_app/model/database/local.dart';
// import 'package:get/get.dart';
// import 'package:ogrety_app/view/screens/location.dart';
// import 'package:ogrety_app/view/screens/openMap.dart';
// import 'package:ogrety_app/view/screens/payment.dart';
// import 'package:ogrety_app/view/screens/rating.dart';
// import 'package:ogrety_app/view/screens/timeLine.dart';
// import 'package:ogrety_app/view/screens/trackMe.dart';
// import 'package:ogrety_app/view/screens/trackNotification.dart';
// import 'package:ogrety_app/view/screens/transfer.dart';
// import 'package:ogrety_app/view/screens/welcome2.dart';
// import 'addTrustable.dart';
//
// class AfterAuth extends StatelessWidget {
//   final String token, phone;
//   AfterAuth({@required this.token, this.phone});
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback(
//         (_) async => await ProfileController.getProfile(token: token));
//     return Scaffold(
//       drawer: Drawer(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextButton.icon(
//                   label: Text('Logout'),
//                   icon: Icon(
//                     Icons.logout,
//                   ),
//                   onPressed: () {
//                     DataInLocal.saveInLocal(token: '0');
//                     Get.offAll(Welcome2());
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('Payment'),
//                   icon: Icon(Icons.payment),
//                   onPressed: () async {
//                     var status = await Permission.camera.request();
//                     if (status.isDenied) {
//                       print('denied');
//                       openAppSettings();
//                     }
//                     if (status.isGranted) {
//                       print('g');
//                       Get.to(WayToPayment(
//                         token: token,
//                       ));
//                     }
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('Transfer'),
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     Get.to(Transfer(token: token));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('Timeline'),
//                   icon: Icon(Icons.timeline),
//                   onPressed: () {
//                     Get.to(MyTimeline(token: token));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('Rating'),
//                   icon: Icon(Icons.star),
//                   onPressed: () {
//                     Get.to(Rating(
//                       token: token,
//                     ));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('Add trustAble'),
//                   icon: Icon(Icons.phone),
//                   onPressed: () {
//                     Get.to(AddTrustAble(
//                       token: token,
//                     ));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('My requests'),
//                   icon: Icon(Icons.mail),
//                   onPressed: () {
//                     Get.to(TrustRequest(token: token));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('My trust people'),
//                   icon: Icon(Icons.people),
//                   onPressed: () {
//                     Get.to(TrackMe(token: token));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('location'),
//                   icon: Icon(Icons.eight_k),
//                   onPressed: () {
//                     Get.to(GetLocation(token: token));
//                   },
//                 ),
//                 // TextButton.icon(
//                 //   label: Text('Map'),
//                 //   icon: Icon(Icons.add_location),
//                 //   onPressed: () {
//                 //     Get.to(OpenMap(
//                 //       token: token,
//                 //     ));
//                 //   },
//                 // ),
//                 TextButton.icon(
//                   label: Text('BOOKING'),
//                   icon: Icon(Icons.bookmark),
//                   onPressed: () {
//                     Get.to(GetReady(token: token));
//                   },
//                 ),
//                 TextButton.icon(
//                   label: Text('FOLLOW REQ'),
//                   icon: Icon(Icons.bookmark),
//                   onPressed: () {
//                     Get.to(FollowRequests(token: token));
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       appBar: AppBar(
//         title: Text('PTOS'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Center(
//             child: Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(token),
//             ),
//           ),
//           // ElevatedButton(
//           //     onPressed: () async {
//           //       await showCommentsModal(context, token: token, postId: 8);
//           //     },
//           //     child: Text('Show Model'))
//         ],
//       ),
//     );
//   }
// }
