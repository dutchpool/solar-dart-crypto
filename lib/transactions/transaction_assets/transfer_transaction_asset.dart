import 'transaction_asset.dart';

class TransferTransactionAsset implements TransactionAsset {
  final List<TransferTransactionAssetRecipientAmount> transfers;

  TransferTransactionAsset(this.transfers);

  @override
  Map<String, dynamic> toMap() {
    return {"transfers": transfers.map((transfer) => transfer.toMap()).toList()};
  }
}

class TransferTransactionAssetRecipientAmount {
  final String recipientId;
  final int amount;

  TransferTransactionAssetRecipientAmount({
    required this.recipientId,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {"recipientId": recipientId, "amount": amount};
  }
}
