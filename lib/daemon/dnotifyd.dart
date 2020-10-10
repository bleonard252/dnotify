import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dnotify/src/loghelper.dart';
import 'package:dnotify/src/fileupdatewith.dart';
import 'package:uuid/uuid.dart';

ServerSocket dnotifySock;

const _logcolor = 34;

void start({bool verbose = false, bool libnotify = false}) async {
  if (libnotify) printlog("dnotifyd/start", "Mirroring notifications to libnotify! Since this is only for testing, it will be removed!", warning: true, color: _logcolor);
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
          if (!data.containsKey("source") && verbose) {
            printlog("dnotifyd/update", "Source string missing from notification, rejecting...", error: true, verbose: true);
            return json;
          }
          switch (data["type"]) {
            case "cancel":
              json.removeWhere((element) => element["id"] == data["id"]);
              break;
            default:
              if (!data.containsKey("id")) data["id"] = Uuid().v5(data["source"], Random().nextInt(64).toRadixString(24));
              json.add(data);
              break;
          }
          return json;
        }
        else {
          printlog("dnotifyd/update", "/tmp/dnotify-live.json has been tampered with!", color: _logcolor, error: true);
          return json;
        }
      });
      if (libnotify) 
        Process.run("notify-send", ["-t", "1000", "-i", data.containsKey("icon") ? data["icon"].replaceFirst("md:", "") : "settings", data["title"], data["body"]]).then((v) {
          printlog("dnotifyd/libnotify", "Dispatch successful", color: _logcolor);
        });
    });
  });
  printlog("dnotifyd/start", "Started", color: _logcolor);
}

//TODO: implement a D-Bus interface for org.freedesktop.Notifications
// (or listen to and convert libnotify messages)