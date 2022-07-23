import 'dart:convert';
import 'dart:typed_data';

import '../../identities/address.dart';
import '../../networks/network_interface.dart';
import '../../transactions.dart';
import '../transaction.dart';
import '../transaction_assets/vote_transaction_asset.dart';

class VoteTransaction extends Transaction {
  VoteTransaction(
    Map<String, double> votes, {
    String? memo,
    int? fee,
    NetworkInterface? network,
    String? passphrase,
  }) : super(
          network: network,
          passphrase: passphrase,
          type: Transactions.solarVote,
          typeGroup: Transactions.typeGroupSolar,
          fee: fee,
          memo: memo,
        ) {
    asset = VoteTransactionAsset(votes);
    if (passphrase != null) {
      recipientId = Address.fromPassphrase(passphrase);
    }

    //TODO: add checks if total percentage is exactly 100%
  }

  factory VoteTransaction.fromVoteList(
    List<String> votesList, {
    String? memo,
    int? fee,
    NetworkInterface? network,
    String? passphrase,
  }) {
    const hundredPercentTwoDecimals = 10000;
    final filteredVoteList = votesList
        .where((vote) => !vote.startsWith("-"))
        .map((vote) => vote.replaceAll("+", ""));
    final weight = hundredPercentTwoDecimals ~/ filteredVoteList.length;
    int remainder = hundredPercentTwoDecimals;
    Map<String, double> votes = {};
    for (final vote in filteredVoteList) {
      votes[vote] = weight / 100;
      remainder -= weight;
    }

    for (int i = 0; i < remainder; i++) {
      final key = votes.keys.toList()[i];
      votes[key] = (((votes[key] ?? 0) + 0.01) * 100).round() / 100;
    }

    return VoteTransaction(
      votes,
      memo: memo,
      fee: fee,
      network: network,
      passphrase: passphrase,
    );
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

    for (final vote in votes.keys) {
      voteBytes.add(vote.length);
      voteBytes.addAll(utf8.encode(vote));

      final percent = Uint8List(2)
        ..buffer.asByteData().setInt16(0, ((votes[vote] ?? 0) * 100).round(), Endian.little);
      voteBytes.addAll(percent);
    }

    bytes.add(votes.length);
    bytes.addAll(voteBytes);
    return bytes;
  }
}
