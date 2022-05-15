import 'network_interface.dart';

class Testnet implements NetworkInterface {
  @override
  DateTime epoch() => DateTime(2022, 3, 16, 18, 00, 00);

  @override
  int version() => 30;

  @override
  int wif() => 252;

}