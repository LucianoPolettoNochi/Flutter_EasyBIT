import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigController extends GetxController {
  final exchangesList = [
    {'name': 'Coinbase', 'icon': 'assets/coinbase.png', 'api_key': null, 'secret': null, 'data': null},
    {
      'name': 'Coinbase Pro',
      'icon': 'assets/coinbase_pro.jpg',
      'api_key': null,
      'secret': null,
      'pass_phrase': null,
      'data': null
    },
    {'name': 'Bittrex', 'icon': 'assets/bittrex.jpg', 'api_key': null, 'secret': null, 'data': null},
    {'name': 'Binance', 'icon': 'assets/binance.png', 'api_key': null, 'secret': null, 'data': null},
    {'name': 'Mercatox', 'icon': 'assets/mercatox.png', 'data': null},
    {'name': 'HitBTC', 'icon': 'assets/hitbtc.png', 'api_key': null, 'secret': null, 'data': null}
  ];

  getExchangesList(exchange) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String exchangesString = prefs.getString('exchangesList') ?? '[]';
    if (exchangesString == '[]') return true;

    var storedExchanges = json.decode(exchangesString);
    for (int i = 0; i < storedExchanges.length; i++) {
      if (exchange['name'] == storedExchanges[i]['name']) {
        return false;
      }
    }
    return true;
  }
}
