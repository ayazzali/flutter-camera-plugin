// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final Random random = new Random();

class HelloServices extends StatefulWidget {
  @override
  _HelloServicesState createState() => new _HelloServicesState();
}

class _HelloServicesState extends State<HelloServices> {
  List<String> _filepaths = [];
  String _filepath = "";

  bool _randomScale = false;

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Center(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
          new RaisedButton(
              child: new Text('Take Photo'), onPressed: _takePicture),
          new Text(_filepath),
          new Row(children: [
            new Switch(
                value: _randomScale,
                onChanged: (value) {
                  setState(() => _randomScale = value);
                }),
            new Text('Random scale')
          ], mainAxisAlignment: MainAxisAlignment.center),
          new Image.file(new File(_filepath),
              scale: _randomScale ? 1.0 + random.nextDouble() : 1.0),
          new Row(children: getImgs())
        ])));
  }

  Image getImg(File f) => new Image.file(f);
  List<Image> getImgs() =>
      _filepaths.map((path) => getImg(new File(path))).toList();

  Future<Null> _takePicture() async {
    String reply = await PlatformMessages.sendString('takePictureAndSend', '');

    setState(() {
      print("Filepath => $reply");
      _filepath = reply;
      _filepaths.add(reply);
    });
  }
}

main() async {
  runApp(new HelloServices());
}
