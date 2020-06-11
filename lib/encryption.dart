import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:formgalley/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Encryption {
  static Key key; //Key is received from secure storage
  static bool keyShouldExistInStorage;
  static const String storageKeyKey = 'encryptionKey'; //The key to the value: key
  static final iv = IV.fromLength(16);
  static final encrypter = Encrypter(AES(key));
  static final secureStorage = new FlutterSecureStorage(); //Hide the key here - sorry, hackers.

  static Future<String> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    bool didInitializeEncryption = prefs.getBool('didInitialize');
    String result = 'Result not set';

    //check if db has flag 'didInitializeEncryptionKey'
    await retrieveKeyFromSecureStorage();
    if (key == null) {
      result = 'Retrieved key was null.';
      if (didInitializeEncryption == true) {
        result += ' Prefs show encryption has been initialized previously.';
        result += '\nRecommend reinstalling app, check secure storage and shared preferences';
        //alert user of failure (but can generate forms without save data), recommend reinstall app
      } else {
        //no key was been made yet or IO error
        result += '\nThis appears to be the first app boot because shared preferences flag is null or false.';
        await writeNewKeyInSecureStorage();
        await retrieveKeyFromSecureStorage();
        if (key == null) {
          result += '\nFailed to write and/or read secure storage. Encryption and decryption impossible.';
        } else {
          await prefs.setBool('didInitialize', true);
          result += '\nInitialized, stored, and retrieved encryption key.';
          result += '\nRecorded successful initialization in shared preferences.';
        }
      }
    } else {
      result = 'Retrieved an encryption key from secure storage with no issues.';
    }
    await Log.write('Initialized security protocols.');
    return result;
  }

  static String encrypt(String value) {
    final encrypted = encrypter.encrypt(value, iv: iv);
//    print('Encrypted $value to ${encrypted.base64}');
    return encrypted.base64;
  }

  static String decrypt(String value) {
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(value), iv: iv);
//    print('Decrypted $value to $decrypted');
    return decrypted;
  }

  static Future<void> writeNewKeyInSecureStorage() async {
    String val = Key.fromSecureRandom(32).base64;
    try {
      await secureStorage.write(key: storageKeyKey, value: val);
      print('Stored the key (base64): $val');
    } catch (e) {
      print('Failed to write encryption key to storage');
    }
  }

  static Future<bool> retrieveKeyFromSecureStorage() async {
    String retrievedKey;

    try {
      retrievedKey = await secureStorage.read(key: storageKeyKey);
    } catch (e) {
      print('Failed to retrieve key from secure storage');
    }

    if (retrievedKey != null) {
      key = Key.fromBase64(retrievedKey);
      return true;
    } else {
      return false;
    }
  }

  static Future<void> deleteKey() async => await secureStorage.delete(key: storageKeyKey);

  static String errorStatus = 'Error. Recommend reinstalling the application and inspecting'
      ' your device for any hardware issues.';

  static String goodStatus = 'Ready. Your data will be stored on this device using 256-bit encryption.';

  //TODO strengthen this check
  static String getStatusMessage() {
    if (key != null) {
      return goodStatus;
    } else {
      return errorStatus;
    }
  }
}
