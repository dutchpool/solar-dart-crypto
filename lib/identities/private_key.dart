import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
// import 'package:secp256k1/secp256k1.dart' as secp256k1;
import 'package:elliptic/elliptic.dart' as elliptic;

import 'public_key.dart';

class PrivateKey {

  static elliptic.PrivateKey fromPassphrase(String passphrase) {
    final privateKey = sha256.convert(utf8.encode(passphrase)).bytes;
    return elliptic.PrivateKey.fromHex(elliptic.getSecp256k1(), HEX.encode(privateKey));
    // return secp256k1.PrivateKey.fromHex(HEX.encode(privateKey));
  }

  static elliptic.PrivateKey fromHex(String hex) {
    return elliptic.PrivateKey.fromHex(elliptic.getSecp256k1(), hex);
  }
}