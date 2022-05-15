import 'network_interface.dart';

class Mainnet implements NetworkInterface {
  @override
  DateTime epoch() => DateTime(2022, 3, 28, 18, 00, 00);

  @override
  int version() => 63;

  @override
  int wif() => 252;

}