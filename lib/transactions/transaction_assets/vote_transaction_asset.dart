import 'transaction_asset.dart';

class VoteTransactionAsset implements TransactionAsset {

  final List<String> votes;

  VoteTransactionAsset(this.votes);

  @override
  Map<String, dynamic> toMap() {
    return {"votes": votes};
  }
}