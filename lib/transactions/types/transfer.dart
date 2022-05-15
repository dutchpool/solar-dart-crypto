import 'dart:typed_data';

import 'package:base58check/base58check.dart';
import 'package:dart_crypto/exceptions.dart';

import '../../networks/network_interface.dart';
import '../../transactions.dart';
import '../transaction.dart';

class TransferTransaction extends Transaction {
  TransferTransaction(
    String recipientId,
    int amount, {
    String? vendorField,
    int? fee,
    NetworkInterface? network,
    String? passphrase,
  }) : super(
          network: network,
          passphrase: passphrase,
          type: Transactions.transfer,
          fee: fee,
          vendorField: vendorField
        ) {
    this.recipientId = recipientId;
    if (amount > 0) {
      this.amount = amount;
    } else {
      throw SolarException(message: "Amount of transfer transaction can't be 0");
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

    final expiration = Uint8List(4)
      ..buffer.asByteData().setInt32(0, this.expiration ?? 0, Endian.little);
    bytes.addAll(expiration);

    final recipientBase58Decodes =
        Base58CheckCodec.bitcoin().decode(recipientId!);
    bytes.add(recipientBase58Decodes.version);
    bytes.addAll(recipientBase58Decodes.payload);
    return bytes;
  }
}
