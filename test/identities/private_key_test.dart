import 'package:dart_crypto/identities/private_key.dart';
import 'package:hex/hex.dart';
import 'package:test/test.dart';

import 'identities_test_configuration.dart';

void main() {
  test('private key from passphrase', () {
    final privateKey = PrivateKey.fromPassphrase(IdentitiesTestConfiguration.passphrase);
    expect(HEX.encode(privateKey.bytes), IdentitiesTestConfiguration.privateKey);
  });

  test('private key from hex', () {
    final privateKey = PrivateKey.fromHex(IdentitiesTestConfiguration.privateKey);
    expect(HEX.encode(privateKey.bytes), IdentitiesTestConfiguration.privateKey);
  });
}