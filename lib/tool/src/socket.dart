import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dnotify/src/constants.dart';
import 'package:dnotify/src/loghelper.dart';
import 'package:dnotify/tool/dnotify.dart';

/// Transmit JSON data over a socket asynchronously.
Future<void> socketTransmitJSON(
  dynamic outdata, {
    String logsrc,
    final int logcolor,
    bool useTcp = false,
  }) async {
  final _logcolor = logcolor;
  ConnectionTask dnotifySock;
  if (useTcp) dnotifySock = await Socket.startConnect(InternetAddress.loopbackIPv6, tcpPort);
  else dnotifySock = await Socket.startConnect(InternetAddress(socketAddress, type: InternetAddressType.unix), 0);
  dnotifySock.socket.then((s) { 
    try{if (globalResults != null && globalResults["verbose"]) printlog(logsrc, "Encoding data to JSON...", color: _logcolor, verbose: true);}catch(e){}
    var x = jsonEncode(outdata);
    try{if (globalResults != null && globalResults["verbose"]) printlog(logsrc, "Sending data...", color: _logcolor, verbose: true);}catch(e){}
    s.write(x);
    try{if (globalResults != null && globalResults["verbose"]) printlog(logsrc, x, color: _logcolor, verbose: true);}catch(e){}
    s.destroy();
    printlog(logsrc, "Sent!", color: _logcolor);
  });
}