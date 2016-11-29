// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Random random = new Random();
String filepath = "";
Future<dynamic> handleGetRandom(Map<String, dynamic> message) async {
  final double min = message['min'].toDouble();
  final double max = message['max'].toDouble();

  return <String, double>{
    'value': (random.nextDouble() * (max - min)) + min
  };
}

class HelloServices extends StatefulWidget {
  @override
  _HelloServicesState createState() => new _HelloServicesState();
}

class _HelloServicesState extends State<HelloServices> {
  double _latitude;
  double _longitude;

  @override
  Widget build(BuildContext context) {

    return new Material(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Image.network("file:/$filepath"),
            new RaisedButton(
              child: new Text('Take Photo'),
              onPressed: _takePicture
            ),
            new Text(filepath),
          ]
        )
      )
    );
  }

  Future<Null> _takePicture() async {
    String reply = await HostMessages.sendToHost('takePictureAndSend');

    setState((){
      filepath = reply;
      print("file:/$filepath");
    });
  }
}

main() async{
  runApp(new HelloServices());

}
