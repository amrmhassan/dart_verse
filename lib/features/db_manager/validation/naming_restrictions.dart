import 'dart:convert';

import '../../../constants/reserved_keys.dart';

class DocValidation {
  final String id;
  final Map<String, dynamic> doc;

  const DocValidation(this.id, this.doc);

  Map<String, dynamic> validate() {
    // check for the id length
    int idSize = utf8.encode(id).length;
    if (idSize > DocRestrictions.maxIdLength) {
      throw Exception(
          '${DBRKeys.id} max length is ${DocRestrictions.maxIdLength} bytes');
    }
    // checking for the _collections keyword
    if (doc[DBRKeys.collections] != null) {
      throw Exception(
          'you can\'t use ${DBRKeys.collections} keyword as it is reserved');
    }
    // update the id
    doc[DBRKeys.id] = id;
    // doc[DBRKeys.collections] = [];
    return doc;
  }
}

class DocRestrictions {
  static const int maxIdLength = 80;
}
