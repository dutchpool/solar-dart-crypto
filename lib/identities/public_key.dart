import 'package:elliptic/elliptic.dart' as elliptic;

import 'private_key.dart';

class PublicKey {

  static String fromPassphrase(String passphrase) {
    return PrivateKey.fromPassphrase(passphrase).publicKey.toCompressedHex();
  }

  static String fromPrivateKey(elliptic.PrivateKey privateKey) {
    return privateKey.publicKey.toCompressedHex();
  }
}