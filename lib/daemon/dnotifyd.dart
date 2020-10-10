import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/loghelper.dart';

ServerSocket dnotifySock;

const _logcolor = 34;

void start() async {
  File.fromUri(Uri.file("/tmp/dnotify-live.json")).openWrite();
  try {
    dnotifySock = await ServerSocket.bind(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0);
  } on SocketException {
    printlog("dnotifyd/start", "Failed to open socket! Are you running another instance of dnotifyd?", color: _logcolor, error: true);
    exit(1);
  }
  dnotifySock.listen((event) {
    utf8.decoder.bind(event).listen((strdata) {
      //ignore:unused_local_variable
      var data = jsonDecode(strdata);
      print(strdata);
    });
  });
  printlog("dnotifyd/start", "Started", color: _logcolor);
}

//TODO: implement a D-Bus interface for org.freedesktop.Notifications
// (or listen to and convert libnotify messages)