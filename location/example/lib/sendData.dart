import 'dart:convert';

import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class SendData {
  String server = "192.168.1.104";
  String port = "8080";
  String path = "app/add";
  var logger = Logger();

  Future<http.Response> uploadGPSData(LocationData locationData) {
    String url = 'http://${server}:${port}/${path}';
    String payload = jsonEncode(<String, String>{
      'latitude':'${locationData.latitude}',
      'longitude':'${locationData.longitude}',
      'meta': '${locationData}'
    });
    logger.i('Sending data to :: ${url} with payload :: ${payload}');
    return http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: payload,
    );
  }
}