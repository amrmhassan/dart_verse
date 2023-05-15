import 'coll_ref.dart';

class DbQuery {
  DbController ref(DbEntity ref) {}
}

abstract class DbController {
  late DbEntity _entity;
}

class CollectionController implements DbController {
  @override
  DbEntity _entity;
  CollectionController(this._entity);
}

class DocumentController implements DbController {
  @override
  DbEntity _entity;
  DocumentController(this._entity);
}
