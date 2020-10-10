import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/loghelper.dart';

ConnectionTask<Socket> dnotifySock;

const _logcolor = 25;

void send(String title, String text, {String icon, int priority, bool verbose}) {
  //File.fromUri(Uri.file("/tmp/dnotify.sock")).createSync();
  Socket.startConnect(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0)
  .catchError((error) {
    printlog("dnotify/send", "An error occurred! See stack trace below:", color: _logcolor, error: true);
    print(error);
    exit(2);
  })
  .then((value) {
    dnotifySock = value;
    dnotifySock.socket.then((s) { 
      if (verbose) printlog("dnotify/send", "Encoding data to JSON...", color: _logcolor, verbose: true);
      var x = jsonEncode({
        "title": title,
        "body": text,
        if (priority != null) "priority": priority,
        if (icon != null) "icon": icon
      });
      if (verbose) printlog("dnotify/send", "Sending notification...", color: _logcolor, verbose: true);
      s.write(x);
      if (verbose) printlog("dnotify/send", x, color: _logcolor, verbose: true);
      s.destroy();
      printlog("dnotify/send", "Sent!", color: _logcolor);
    });
  })
  .catchError((error) {
    printlog("dnotify/send", "An error occurred! See stack trace below:", color: _logcolor, error: true);
    print(error);
    exit(2);
  });
}