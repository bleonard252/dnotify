import 'dart:convert';
import 'dart:io';

ConnectionTask<Socket> dnotifySock;

void send(String title, String text, {String icon, int priority, bool verbose}) {
  //File.fromUri(Uri.file("/tmp/dnotify.sock")).createSync();
  Socket.startConnect(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0)
  .then((value) {
    dnotifySock = value;
    dnotifySock.socket.then((s) { 
      var x = jsonEncode({
        "title": title,
        "body": text,
        if (priority != null) "priority": priority,
        if (icon != null) "icon": icon
      });
      s.write(x);
      if (verbose) print(x);
      s.destroy();
    });
  })
  .catchError((error) => throw error);
}