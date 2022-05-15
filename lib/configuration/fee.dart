import '../exceptions.dart';
import '../transactions.dart';

class Fee {

  Fee._();

  static final Fee _instance = Fee._();

  static Fee get instance => _instance;

  var fees = Transactions.transactionFees;

  int getFee(int transactionType) {
    final fee = fees[transactionType];
    if (fee == null) {
      throw SolarException(message: "Unknown transaction type: $transactionType");
    } else {
      return fee;
    }
  }
}