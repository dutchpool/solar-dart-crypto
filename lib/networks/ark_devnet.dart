import 'network_interface.dart';

class ArkDevnet implements NetworkInterface {
  @override
  DateTime epoch() => DateTime(2017, 3, 21, 00, 00, 00);

  @override
  int version() => 30;

  @override
  int wif() => 170;

}