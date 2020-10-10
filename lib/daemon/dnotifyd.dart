import 'dart:convert';
import 'dart:io';

ServerSocket dnotifySock;

void start() async {
  File.fromUri(Uri.file("/tmp/dnotify-live.json")).openWrite();
  dnotifySock = await ServerSocket.bind(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0);
  dnotifySock.listen((event) {
    utf8.decoder.bind(event).listen((strdata) {
      //ignore:unused_local_variable
      var data = jsonDecode(strdata);
      print(strdata);
    });
  });
}

//TODO: implement a D-Bus interface for org.freedesktop.Notifications
// (or listen to and convert libnotify messages)