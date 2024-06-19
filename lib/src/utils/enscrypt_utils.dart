
import 'package:encrypt/encrypt.dart';

import 'const.dart';

class EncryptUtils {

  static final _key = Key.fromUtf8(Const.fbKeyEnsc);
  static final _iv = IV.fromUtf8(Const.fbIVEnsc);


  static String encrypt(String text) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.sic));

    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(Encrypted encrypted) {

    final encrypter = Encrypter(AES(_key, mode: AESMode.sic));

    return encrypter.decrypt(encrypted, iv: _iv);
  }
}