import 'dart:convert';
import 'dart:io';

ServerSocket dnotifySock;

void start() {
  //File.fromUri(Uri.file("/tmp/dnotify.sock")).createSync();
  ServerSocket.bind(InternetAddress("/tmp/dnotify.sock", type: InternetAddressType.unix), 0)
  .then((value) {
    dnotifySock = value;
    dnotifySock.listen((event) {
      utf8.decoder.bind(event).listen((strdata) {
        //ignore:unused_local_variable
        var data = jsonDecode(strdata);
        print(strdata);
      });
    });
  })
  .catchError((error) => throw error);
}