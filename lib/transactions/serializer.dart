import 'dart:convert';
import 'dart:typed_data';

import 'package:hex/hex.dart';

import '../configuration/network.dart';
import 'transaction.dart';

class Serializer {
  final Transaction _transaction;

  Serializer(this._transaction);

  List<int> serialize(
      {bool skipSignature = true,
      bool skipSecondSignature = true,
      bool skipMultiSignature = true}) {

    final List<int> common = _serializeCommon();
    final List<int> vendorField = _serializeMemo();
    final List<int> transaction = _transaction.serialize();
    final List<int> signatures = _serializeSignatures(
      skipSignature: skipSignature,
      skipSecondSignature: skipSecondSignature,
      skipMultiSignature: skipMultiSignature,
    );
    List<int> bytes = [];
    bytes.addAll(common);
    bytes.addAll(vendorField);
    bytes.addAll(transaction);
    bytes.addAll(signatures);

    return bytes;
  }

  List<int> _serializeCommon() {
    final network = Network.instance.network;
    final List<int> bytes = [];
    bytes.add(0xff);
    bytes.add(_transaction.version ?? 0x02);
    bytes.add(_transaction.network ?? network.version());

    final typeGroup = Uint8List(4)
      ..buffer
          .asByteData()
          .setInt32(0, _transaction.typeGroup ?? 1, Endian.little);
    bytes.addAll(typeGroup);

    final type = Uint8List(2)
      ..buffer.asByteData().setInt16(0, _transaction.type, Endian.little);
    bytes.addAll(type);

    final nonce = Uint8List(8)
      ..buffer.asByteData().setInt64(0, _transaction.nonce ?? 1, Endian.little);
    bytes.addAll(nonce);

    bytes.addAll(
      HEX.decode(_transaction.senderPublicKey!),
    );

    final fee = Uint8List(8)
      ..buffer.asByteData().setInt64(0, _transaction.fee, Endian.little);
    bytes.addAll(fee);

    return bytes;
  }

  List<int> _serializeMemo() {
    //TODO: max length 255
    final List<int> bytes = [];
    if (_transaction.hasMemo()) {
      if (_transaction.memo != null &&
          _transaction.memo!.isNotEmpty) {
        final memo = utf8.encode(_transaction.memo!);
        // final length = _transaction.memo!.length;
        final length = memo.length;
        // bytes.add(length);
        final lengthByte = Uint8List(1)
          ..buffer.asByteData().setInt8(0, length);
        bytes.addAll(lengthByte);
        bytes.addAll(memo);
        // bytes.addAll(utf8.encode(_transaction
        //     .memo!));
      } else if (_transaction.memoHex != null &&
          _transaction.memoHex!.isNotEmpty) {
        final length = _transaction.memoHex!.length;
        bytes.add(length);
        final lengthByte = Uint8List(1)
          ..buffer.asByteData().setInt8(0, length);
        // bytes.add(length);
        bytes.addAll(HEX.decode(_transaction.memoHex!));
      } else {
        bytes.add(0x00);
      }
    } else {
      bytes.add(0x00);
    }
    return bytes;
  }

  List<int> _serializeSignatures({
    required bool skipSignature,
    required bool skipSecondSignature,
    required bool skipMultiSignature,
  }) {
    final List<int> bytes = [];
    if (!skipSignature && _transaction.signature != null) {
      bytes.addAll(HEX.decode(_transaction.signature!));
    }
    if (!skipSecondSignature && _transaction.secondSignature != null) {
      bytes.addAll(HEX.decode(_transaction.secondSignature!));
    }

    if (!skipMultiSignature &&
        _transaction.signatures != null &&
        _transaction.signatures!.isNotEmpty) {
      bytes.addAll(HEX.decode(_transaction.signatures!.join("")));
    }
    return bytes;
  }
}
