import 'transaction_asset.dart';

class VoteTransactionAsset implements TransactionAsset {

  final Map<String, double> votes;

  VoteTransactionAsset(this.votes);

  @override
  Map<String, dynamic> toMap() {
    return {"votes": votes};
  }
}