import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/constants.dart';
import 'package:dnotify/src/loghelper.dart';
import 'package:dnotify/tool/src/socket.dart';

ConnectionTask<Socket> dnotifySock;

const _logcolor = 25;

void send(String title, String text, {String icon, int priority, bool verbose, bool useTcp, String source = defaultSource}) {
  //File.fromUri(Uri.file("/tmp/dnotify.sock")).createSync();
  socketTransmitJSON(
    {
      "title": title,
      "body": text,
      "source": source, //TODO: require a token
      if (priority != null) "priority": priority,
      if (icon != null) "icon": icon
    },
    logcolor: _logcolor,
    logsrc: "dnotify/send",
    useTcp: useTcp
  );
}