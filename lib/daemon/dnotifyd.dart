import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/loghelper.dart';
import 'package:dnotify/src/fileupdatewith.dart';

ServerSocket dnotifySock;

const _logcolor = 34;

void start({bool verbose = false}) async {
  try {
    File.fromUri(Uri.file("/tmp/dnotify-live.json")).deleteSync();
  } catch(e) {}
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
      if (verbose) printlog("dnotifyd/listen", strdata, color: _logcolor, verbose: true);
      var file = File.fromUri(Uri.file("/tmp/dnotify-live.json"));
      if (!file.existsSync()) {
        file.createSync();
        file.writeAsStringSync("[]");
      }
      file.updateWithJSON<List>((json) {
        //TODO: test if this is worthy
        //TODO: also take in cancel events
        if (json is List && data is Map) {
          json.add(data);
          return json;
        }
        else {
          printlog("dnotifyd/update", "/tmp/dnotify-live.json has been tampered with!", color: _logcolor, error: true);
          return json;
        }
      });
    });
  });
  printlog("dnotifyd/start", "Started", color: _logcolor);
}

//TODO: implement a D-Bus interface for org.freedesktop.Notifications
// (or listen to and convert libnotify messages)