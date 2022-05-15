import 'package:dart_crypto/identities/address.dart';
import 'package:test/test.dart';

import 'identities_test_configuration.dart';

void main() {
  test('address from public key', () {
    final address = Address.fromPublicKey(IdentitiesTestConfiguration.publicKey);
    expect(address, IdentitiesTestConfiguration.address);
  });

  test('address from private key', () {
    final address = Address.fromPrivateKey(IdentitiesTestConfiguration.privateKey);
    expect(address, IdentitiesTestConfiguration.address);
  });

  test('address from passphrase', () {
    final address = Address.fromPassphrase(IdentitiesTestConfiguration.passphrase);
    expect(address, IdentitiesTestConfiguration.address);
  });

  test('validate address', () {
    expect(Address.validateAddress(IdentitiesTestConfiguration.address), true);
  });
}