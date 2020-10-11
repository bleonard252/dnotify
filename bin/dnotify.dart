import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dnotify/tool/command/cancel.dart';
import 'package:dnotify/tool/command/list.dart';
import 'package:dnotify/tool/command/send.dart';

void main(List<String> arguments) {
  // Prepare command parser
  var cmdr = CommandRunner("dnotify", "dahliaOS notification tool");
  var args = cmdr.argParser;
  // Add universal stuff
  args.addFlag("verbose", 
    abbr: "v",
    help: "Make dnotify more [or less] verbose."
  );
  // Add commands
  cmdr.addCommand(SendCommand());
  if (File.fromUri(Uri.file("/tmp/dnotify-live.json")).existsSync()) {
    cmdr.addCommand(ListCommand());
    cmdr.addCommand(CancelCommand());
  }
  // Run commands
  var res = cmdr.parse(arguments);
  cmdr.runCommand(res);
}
