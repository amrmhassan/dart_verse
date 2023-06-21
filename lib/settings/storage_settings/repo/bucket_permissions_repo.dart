import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

//! bucket can only contain other buckets or files
//! so no thing called createSubFolder inside a bucket
//! you can only upload a file to a bucket and play with that file, no folders can be created inside a bucket except those folders who are buckets
class BucketPermissionsRepo {
  late StorageBucket bucket;
  // each bucket will have 4 default permissions (write, read, delete, editPermissions) and will be stored in .acm binary file
  // each bucket .acm file will contain sub files permissions or sub files .acm files
  // -- for example bucket called amr with some files profilePic, personalPic
  // amr wants his bucket to be public and everyone with link can download or view any content from the bucket
  // but for the file personalPic amr want only him to view his personalPic
  // so in the bucket .acm file it will contain some kind of list for sub files permissions
  // the .acm file will be a json like object on the form of
  var acm = {
    'permissions': [
      //  permission read have * in his allowed list, this means anyone can read this bucket
      {
        'name': 'read',
        'allowed': ['*']
      },
      //  permission write have *only 2 users ids in his allowed list, this means only these 2 users can write to this bucket
      {
        'name': 'write',
        'allowed': ['user_id1', 'user_id2']
      },
      //  permission delete have no one in his allowed list, this means no one can delete from this bucket
      {'name': 'read', 'allowed': []},
    ],
    'sub_permissions': [
      // this will have the file sub path inside the bucket, so it's abs path will be bucket_path+'/'+sub_path
      {
        'sub_path': 'sub path of the file inside the bucket itself',
        'permissions': [
          //  permission read have * in his allowed list, this means anyone can read this bucket
          {
            'name': 'read',
            'allowed': ['*']
          },
          //  permission write have *only 2 users ids in his allowed list, this means only these 2 users can write to this bucket
          {
            'name': 'write',
            'allowed': ['user_id1', 'user_id2']
          },
          //  permission delete have no one in his allowed list, this means no one can delete from this bucket
          {'name': 'read', 'allowed': []},
        ]
      },
    ],
  };
}

//! if the allowed is empty then the only one allowed is the bucket creator id
class ACM {
  // permissions of the bucket itself
  final List<ACMPermission> permissions;
  // permissions of a specific file in that bucket(if empty then all files in the bucket will have the same permissions as the containing bucket)
  final List<SubACM> subPermissions;

  const ACM([
    this.permissions = _defaultAcmPermissions,
    this.subPermissions = const [],
  ]);

  Map<String, dynamic> toJSON() {
    return {
      'permissions': permissions.map((e) => e.toJSON()).toList(),
      'sub_permissions': subPermissions.map((e) => e.toJSON()).toList(),
    };
  }
}

class SubACM {
  final String subPath;
  final List<ACMPermission> permissions;

  const SubACM(
    this.subPath, {
    this.permissions = _defaultAcmPermissions,
  });

  Map<String, dynamic> toJSON() {
    return {
      'sub_path': subPath,
      'permissions': permissions.map((e) => e.toJSON()).toList(),
    };
  }
}

class ACMPermission {
  final String name;
  final List<String>? _allowed;

  const ACMPermission(
    this.name, {
    List<String>? allowed,
  }) : _allowed = allowed;

// if the allowed is null then the default allowed one is this who created the bucket
  List<String> get allowed => _allowed == null ? [] : _allowed!;

  Map<String, dynamic> toJSON() {
    return {'name': name, 'allowed': allowed};
  }
}

const List<ACMPermission> _defaultAcmPermissions = [
  ACMPermission('read'),
  ACMPermission('write'),
  ACMPermission('delete'),
  ACMPermission('editPermissions'),
];
