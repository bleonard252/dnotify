import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/loghelper.dart';

const _logcolor = 166;

void send_cancel(String id, {bool verbose = false}) async {
  ConnectionTask dnotifySock;
  Socket.startConnect(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0)
  .then((value) {
    dnotifySock = value;
    dnotifySock.socket.then((s) { 
      if (verbose) printlog("dnotify/send", "Encoding data to JSON...", color: _logcolor, verbose: true);
      var x = jsonEncode({
        "id": id,
        "source": "dnotify-1.0.0-alpha.1", //TODO: require a token
        "type": "cancel"
      });
      if (verbose) printlog("dnotify/cancel", "Sending dismissal packet...", color: _logcolor, verbose: true);
      s.write(x);
      if (verbose) printlog("dnotify/cancel", x, color: _logcolor, verbose: true);
      s.destroy();
      printlog("dnotify/cancel", "Sent!", color: _logcolor);
    });
  });
}