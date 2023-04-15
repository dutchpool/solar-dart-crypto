class Transactions {

  static const int legacyTransfer = 0;
  static const int secondSignatureRegistration = 1;
  static const int delegateRegistration = 2;
  static const int vote = 3;
  static const int multiSignatureRegistration = 4;
  static const int ipfs = 5;
  static const int transfer = 6;
  static const int delegateResignation = 7;
  static const int htlcLock = 8;
  static const int htlcClaim = 9;
  static const int htlcRefund = 10;

  static const int burn = 0;
  static const int solarVote = 2;

  static const Map<int, String> transactionTypes = {
    legacyTransfer: 'transferOld', // Disabled in core
    secondSignatureRegistration: 'second_signature_registration',
    delegateRegistration: 'delegate_registration',
    vote: 'vote',
    multiSignatureRegistration: 'multi_signature_registration',
    ipfs: 'ipfs',
    transfer: 'transfer',
    delegateResignation: 'delegate_resignation',
    htlcLock: 'htlc_lock',
    htlcClaim: 'htlc_claim',
    htlcRefund: 'htlc_refund',
  };

  static const Map<int, String> transactionTypesSolar = {
    burn: 'burn',
  };

  static const Map<int, int> transactionFees = {
    legacyTransfer: 100000000,
    secondSignatureRegistration: 500000000,
    delegateRegistration: 2500000000,
    vote: 100000000,
    multiSignatureRegistration: 500000000,
    ipfs: 500000000,
    transfer: 10000000,
    delegateResignation: 2500000000,
    htlcLock: 10000000,
    htlcClaim: 0,
    htlcRefund: 0,
  };

  static const Map<int, int> transactionFeesSolar = {
    burn: 0,
  };

  static const Map<int, bool> hasMemoField = {
    legacyTransfer: true,
    secondSignatureRegistration: false,
    delegateRegistration: false,
    vote: true,
    multiSignatureRegistration: false,
    ipfs: false,
    transfer: true,
    delegateResignation: true,
    htlcLock: false,
    htlcClaim: false,
    htlcRefund: false,
  };

  static const Map<int, bool> hasVendorFieldSolar = {
    burn: true,
  };

  static const int typeGroupTest = 0;
  static const int typeGroupCore = 1;
  static const int typeGroupSolar = 2;
}
