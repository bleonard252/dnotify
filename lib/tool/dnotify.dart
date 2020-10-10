import 'dart:convert';
import 'dart:io';

ConnectionTask<Socket> dnotifySock;

void send(String title, String text) {
  //File.fromUri(Uri.file("/tmp/dnotify.sock")).createSync();
  Socket.startConnect(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0)
  .then((value) {
    dnotifySock = value;
    dnotifySock.socket.then((s) { 
      s.write(jsonEncode({
        "title": title,
        "body": text
      }));
      dnotifySock.cancel();
    });
  })
  .catchError((error) => throw error);
}