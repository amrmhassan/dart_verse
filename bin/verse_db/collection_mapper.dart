class CollectionMapper {
  final String name;
  final String id;

  const CollectionMapper({
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'id': id,
    };
  }

  static CollectionMapper fromJSON(Map<String, dynamic> obj) {
    return CollectionMapper(name: obj['name'], id: obj['id']);
  }
}
