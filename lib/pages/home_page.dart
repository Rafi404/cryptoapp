import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../const.dart';
import 'package:crypto_app/provider/crypto_data_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      final cryptoProvider = context.read<CryptoDataProvider>();
      cryptoProvider.getSignatures();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cryptoProvider = Provider.of<CryptoDataProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          title: Text(appBarTitle),
        ),
        body: Builder(
          builder: (context) {
            return Stack(
              children: [
                Positioned.fill(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cryptoProvider
                                      .transactions[index].destinationAddress ==
                                  sourceAddress
                              ? Text("Receive",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                              : Text(
                                  "Send",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          cryptoProvider
                                      .transactions[index].destinationAddress ==
                                  sourceAddress
                              ? Text(
                                  '+' +
                                      ((int.parse(cryptoProvider
                                                  .transactions[index]
                                                  .preBalance) -
                                              int.parse(cryptoProvider
                                                      .transactions[index]
                                                      .preBalance) /
                                                  1000000000))
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.greenAccent))
                              : Text(
                                  '-' +
                                      ((int.parse(cryptoProvider
                                                  .transactions[index]
                                                  .preBalance) -
                                              int.parse(cryptoProvider
                                                      .transactions[index]
                                                      .preBalance) /
                                                  1000000000))
                                          .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ))
                        ],
                      ),
                      leading: cryptoProvider.transactions[index].isLoaded ||
                              cryptoProvider
                                      .transactions[index].destinationAddress ==
                                  sourceAddress
                          ? Icon(Icons.call_made)
                          : Icon(Icons.call_received),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            DateFormat("MM-dd hh:mm:ss").format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    cryptoProvider.transactions[index].date)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: Text(
                              " TXID:" +
                                  cryptoProvider.transactions[index].signature,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                print('copy');

                                Fluttertoast.showToast(
                                    msg: "Text copied to clipboard",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.grey,
                                    textColor: Colors.black,
                                    fontSize: 16.0);

                                Clipboard.setData(ClipboardData(
                                    text: cryptoProvider
                                        .transactions[index].signature));
                              },
                              icon: Icon(
                                Icons.content_copy,
                                size: 15,
                              ))
                        ],
                      ),
                    );
                  },
                  itemCount: cryptoProvider.transactions.length,
                )),
                if (cryptoProvider.isLoading)
                  Center(child: CircularProgressIndicator())
              ],
            );
          },
        ));
  }
}
