import '../models/acm_permission.dart';
import 'acm_permissions.dart';

const List<ACMPermission> defaultAcmPermissions = [
  ACMPermission(ACMPermissions.read),
  ACMPermission(ACMPermissions.delete),
  ACMPermission(ACMPermissions.write),
  ACMPermission(ACMPermissions.editPermissions),
];

List<ACMPermission> defaultPermissionsWithCreatorId(String creatorId) {
  return [
    ACMPermission(ACMPermissions.read, allowed: [creatorId]),
    ACMPermission(ACMPermissions.delete, allowed: [creatorId]),
    ACMPermission(ACMPermissions.write, allowed: [creatorId]),
    ACMPermission(ACMPermissions.editPermissions, allowed: [creatorId]),
  ];
}
