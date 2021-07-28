import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ogrety_app/controller/tracking_controllerr.dart';
import 'package:ogrety_app/controller/urls.dart';
import 'package:ogrety_app/view/reusable/dialogs.dart';

class OpenMap extends StatefulWidget {
  final String token;
  final bool ifISender;
  final int id;
  OpenMap({@required this.token, @required this.ifISender, @required this.id});
  @override
  _OpenMapState createState() => _OpenMapState();
}

class _OpenMapState extends State<OpenMap> {
  StreamSubscription _locationSubscription;
  Marker marker;
  Circle circle;
  final Set<Polyline> _polyline = {};
  GoogleMapController _controller;
  List<LatLng> _latlng = [];
  LatLng initOne;
  Timer timer;
  num lat, long;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 18,
  );
  whatShouldICall() async {
    if (widget.ifISender) {
      await getCurrentLocationInit();
    } else {
      await getLocationInitForStartTrackingSomeOne();
    }
  }

  getCurrentLocationInit() async {
    var position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      initOne = LatLng(position.latitude, position.longitude);
    });
  }

  Future getLocationInitForStartTrackingSomeOne() async {
    await getCoordinates().catchError((err) async {
      print('we got error');
      print(err.toString());
      errorWhileOperation('Maybe no coordinates to track', context)
          .then((value) async => await getLocationInitForStartTrackingSomeOne());
    });
    if (Urls.errorMessage == 'no') {
      if (this.mounted) {
        setState(() {
          initOne = LatLng(TrackingController.trackingGetModel.coordinates[0],
              TrackingController.trackingGetModel.coordinates[1]);
        });
      }
      Position p = Position(latitude: initOne.latitude, longitude: initOne.longitude);
      updateMarkerAndCircle(p);

      await _controller?.moveCamera(CameraUpdate.newCameraPosition(new CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(initOne?.latitude, initOne?.longitude),
          tilt: 0,
          zoom: 18)));
      getLocationInitForStartTrackingSomeOne();
    } else {
      await getLocationInitForStartTrackingSomeOne();
    }
  }

  sendCoordinates(lat, long) async {
    await TrackingController.sendCoordinatesToTrack(
        token: widget.token, lat: lat, long: long);
  }

  Future getCoordinates() async {
    await TrackingController.getCoordinatesToTrack(
        token: widget.token, senderId: widget.id);
  }

  void updateMarkerAndCircle(Position newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    _latlng.add(latlng);
    if (this.mounted) {
      this.setState(() {
        marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          // getLocationInitForStartTrackingSomeOne rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          // anchor: Offset(0.5, 0.5),
        );
        circle = Circle(
            circleId: CircleId("car"),
            radius: newLocalData.accuracy ?? 8,
            zIndex: 1,
            strokeColor: Colors.blue,
            center: latlng,
            fillColor: Colors.blue.withAlpha(70));
        _polyline.add(Polyline(
          polylineId: PolylineId("dsa"),
          visible: true,
          //latlng is List<LatLng>
          points: _latlng,
          color: Colors.blue,
        ));
      });
    }
  }

  void getCurrentLocation() async {
    try {
      var location = await Geolocator.getCurrentPosition();
      updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription =
          Geolocator.getPositionStream().listen((Position newLocalData) {
        if (_controller != null) {
          _controller.moveCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData?.latitude, newLocalData?.longitude),
              tilt: 0,
              zoom: 18)));
          updateMarkerAndCircle(newLocalData);
          lat = newLocalData?.latitude;
          long = newLocalData?.longitude;
          if (lat != null) {
            sendCoordinates(lat, long);
          }
          print(lat);
          print(long);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    whatShouldICall();
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: initOne == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: initialLocation,
              markers: Set.of((marker != null) ? [marker] : []),
              circles: Set.of((circle != null) ? [circle] : []),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                marker = Marker(
                  markerId: MarkerId("home"),
                  position: initOne ?? LatLng(37.42796133580664, -122.085749655962),
                  draggable: false,
                  zIndex: 2,
                  flat: true,
                  // anchor: Offset(0.5, 0.5),
                );
              },
            ),
      floatingActionButton: widget.ifISender
          ? FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: () async {
                getCurrentLocation();
              })
          : Offstage(),
    );
  }
}
