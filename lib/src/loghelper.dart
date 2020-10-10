import 'package:dart_console/dart_console.dart';

var con = Console();

void printlog(String source, dynamic object, {int color = 9, bool error = false}) {
  if (error) {
    con.write("[");
    con.setForegroundColor(ConsoleColor.brightRed);
    con.setTextStyle(bold: true);
    con.write("ERROR");
    con.resetColorAttributes();
    con.write("] ");
  }
  if (source != "") {
    con.write("[");
    con.setForegroundColor(ConsoleColor.brightMagenta);
    con.setForegroundExtendedColor(color);
    con.setTextStyle(bold: true);
    con.write(source);
    con.resetColorAttributes();
    con.write("] ");
  } else con.write("[ NO-SOURCE! ] ");
  con.write("${object.toString()}\n");
}