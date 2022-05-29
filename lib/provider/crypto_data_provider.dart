import 'dart:convert';
import 'package:crypto_app/models/transaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CryptoDataProvider extends ChangeNotifier {

  ///API call
  List<TransactionModel> transactions = [];
  bool isLoading = false;

  void updateLoaderStatus(bool isLoading) {
    this.isLoading = isLoading;
    print("LOADING $isLoading");
    notifyListeners();
  }

  void updateLoaderStatusTile(bool isLoading, int index) {
    this.transactions[index].isLoaded = !isLoading;
    notifyListeners();
  }

  void updateTile(int date, int index) {
    this.transactions[index].date = date;
    notifyListeners();
  }

  void updateTransactions(List<TransactionModel> transactions) {
    this.transactions = transactions;
    notifyListeners();
    for (int i = 0; i < transactions.length; i++) {
      getTransaction(i);
    }
  }

  ///get signatures from api
  void getSignatures() async {
    final backendUrl = "https://api.mainnet-beta.solana.com";

    final body = jsonEncode({
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getSignaturesForAddress",
      "params": [
        "DDP1Mk93KkxP1P7gkfwbvfWafYVMafKdoZnS33PChhdS",
        {"limit": 10}
      ]
    });

    updateLoaderStatus(true);

    final data = await http.post(Uri.parse(backendUrl),
        body: body, headers: {"Content-Type": "application/json"});

    updateLoaderStatus(false);
    final result = json.decode(data.body);

    List<TransactionModel> transactions = [];
    for (final data in result["result"]) {
      try {
        transactions.add(TransactionModel(
          signature: data["signature"],
          transactionId: "",
          destinationAddress: "",
          postBalance: "",
          preBalance: "",
          date: 0,
        ));
      } catch (e) {
        print(e);
      }
    }
    updateTransactions(transactions);
  }

  ///get transactions from api
  void getTransaction(int index) async {
    final backendUrl = "https://api.mainnet-beta.solana.com";

    final body = jsonEncode({
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getTransaction",
      "params": [this.transactions[index].signature, "json"]
    });

    updateLoaderStatusTile(true, index);

    final data = await http.post(Uri.parse(backendUrl),
        body: body, headers: {"Content-Type": "application/json"});

    updateLoaderStatusTile(false, index);
    final result = json.decode(data.body);
    final date = result["result"]["blockTime"];
    this.transactions[index].destinationAddress =
        result["result"]["transaction"]["message"]["accountKeys"][1];
    this.transactions[index].preBalance =
        result["result"]["meta"]["preBalances"][0].toString();
    this.transactions[index].postBalance =
        result["result"]["meta"]["postBalances"][0].toString();

    updateTile(date, index);
  }
}
