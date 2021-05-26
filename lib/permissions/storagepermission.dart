import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'internalpermissionhandler.dart';

class StoragePermission extends InternalPermissionHandler {
  StoragePermission() : super(Platform.isAndroid ? Permission.storage : Permission.photos);
}