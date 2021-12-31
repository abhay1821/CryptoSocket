import 'dart:async';
import 'dart:convert';
import 'package:dummy/models/crypto_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class CryptoCurrencies extends StatefulWidget {
  const CryptoCurrencies({Key? key}) : super(key: key);

  @override
  _CryptoCurrenciesState createState() => _CryptoCurrenciesState();
}

class _CryptoCurrenciesState extends State<CryptoCurrencies> {
  int _selectedIndex = 1;
  final _channel = IOWebSocketChannel.connect(
    Uri.parse('ws://prereg.ex.api.ampiy.com/prices'),
  );

  StreamController<List<CryptoDataModel>> controller =
      StreamController<List<CryptoDataModel>>();

  @override
  void initState() {
    super.initState();

    _channel.sink.add(
      jsonEncode(
        {
          "method": "SUBSCRIBE",
          "params": ["all@ticker"],
          "cid": 1
        },
      ),
    );
    _channel.stream.listen((event) {
      print(event.runtimeType);
      if (jsonDecode(event)['data'] != null) {
        controller.add(((jsonDecode(event)['data']) as List)
            .map((e) => CryptoDataModel.fromJson(e as Map<String, dynamic>))
            .toList());
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(15, 40, 1, 0),
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: const Text(
              'COINS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          textFieldView(),
          Expanded(
              child: StreamBuilder<List<CryptoDataModel>>(
                  stream: controller.stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data != null) {
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: const EdgeInsets.all(3),
                            tileColor: index % 2 == 0
                                ? Colors.white
                                : Colors.grey.shade300,
                            leading: CircleAvatar(
                              child: Text(snapshot.data[index].s
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase()),
                            ),
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data[index].s.toString().substring(
                                      0,
                                      snapshot.data[index].s.toString().length -
                                          3),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 15, 4, 5),
                                  child: Text(
                                    '₹ ${snapshot.data[index].c}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            subtitle: Text(snapshot.data[index].s),
                            trailing: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black38,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                        double.parse(snapshot.data[index].c) >
                                                double.parse(
                                                    snapshot.data[index].o)
                                            ? Icons.arrow_upward_outlined
                                            : Icons.arrow_downward_outlined,
                                        color: double.parse(
                                                    snapshot.data[index].c) >
                                                double.parse(
                                                    snapshot.data[index].o)
                                            ? Colors.green
                                            : Colors.red),
                                    Text(
                                        "${double.parse(snapshot.data[index].percent).toStringAsFixed(3)}%"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 3,
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: const Icon(
          Icons.compare_arrows_outlined,
          color: Colors.black,
        ),
        elevation: 8.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Coins',
          ),
          BottomNavigationBarItem(
            icon: SizedBox(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'You',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget textFieldView() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(8)),
            fillColor: Colors.white.withOpacity(0.1),
            filled: true,
            contentPadding: const EdgeInsets.all(8)),
        onSubmitted: (value) {},
      ),
    );
  }
}
