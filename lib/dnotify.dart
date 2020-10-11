import 'dart:io';

import 'package:args/args.dart';
import 'package:dnotify/daemon/dnotifyd.dart' as _daemon;
import 'package:dnotify/tool/dnotify.dart' as _const;
import 'package:dnotify/tool/src/send.dart' as _send;
import 'package:dnotify/tool/src/send_cancel.dart' as _cancel;

/// Register a notification listener.
abstract class DNotifyDaemon {
  static Future<ServerSocket> start(notificationReceived(dynamic data), {
    bool useTcp = null
  }) async {
    return _daemon.start(
      useTcp: useTcp != null ? useTcp : Platform.isLinux ? false : true,
      notificationReceived: notificationReceived,
    );
  }
}

/// Send and manage notifications.
abstract class DNotify {
  /// Send a notification.
  static Future<void> send(
    String title, 
    String text,
    {
      String icon = "md:settings_applications",
      int priority = 3,
      bool useTcp = null,
    }) async {
    _const.globalResults = {"useTcp": useTcp == null ? useTcp : Platform.isLinux ? false : true, "verbose": false};
    await _send.send(
      title, text, 
      icon: icon, 
      priority: priority, 
      useTcp: useTcp != null ? useTcp : Platform.isLinux ? false : true
    );
  }
  /// Cancel a notification by its ID.
  /// Will succeed as long as dnotifyd is running
  /// and the cancel request can be sent.
  static Future<void> cancel(String id) async {
    await _cancel.send_cancel(id);
  }
}