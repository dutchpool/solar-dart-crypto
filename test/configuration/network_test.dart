import 'package:dart_crypto/configuration/network.dart';
import 'package:dart_crypto/networks/mainnet.dart';
import 'package:dart_crypto/networks/testnet.dart';
import 'package:test/test.dart';

void main() {
  test('get network', () {
    final network = Network.instance.network;
    expect(network.version(), 30);
  });

  test('set network', () {
    // Test main net
    Network.instance.network = Mainnet();
    final network1 = Network.instance.network;
    expect(network1.version(), 63);
    expect(network1.wif(), 252);

    // Test test net
    Network.instance.network = Testnet();
    final network2 = Network.instance.network;
    expect(network2.version(), 30);
    expect(network2.wif(), 252);
  });
}