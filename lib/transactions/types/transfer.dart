import 'dart:typed_data';

import 'package:base58check/base58check.dart';
import 'package:dart_crypto/exceptions.dart';
import 'package:dart_crypto/identities/address.dart';
import 'package:dart_crypto/transactions/transaction_assets/transfer_transaction_asset.dart';

import '../../networks/network_interface.dart';
import '../../transactions.dart';
import '../transaction.dart';

class TransferTransaction extends Transaction {
  TransferTransaction({
    List<TransferTransactionAssetRecipientAmount> transfers = const [],
    String? memo,
    int? fee,
    NetworkInterface? network,
    String? passphrase,
  }) : super(
            network: network,
            passphrase: passphrase,
            type: Transactions.transfer,
            fee: fee,
            memo: memo) {
    // _transfers.addAll(transfers);
    asset = TransferTransactionAsset(transfers);
    if (passphrase != null) {
      recipientId = Address.fromPassphrase(passphrase);
    }
    // this.recipientId = recipientId;
    // if (amount > 0) {
    //   this.amount = amount;
    // } else {
    //   throw SolarException(
    //       message: "Amount of transfer transaction can't be 0");
    // }
  }

  void addTransfer(String recipientId, int amount) {
    (asset as TransferTransactionAsset).transfers.add(
          TransferTransactionAssetRecipientAmount(
            recipientId: recipientId,
            amount: amount,
          ),
        );
  }

  @override
  bool hasMemo() {
    return true;
  }

  @override
  List<int> serialize() {
    final List<int> bytes = [];
    final transfers = (asset as TransferTransactionAsset).transfers;

    final length = Uint8List(2)
      ..buffer.asByteData().setInt16(0, transfers.length, Endian.little);

    final List<int> transferBytes = [];
    for (final transfer in transfers) {
      if (!Address.validateAddress(transfer.recipientId)) {
        throw SolarException(message: "${transfer.recipientId} is not valid");
      }
      final amount = Uint8List(8)
        ..buffer.asByteData().setInt64(0, transfer.amount, Endian.little);
      transferBytes.addAll(amount);

      final recipientBase58Decodes =
          Base58CheckCodec.bitcoin().decode(transfer.recipientId);
      transferBytes.add(recipientBase58Decodes.version);
      transferBytes.addAll(recipientBase58Decodes.payload);
    }

    bytes.addAll(length);
    bytes.addAll(transferBytes);
    return bytes;
  }
}
