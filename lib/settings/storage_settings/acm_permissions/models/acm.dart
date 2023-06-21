//! if the allowed is empty then the only one allowed is the bucket creator id
import 'acm_permission.dart';
import 'sub_acm.dart';

class ACM {
  // permissions of the bucket itself
  final List<ACMPermission> permissions;
  // permissions of a specific file in that bucket(if empty then all files in the bucket will have the same permissions as the containing bucket)
  final List<SubACM> subPermissions;

  const ACM([
    this.permissions = defaultAcmPermissions,
    this.subPermissions = const [],
  ]);

  Map<String, dynamic> toJSON() {
    return {
      'permissions': permissions.map((e) => e.toJSON()).toList(),
      'sub_permissions': subPermissions.map((e) => e.toJSON()).toList(),
    };
  }
}
