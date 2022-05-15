import 'dart:convert';

import 'package:hex/hex.dart';

import '../../identities/address.dart';
import '../../networks/network_interface.dart';
import '../../transactions.dart';
import '../transaction.dart';
import '../transaction_assets/vote_transaction_asset.dart';

class VoteTransaction extends Transaction {
  VoteTransaction(
    List<String> votes, {
    String? vendorField,
    int? fee,
    NetworkInterface? network,
    String? passphrase,
  }) : super(
          network: network,
          passphrase: passphrase,
          type: Transactions.vote,
          typeGroup: Transactions.typeGroupCore,
          fee: fee,
          vendorField: vendorField,
        ) {
    asset = VoteTransactionAsset(votes);
    if (passphrase != null) {
      recipientId = Address.fromPassphrase(passphrase);
    }
  }

  @override
  bool hasVendorField() {
    return true;
  }

  @override
  List<int> serialize() {
    final List<int> bytes = [];
    final votes = (asset as VoteTransactionAsset).votes;

    final List<int> voteBytes = [];
    for (final vote in (asset as VoteTransactionAsset).votes) {
      voteBytes.add(vote.length);
      voteBytes.addAll(HEX.decode(vote.startsWith("+") ? "01" : "00"));
      voteBytes.addAll(utf8.encode(vote.substring(1)));
    }
    bytes.add(votes.length);
    bytes.addAll(voteBytes);
    return bytes;
  }
}
