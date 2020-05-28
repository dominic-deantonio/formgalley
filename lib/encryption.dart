import 'package:encrypt/encrypt.dart';

class Encryption {
  static final key = Key.fromSecureRandom(32); //Key.fromUtf8('my 32 length key................');
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));

  static String encrypt(String value) {
    print('Key is ${key.base16}');
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String value) {
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(value), iv: iv);
    return decrypted;
  }
}
