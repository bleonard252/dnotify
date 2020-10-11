import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/loghelper.dart';
import 'package:dnotify/tool/src/socket.dart';

const _logcolor = 166;

void send_cancel(String id, {bool verbose = false, bool useTcp = false}) async {
  socketTransmitJSON(
    {
      "id": id,
      "source": "dnotify-1.0.0-alpha.1", //TODO: require a token
      "type": "cancel"
    },
    logcolor: _logcolor,
    logsrc: "dnotify/cancel",
    useTcp: useTcp
  );
}