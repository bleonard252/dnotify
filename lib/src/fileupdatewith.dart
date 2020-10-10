import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Add updateWith method(s) to File.
extension updateWithMethods on File {
  /// Update the file using the provided function,
  /// which will be given the value of the file,
  /// and should return a new value to write.
  /// The file will be closed when it is done.
  //ignore:unused_element
  void updateWith(String closure(String rawData)) async {
    var read = await this.readAsString();
    var write = this.openWrite();
    var toWrite = await closure(read);
    write.write(toWrite);
    await write.flush();
  }
  /// Updates the JSON data stored in the file.
  /// Remember to return [rawData] at the end.
  void updateWithJSON<T>(T closure(T rawData)) async {
    var read = await this.readAsString();
    if (read == "" || read.startsWith("null")) read = "[]";
    var write = this.openWrite();
    var jsonRead = jsonDecode(read);
    var toWrite = await closure(jsonRead);
     var jsonWrite = jsonEncode(toWrite);
    write.write(jsonWrite);
    await write.flush();
  }
}