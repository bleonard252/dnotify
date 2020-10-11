import 'dart:io';

import 'package:dnotify/daemon/dnotifyd.dart' as _daemon;
import 'package:dnotify/tool/src/send.dart' as _send;

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

/// Send notifications.
abstract class DNotify {
  static Future<void> send(
    String title, 
    String text,
    {
      String icon,
      int priority,
      bool useTcp = null,
    }) async {
    await _send.send(
      title, text, 
      icon: icon, 
      priority: priority, 
      useTcp: useTcp != null ? useTcp : Platform.isLinux ? false : true
    );
  }
}