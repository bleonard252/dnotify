import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

class ListCommand extends Command {
  final String name = "list";
  final String description = "List active notifications.";
  final String invocation = "dnotify list [options]";
  final List<String> aliases = ["ls"];

  ListCommand() {
    argParser.addFlag("oneline",
      abbr: "1",
      help: "List minimal notification data",
      defaultsTo: false
    );
  }
  
  run() async {
    var read = await File.fromUri(Uri.file("/tmp/dnotify-live.json")).readAsString();
    var data = jsonDecode(read);
    if (this.argResults["oneline"]) for (Map notification in (data as List)) {
      print("${notification["id"]} :: ${notification["title"]}");
    } else for (Map notification in (data as List)) {
      print("------");
      if (notification.containsKey("title")) print("${notification["title"]}");
      if (notification.containsKey("body")) print("${notification["body"]}");
      print("== Source: ${notification["source"]}");
      print("== ID: ${notification["id"]}");
      print("== Icon: ${notification["icon"]}");
    }
  }
}