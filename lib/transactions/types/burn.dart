import 'dart:typed_data';

import 'package:dart_crypto/exceptions.dart';
import 'package:dart_crypto/networks/network_interface.dart';
import 'package:dart_crypto/transactions.dart';
import 'package:dart_crypto/transactions/transaction.dart';

class BurnTransaction extends Transaction {
  BurnTransaction(
      int amount, {
        String? memo,
        int? fee,
        NetworkInterface? network,
        String? passphrase,
      }) : super(
      network: network,
      passphrase: passphrase,
      typeGroup: Transactions.typeGroupSolar,
      type: Transactions.burn,
      fee: fee,
      memo: memo
  ) {
    if (amount > 0) {
      this.amount = amount;
    } else {
      throw SolarException(message: "Amount of burn transaction can't be 0");
    }
  }

  @override
  bool hasVendorField() {
    return true;
  }

  @override
  List<int> serialize() {
    final List<int> bytes = [];

    final amount = Uint8List(8)
      ..buffer.asByteData().setInt64(0, this.amount, Endian.little);
    bytes.addAll(amount);
    return bytes;
  }
}