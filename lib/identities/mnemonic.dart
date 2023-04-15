import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;

class Mnemonic {
  static String generateMnemonicPassphrase() {
    final mnemonic = bip39.Mnemonic.generate(
      bip39.Language.english,
      passphrase: "",
      entropyLength: 128,
    );
    return mnemonic.sentence;
  }
}