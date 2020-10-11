import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dnotify/tool/src/send.dart';
import 'package:dnotify/tool/src/send_cancel.dart';

class CancelCommand extends Command {
  final String name = "cancel";
  final String description = "Remove an active notification.";
  final String invocation = "dnotify cancel [options] <id>";
  final List<String> aliases = ["dismiss", "remove", "rm"];
  final String usageFooter = "NOTE: Some notifications will not be dismissed but will be silently"
  " kept if they are persistent.";

  CancelCommand() {
    argParser.addFlag("all",
      abbr: "a",
      help: "Dismiss all notifications."
    );
  }

  run() async {
    if (argResults["all"]) {
      var read = await File.fromUri(Uri.file("/tmp/dnotify-live.json")).readAsString();
      var data = jsonDecode(read);
      for (Map notification in (data as List)) {
        await send_cancel(notification["id"]);
      }
    } else {
      await send_cancel(argResults.rest[0]);
    }
  }
}