import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class InternalPermissionHandler {
  final Permission permission;

  InternalPermissionHandler(this.permission);

  Future<void> request({
    @required final OnPermanentDenied onPermanentDenied,
    @required final OnGranted onGranted,
  }) async {
    PermissionStatus status = await permission.status;
    print("InternalPermissionHandler status: $status");
    if (status.isPermanentlyDenied) {
      onPermanentDenied.call();
      return;
    }
    if (!status.isLimited && !status.isGranted) {
      final PermissionStatus result = await permission.request();
      if (!result.isGranted) {
        return;
      }
    }
    onGranted.call();
  }
}

typedef OnPermanentDenied = void Function();

typedef OnGranted = void Function();