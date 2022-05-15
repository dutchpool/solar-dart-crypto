import 'dart:typed_data';

import 'package:base58check/base58check.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/pointycastle.dart' hide PrivateKey, PublicKey;

import '../configuration/network.dart';
import 'private_key.dart';
import 'public_key.dart';

class Address {

  static String fromPublicKey(String publicKey, {int? networkVersion}) {
    int safeNetworkVersion = networkVersion ?? Network.instance.network.version();

    final ripemd160 = Digest('RIPEMD-160').process(Uint8List.fromList(HEX.decode(publicKey)));
    final payload = Base58CheckPayload(safeNetworkVersion, ripemd160.toList());
    return Base58CheckCodec.bitcoin().encode(payload);
  }

  static String fromPrivateKey(String privateKey, {int? networkVersion}) {
    final privateKeyFromHex = PrivateKey.fromHex(privateKey);
    final publicKey = PublicKey.fromPrivateKey(privateKeyFromHex);
    return fromPublicKey(publicKey, networkVersion: networkVersion);
  }

  static String fromPassphrase(String passphrase, {int? networkVersion}) {
    final privateKeyFromAddress = PrivateKey.fromPassphrase(passphrase);
    final publicKey = PublicKey.fromPrivateKey(privateKeyFromAddress);
    return fromPublicKey(publicKey, networkVersion: networkVersion);
  }

  static bool validateAddress(String address, {int? networkVersion}) {
    int safeNetworkVersion = networkVersion ?? Network.instance.network.version();

    return safeNetworkVersion == Base58CheckCodec.bitcoin().decode(address).version;
  }
}