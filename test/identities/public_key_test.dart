import 'package:dart_crypto/identities/private_key.dart';
import 'package:dart_crypto/identities/public_key.dart';
import 'package:test/test.dart';

import 'identities_test_configuration.dart';

void main() {
  test('public key from passphrase', () {
    final publicKey = PublicKey.fromPassphrase(IdentitiesTestConfiguration.publicKey);
    expect(publicKey, IdentitiesTestConfiguration.publicKey);
  });

  test('public key from private key', () {
    final publicKey = PublicKey.fromPrivateKey(PrivateKey.fromHex(IdentitiesTestConfiguration.privateKey));
    expect(publicKey, IdentitiesTestConfiguration.publicKey);
  });
}