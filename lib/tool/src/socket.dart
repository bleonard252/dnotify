import 'dart:convert';
import 'dart:io';

import 'package:dnotify/src/constants.dart';
import 'package:dnotify/src/loghelper.dart';
import 'package:dnotify/tool/dnotify.dart';

/// Transmit JSON data over a socket asynchronously.
Future<void> socketTransmitJSON(
  dynamic outdata, {
    String logsrc,
    final int logcolor
  }) async {
  final _logcolor = logcolor;
  ConnectionTask dnotifySock;
  if (globalResults["use-tcp"]) dnotifySock = await Socket.startConnect(InternetAddress.loopbackIPv6, tcpPort);
  else dnotifySock = await Socket.startConnect(InternetAddress(socketAddress, type: InternetAddressType.unix), 0);
  dnotifySock.socket.then((s) { 
    if (globalResults["verbose"]) printlog(logsrc, "Encoding data to JSON...", color: _logcolor, verbose: true);
    var x = jsonEncode(outdata);
    if (globalResults["verbose"]) printlog(logsrc, "Sending data...", color: _logcolor, verbose: true);
    s.write(x);
    if (globalResults["verbose"]) printlog(logsrc, x, color: _logcolor, verbose: true);
    s.destroy();
    printlog(logsrc, "Sent!", color: _logcolor);
  });
}