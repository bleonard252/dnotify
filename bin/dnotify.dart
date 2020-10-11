import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dnotify/tool/command/cancel.dart';
import 'package:dnotify/tool/command/list.dart';
import 'package:dnotify/tool/command/send.dart';
import 'package:dnotify/tool/dnotify.dart';

void main(List<String> arguments) {
  // Prepare command parser
  var cmdr = CommandRunner("dnotify", "dahliaOS notification tool");
  var args = cmdr.argParser;
  // Add universal stuff
  args.addFlag("verbose", 
    abbr: "v",
    help: "Make dnotify more [or less] verbose."
  );
  args.addFlag("use-tcp", 
    abbr: "t",
    help: "Use a TCP socket on machines that don't work with Unix domain sockets.",
    defaultsTo: (Platform.isLinux) ? false : true //pretty much anything that's not Linux
  );
  // Add commands
  cmdr.addCommand(SendCommand());
  if (File.fromUri(Uri.file("/tmp/dnotify-live.json")).existsSync()) {
    cmdr.addCommand(ListCommand());
    cmdr.addCommand(CancelCommand());
  }
  // Run commands
  var res = cmdr.parse(arguments);
  globalResults = res;
  cmdr.runCommand(res);
}
