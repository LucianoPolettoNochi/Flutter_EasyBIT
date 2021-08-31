import 'dart:convert';
import 'package:easybit/app/data/models/binance_model.dart';
import 'package:easybit/utility/app_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var exchangesList;
  RxDouble totalValue = double.parse("0").obs;
  RxBool isLoadingInitial = true.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    loadExchangesList();
    super.onInit();
  }

  var fiatListDrop = [
    PopupMenuItem(
      child: Text("USD \$"),
      value: "USD",
    ),
    PopupMenuItem(
      child: Text("EUR €"),
      value: "EUR",
    ),
    PopupMenuItem(
      child: Text("GBP £"),
      value: "GBP",
    )
  ];
  RxString fiatCurrencySymbol = 'R\$'.obs;
  RxString fiatCurrency = 'BRL'.obs;

  _deleteInfo(exchange, index) {
    // scaffoldState.currentState.showSnackBar(SnackBar(
    //   content: Text('Removed ${exchange['name']}'),
    //   action: SnackBarAction(
    //     label: "Undo",
    //     onPressed: () {
    //       this.exchangesList.insert(index, exchange);
    //       this.totalValue.value += double.parse(exchange['data']['value']);
    //
    //       _updateStorage();
    //     },
    //   ),
    // ));
  }

  getFiatCurrency(fiat) async {
    isLoadingInitial.value = true;

    var fiatSymbol;
    switch (fiat) {
      case 'USD':
        fiatSymbol = "\$";
        break;
      case 'EUR':
        fiatSymbol = "€";
        break;
      case 'GBP':
        fiatSymbol = "£";
        break;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('fiatCurrency', fiat);
    prefs.setString('fiatCurrencySymbol', fiatSymbol);

    this.loadExchangesList();
  }

  loadExchangesList() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String exchangesString = prefs.getString('exchangesList') ?? '[]';
    this.fiatCurrency.value = prefs.getString('fiatCurrency') ?? 'EUR';
    this.fiatCurrencySymbol.value = prefs.getString('fiatCurrencySymbol') ?? '€';
    this.exchangesList = json.decode(exchangesString);

    for (var i = 0; i < this.exchangesList.length; i++) {
      var exchange = this.exchangesList[i];
      _fetchExchange(Function fetcher, fiat) async {
        AccountSnapshot data = await fetcher(exchange, fiat);

        if (data.snapshotVos.length > 0) {
          exchange['totalAssetOfBtc'] = data.snapshotVos.last.data?.totalAssetOfBtc;
          exchange['data'] = data;
        } else
          msgSnack('Aviso', data.msg.toString());
      }

      switch (exchange['name']) {
        case 'Binance':
          await _fetchExchange(fetchBinance, this.fiatCurrency);
          break;
        /*case 'Coinbase':
          await _fetchExchange(fetchCoinbase, this.fiatCurrency);
          break;
        case 'Coinbase Pro':
          await _fetchExchange(fetchCoinbasePro, this.fiatCurrency);
          break;
        case 'Bittrex':
          await _fetchExchange(fetchBittrex, this.fiatCurrency);
          break;

        case 'Mercatox':
          await _fetchExchange(fetchMercatox, this.fiatCurrency);
          break;*/
      }
    }
    isLoadingInitial.value = false;
    isLoading.value = false;
    exchangesString = "";
    totalValue.value = 0;
    if (exchangesList.length > 0 && exchangesList[0]['data'] != null) {
      totalValue.value = double.parse(exchangesList?[0]['totalAssetOfBtc'] ?? 0); // _total;
      exchangesString = json.encode(this.exchangesList);
      prefs.setString('exchangesList', exchangesString);
    }
  }

  _updateStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var exchangesString = json.encode(this.exchangesList);
    prefs.setString('exchangesList', exchangesString);
  }

  createBalanceCard(exchange, index, context) {
    final makeListTile = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Image.asset(
            exchange['icon'],
            height: 40,
            width: 40,
          ),
        ),
        title: Text(
          exchange['name'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.account_balance_wallet,
              color: Colors.yellowAccent,
              size: 15,
            ),
            Text(
              " BTC: ${fiatCurrencySymbol.value} ${exchange['data'] != null ? exchange['totalAssetOfBtc'] : "0"}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));

    var makeCard;

    makeCard = Dismissible(
        key: Key(exchange['name']),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            _deleteInfo(exchange, index);

            this.exchangesList.remove(exchange);
            _updateStorage();
            if (this.exchangesList.length >= 1)
              this.totalValue.value -= double.parse(exchange['totalAssetOfBtc']);
            else
              this.totalValue.value = 0;
          }
        },
        direction: DismissDirection.endToStart,
        background: Container(
          padding: EdgeInsets.only(right: 20),
          alignment: AlignmentDirectional.centerEnd,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        child: Card(
          elevation: 10,
          color: Colors.transparent,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: InkWell(
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(64, 75, 96, 0.9), borderRadius: BorderRadius.circular(20)),
              child: makeListTile,
            ),
            onTap: () {
              if (exchange['data'] != null && exchange['totalAssetOfBtc'] != null)
                Get.toNamed('/wallet', arguments: {'exchange': exchange, 'fiatSymbol': fiatCurrencySymbol.value});
            },
            borderRadius: BorderRadius.circular(20),
          ),
        ));

    return makeCard;
  }
}
