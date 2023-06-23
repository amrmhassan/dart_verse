import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Encryption {
  final String _secretKey;
  // final bool _compress;
  late Encrypter _encrypter;
  late IV _iv;

  Encryption(this._secretKey
      // , {
      // bool compress = false,
      // }
      )
  // : _compress = compress
  {
    String keyString = sha256.convert(utf8.encode(_secretKey)).toString();
    final keyE = Key.fromUtf8(keyString.substring(0, 32));
    _iv = IV.fromSecureRandom(16); // Generate a random IV once
    _encrypter = Encrypter(AES(keyE, mode: AESMode.cbc)); // Specify AESMode.cbc
  }

  Encrypted encrypt(String content) {
    return _encrypter.encrypt(content, iv: _iv);
  }

  String decrypt(Uint8List bytes) {
    return _encrypter.decrypt(Encrypted(bytes), iv: _iv);
  }

  File encryptAndSave(
    String content,
    String filePath, {
    /// will throw an error if override = false and the file exists
    bool override = false,
    // int compressionLevel = Deflate.BEST_SPEED,
  }) {
    var encrypted = encrypt(content);
    File file = File(filePath);
    bool exists = file.existsSync();
    if (exists && !override) {
      throw Exception('file already exists && override = false');
    }
    file.writeAsBytesSync(encrypted.bytes);
    // if (_compress) {
    //   var encoder = ZipFileEncoder();
    //   //! new
    //   encoder.zipDirectory(Directory('out'), filename: 'out.zip');

    //   encoder.create(filePath, level: compressionLevel);
    //   encoder.addFile(file);
    //   encoder.close();
    // }

    return file;
  }

  String readEncryptedFile(String filePath) {
    File file = File(filePath);
    var bytes = file.readAsBytesSync();
    // if (_compress) {
    //   var archive = ZipDecoder().decodeBytes(bytes);
    //   var encryptedFile = archive.files.first;
    //   bytes = encryptedFile.content;
    // }
    return decrypt(bytes);
  }
}
