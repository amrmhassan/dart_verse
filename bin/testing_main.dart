import 'package:dart_verse/utils/encryption.dart';

void main(List<String> args) {
  String plainText = 'hello from my dart verse package';
  Encryption encryption = Encryption('This is my secret key');
  var res = encryption.encryptAndSave(
    plainText,
    './encrypted',
    override: true,
  );
  var content = encryption.readEncryptedFile('./encrypted');
  print(res);
  print(content);
}
