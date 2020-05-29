import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Encryption {
  static Key key; //Key is received from secure storage
  static bool keyShouldExistInStorage;
  static const String storageKeyKey = 'encryptionKey'; //The key to the key
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));
  static final secureStorage = new FlutterSecureStorage(); //Hide the key here - sorry, hackers.

  static String encrypt(String value) {
    print('Key is ${key.base16}');
    final encrypted = encrypter.encrypt(value, iv: iv);
    return encrypted.base64;
  }

  static String decrypt(String value) {
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(value), iv: iv);
    return decrypted;
  }

  static Future<void> writeNewKeyInSecureStorage() async {
    String val = Key.fromSecureRandom(32).base64;
    await secureStorage.write(key: storageKeyKey, value: val);
    print('Stored the key (base64): $val');

  }

  static Future<void> getKeyFromSecureStorage() async {
    String retrievedKey = await secureStorage.read(key: storageKeyKey);
    print('got key as base64: $retrievedKey');
    key = Key.fromBase64(retrievedKey);
    print('Converted string to key (base64): ${key.base64}');
  }

  static void deleteKey()async {
    await secureStorage.delete(key: storageKeyKey);
  }
}
