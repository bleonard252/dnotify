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
  var res = cmdr.parse(arguments);
  args = res;
  if (res.command != null) cmdr.runCommand(res);
  else {
    printlog("dnotifyd/init", "dnotifyd starting...", color: 93);
    start();
  }
}