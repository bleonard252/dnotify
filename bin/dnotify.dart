import 'package:args/command_runner.dart';
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
  cmdr.addCommand(ListCommand());
  // Run commands
  var res = cmdr.parse(arguments);
  cmdr.runCommand(res);
}
