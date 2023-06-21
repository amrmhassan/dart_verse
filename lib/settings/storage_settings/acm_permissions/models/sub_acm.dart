import 'acm_permission.dart';

class SubACM {
  final String subPath;
  final List<ACMPermission> permissions;

  const SubACM(
    this.subPath, {
    this.permissions = defaultAcmPermissions,
  });

  Map<String, dynamic> toJSON() {
    return {
      'sub_path': subPath,
      'permissions': permissions.map((e) => e.toJSON()).toList(),
    };
  }
}
