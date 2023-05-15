import '../repo/verse_db.dart';

class Ref {
  final Ref? parent;
  final String ref;
  final DbRefEntity dbEntity;

  const Ref(
    this.ref,
    this.parent,
    this.dbEntity,
  );

  @override
  String toString() {
    if (parent == null) {
      return ref;
    }
    return '${parent!.toString()}/$ref';
  }
}
