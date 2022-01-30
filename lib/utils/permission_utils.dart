import 'package:super_easy_permissions/super_easy_permissions.dart';

class PermissionUtils {
  static Future<void> requestPermission() async {
    final res = await SuperEasyPermissions.getPermissionResult(Permissions.sms);
    if (res != 1) {
      SuperEasyPermissions.askPermission(Permissions.sms);
    }
  }
}
