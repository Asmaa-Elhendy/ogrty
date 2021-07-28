import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:socket_io_common_client/socket_io_client.dart' as IO;

class GetLocation extends StatefulWidget {
  final String token;
  GetLocation({@required this.token});
  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  IO.Socket socket;
  Timer timer;
  sendToBack(lat, long) {
    const fiveSeconds = const Duration(seconds: 10);
    Timer.periodic(fiveSeconds, (Timer t) {
      return emitOnTap(lat, long);
    });
  }

  emitOnTap(double lat, double long) async {
    socket.emit(
      'follow',
      {
        "coordinates": [lat, long],
      },
    );
  }

  connect() async {
    socket = IO.io(
      'https://ptos.herokuapp.com/follow',
    );
    socket.on('connect', (_) {
      print('connect happened');
      socket.emit('authenticate', {
        'token': widget.token,
      });
    });
    socket.on('new follow', (data) => print(data));
  }

  StreamSubscription _locationSubscription;
  streamLocation() async {
    _locationSubscription =
        Geolocator.getPositionStream().listen((Position position) {});

    // socket.on('new follow', (data) => print(data));
  }

  getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Geolocator.openAppSettings();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('location: ${position.latitude} ${position.longitude}');
    emitOnTap(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
    _locationSubscription?.cancel();
    socket?.disconnect();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await getLocation();
              },
              child: Text('Get location'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                await streamLocation();
              },
              child: Text('Stream location'),
            ),
          ],
        ),
      ),
    );
  }
}
