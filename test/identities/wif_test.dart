import 'package:dart_crypto/identities/wif.dart';
import 'package:test/test.dart';

import 'identities_test_configuration.dart';

void main() {
  test('wif from passphrase', () {
    final wif = Wif.wifFromPassphrase(IdentitiesTestConfiguration.passphrase);
    expect(wif, IdentitiesTestConfiguration.wif);
  });
}