import 'package:base58check/base58check.dart';
import 'package:hex/hex.dart';

import '../configuration/network.dart';
import 'private_key.dart';

class Wif {

  static String wifFromPassphrase(String passphrase, {int? networkWif}) {
    int safeNetworkWif = networkWif ?? Network.instance.network.wif();

    final privateKey = PrivateKey.fromPassphrase(passphrase);
    final List<int> seed = HEX.decode(privateKey.toHex()) + [0x01];

    final payload = Base58CheckPayload(safeNetworkWif, seed);
    return Base58CheckCodec.bitcoin().encode(payload);
  }
}