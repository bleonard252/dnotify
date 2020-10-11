import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dnotify/daemon/dnotifyd.dart';
import 'package:dnotify/src/loghelper.dart';

ArgResults args;

void main(List<String> arguments) {
  var cmdr = CommandRunner("dnotifyd", "dahliaOS Notification Daemon");
  cmdr.argParser.addFlag("verbose",
    abbr: "v",
    defaultsTo: false,
    help: "Echo all incoming notifications to the command line"
  );
  cmdr.argParser.addFlag("libnotify",
    defaultsTo: false,
    help: "Mirror notifications to libnotify. Used for testing, will be removed.",
    hide: true
  );
  cmdr.argParser.addFlag("use-tcp", 
    abbr: "t",
    help: "Use a TCP socket on machines that don't work with Unix domain sockets.",
    defaultsTo: (Platform.isLinux) ? false : true //pretty much anything that's not Linux
  );
  var res = cmdr.parse(arguments);
  args = res;
  if (res.command != null) cmdr.runCommand(res);
  else {
    if (args["use-tcp"]) printlog("dnotifyd/init", "dnotifyd starting using TCP...", color: 93);
    else printlog("dnotifyd/init", "dnotifyd starting using UNIX...", color: 93);
    start(verbose: args["verbose"], libnotify: args["libnotify"], useTcp: args["use-tcp"]);
  }
}