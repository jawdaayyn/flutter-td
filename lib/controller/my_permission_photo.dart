import 'package:permission_handler/permission_handler.dart';

class MyPermissionPhoto {
  init() async {
    PermissionStatus status = await Permission.photos.status;
    checkPermission(status);
  }

  checkPermission(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.permanentlyDenied:
        return Future.error("Toujours refusé");
      case PermissionStatus.denied:
        return Permission.photos.request();
      case PermissionStatus.limited:
        return Permission.photos.request();
      case PermissionStatus.provisional:
        return Permission.photos.request();
      case PermissionStatus.restricted:
        return Permission.photos.request();
      case PermissionStatus.granted:
        return Permission.photos.request();
    }
  }
}
