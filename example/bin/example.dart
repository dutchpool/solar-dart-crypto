import 'package:dart_crypto/identities/address.dart';
import 'package:dart_crypto/identities/mnemonic.dart';
import 'package:dart_crypto/identities/public_key.dart';
import 'package:dart_crypto/networks/testnet.dart';
import 'package:dart_crypto/transactions/types/burn.dart';
import 'package:dart_crypto/transactions/types/transfer.dart';
import 'package:dart_crypto/transactions/types/vote.dart';

void main(List<String> arguments) {
  generateMnemonicPassphrase();
  getAddressFromPassphrase();
  validateAddress();
  createTransferTransaction();
  createVoteTransaction();
  createBurnTransaction();
}

void generateMnemonicPassphrase() {
  final passphrase = Mnemonic.generateMnemonicPassphrase();
  final network = Testnet();
  final address = Address.fromPassphrase(
    passphrase,
    networkVersion: network.version(),
  );
  print(address);
  print(passphrase);
}

void getAddressFromPassphrase() {
  final address = Address.fromPublicKey(
    PublicKey.fromPassphrase("this is a top secret passphrase"),
    networkVersion: Testnet().version(),
  );
  print("Address: $address");
}

void validateAddress() {
  const address = "D61mfSggzbvQgTUe6JhYKH2doHaqJ3Dyib";
  final isValid = Address.validateAddress(
    address,
    networkVersion: Testnet().version(),
  );
  print("Is address $address valid? $isValid");
}

void createTransferTransaction() {
  final TransferTransaction transferTransaction = TransferTransaction(
    "D61mfSggzbvQgTUe6JhYKH2doHaqJ3Dyib",
    100000000,
    fee: 10000000,
  );

  final passphrase = "this is a top secret passphrase";

  transferTransaction.network = Testnet().version();
  transferTransaction.nonce = 1; // Get the current nonce from the api and increase by 1
  transferTransaction.expiration = 0;
  transferTransaction.senderPublicKey = PublicKey.fromPassphrase(passphrase);
  transferTransaction.memo = "dart_crypto"; // It is optional to add a memo

  transferTransaction.schnorrSign(passphrase);
  print("Transfer Transaction: ${transferTransaction.toJson()}");

  // The result of voteTransaction.toJson() can be send as a POST to
  // https://sxp.testnet.sh/api/transactions with the following body:
  // {"transactions": [ <the generated transaction data> ]}
}

void createVoteTransaction() {
  final VoteTransaction voteTransaction = VoteTransaction.fromVoteList(
    ["st3v3n"],
    fee: 10000000, // Static fee is used when not given
  );

  final passphrase = "this is a top secret passphrase";

  voteTransaction.network = Testnet().version();
  voteTransaction.nonce = 1; // Get the current nonce from the api and increase by 1
  voteTransaction.senderPublicKey = PublicKey.fromPassphrase(passphrase);
  voteTransaction.recipientId = Address.fromPassphrase(passphrase);
  voteTransaction.memo = "dart_crypto"; // It is optional to add a memo

  voteTransaction.schnorrSign(passphrase);
  print("Vote Transaction: ${voteTransaction.toJson()}");

  // The result of voteTransaction.toJson() can be send as a POST to
  // https://sxp.testnet.sh/api/transactions with the following body:
  // {"transactions": [ <the generated transaction data> ]}
}

void createBurnTransaction() {
  final BurnTransaction burnTransaction = BurnTransaction(
    10000000,
  );

  final passphrase = "this is a top secret passphrase";

  burnTransaction.network = Testnet().version();
  burnTransaction.nonce = 1; // Get the current nonce from the api and increase by 1
  burnTransaction.senderPublicKey = PublicKey.fromPassphrase(passphrase);
  burnTransaction.memo = "dart_crypto"; // It is optional to add a memo

  burnTransaction.schnorrSign(passphrase);
  print("Burn Transaction: ${burnTransaction.toJson()}");

  // The result of voteTransaction.toJson() can be send as a POST to
  // https://sxp.testnet.sh/api/transactions with the following body:
  // {"transactions": [ <the generated transaction data> ]}
}

