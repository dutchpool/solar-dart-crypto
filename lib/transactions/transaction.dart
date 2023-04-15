import 'dart:convert';

import 'package:bip340/bip340.dart';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'dart:math';

import '../configuration/network.dart';
import '../identities/private_key.dart';
import '../identities/public_key.dart';
import '../networks/network_interface.dart';
import '../transactions.dart';
import 'serializer.dart';
import 'transaction_assets/transaction_asset.dart';

abstract class Transaction {
  int? version = 3;
  int? network;
  int? typeGroup;
  late int type;
  int? nonce;
  String? senderPublicKey;
  int fee = 0;
  String? memo;
  String? memoHex;
  TransactionAsset? asset;
  String? signature;
  String? secondSignature;
  List<String>? signatures;
  int amount = 0;
  int? expiration;
  String? recipientId;
  String? id;

  Transaction({
    NetworkInterface? network,
    String? passphrase,
    required this.type,
    int? typeGroup,
    int? fee,
    String? memo,
  }) {
    this.network = network == null
        ? Network.instance.network.version()
        : network.version();
    if (passphrase != null) {
      senderPublicKey = PublicKey.fromPassphrase(passphrase);
    }
    this.typeGroup = typeGroup ?? Transactions.typeGroupCore;
    if (type != 0) {
      amount = 0;
    }
    this.fee = fee ?? Transactions.transactionFees[type]!;
    if (Transactions.hasMemoField[type] ?? false) {
      this.memo = memo;
    }
  }

  void computeId() {
    id = getId();
  }

  String getId() {
    return HEX.encode(
      sha256
          .convert(Serializer(this).serialize(
            skipSignature: false,
            skipSecondSignature: false,
            skipMultiSignature: false,
          ))
          .bytes,
    );
  }

  bool hasMemo() {
    return false;
  }

  List<int> serialize();

  void schnorrSign(String passphrase) {
    if (version != 3) {
      //TODO: error
    }
    final msg = Serializer(this).serialize(
      skipSignature: false,
      skipSecondSignature: true,
      skipMultiSignature: false,
    );
    final privateKey = PrivateKey.fromPassphrase(passphrase);
    final hash = sha256.convert(msg).bytes;
    if (version! > 2) {
      final random = Random.secure();
      final aux =
          HEX.encode(List<int>.generate(32, (i) => random.nextInt(256)));
      signature = sign(privateKey.toHex(), HEX.encode(hash), aux);
    }
    computeId();
  }

  String toJson() {
    final Map<String, dynamic> map = {};
    map["version"] = version;
    map["network"] = network;
    map["typeGroup"] = typeGroup;
    map["type"] = type;
    map["nonce"] = nonce;
    map["senderPublicKey"] = senderPublicKey;
    map["fee"] = fee;
    map["amount"] = amount;
    map["recipientId"] = recipientId;
    map["signature"] = signature;
    if (expiration != null) {
      map["expiration"] = expiration;
    }
    if (asset != null) {
      map["asset"] = asset?.toMap();
    }
    map["id"] = id;
    if (memo != null) {
      map["memo"] = memo;
    }
    return jsonEncode(map);
  }
}
