import 'package:args/command_runner.dart';
import 'package:dnotify/tool/src/send.dart';

class SendCommand extends Command {
  final String name = "send";
  final String description = "Send a notification.";
  final String invocation = "dnotify send [options] <title> <body>";

  SendCommand() {
    argParser.addOption("priority", 
      abbr: "p",
      allowed: ["1", "2", "3", "4", "5"],
      help: "Set the priority, from 1 (highest) to 5 (lowest).",
      defaultsTo: "3"
    );
    argParser.addOption("icon",
      abbr: "i",
      help: "Set the pathname or Material icon name to use for the icon.",
      defaultsTo: "settings"
    );
  }
  
  run() {
    send(
      argResults.rest[0], 
      argResults.rest[1],
      icon: argResults["icon"],
      priority: int.parse(argResults["priority"]),
      verbose: globalResults["verbose"]
    );
  }
}