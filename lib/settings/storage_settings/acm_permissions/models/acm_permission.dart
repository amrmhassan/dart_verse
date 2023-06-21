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

const List<ACMPermission> defaultAcmPermissions = [
  ACMPermission('read'),
  ACMPermission('write'),
  ACMPermission('delete'),
  ACMPermission('editPermissions'),
];
