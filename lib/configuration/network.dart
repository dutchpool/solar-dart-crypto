import 'package:dart_crypto/networks/testnet.dart';

import '../networks/mainnet.dart';
import '../networks/network_interface.dart';

class Network {

  Network._();

  static final Network _instance = Network._();

  static Network get instance => _instance;

  NetworkInterface _network = Testnet();

  NetworkInterface get network => _network;
  set network(NetworkInterface network) {
    _network = network;
  }

}