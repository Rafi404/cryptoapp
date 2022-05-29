class TransactionModel {
  late String signature;
  late String transactionId;
  bool isLoaded = false;

  late String destinationAddress;
  late String postBalance;
  late String preBalance;
  late int date;

  TransactionModel(
      {required this.signature,
      required this.transactionId,
      required this.destinationAddress,
      required this.preBalance,
      required this.postBalance,
        required this.date,
      });
}
