import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/loghelper.dart';

/// Transmit JSON data over a socket asynchronously.
Future<void> socketTransmitJSON(
  dynamic outdata, {
    bool verbose = false,
    bool useTcp = false,
    String logsrc,
    final int logcolor
  }) async {
  final _logcolor = logcolor;
  ConnectionTask dnotifySock;
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
      var x = jsonEncode(outdata);
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