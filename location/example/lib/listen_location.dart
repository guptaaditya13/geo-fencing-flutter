import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:location_example/sendData.dart';
import 'package:logger/logger.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();
  var logger = Logger();
  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;
  SendData dataSender = SendData();

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      setState(() {
        _error = err.code;
      });
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      logger.d('got data :: ${currentLocation}');
      sendDataToServer(currentLocation);
      logger.d('data sent');
      setState(() {
        _error = null;

        _location = currentLocation;
      });
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  Future<void> sendDataToServer(LocationData currentLocation) async {
    logger.d('sending data :: ${currentLocation}');
    return dataSender.uploadGPSData(currentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' + (_error ?? '${_location ?? "unknown"}'),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: RaisedButton(
                child: const Text('Listen'),
                onPressed: _listenLocation,
              ),
            ),
            RaisedButton(
              child: const Text('Stop'),
              onPressed: _stopListen,
            )
          ],
        ),
      ],
    );
  }
}
