import 'package:easybit/app/data/models/binance_model.dart';
import 'package:dio/dio.dart';
import "package:pointycastle/pointycastle.dart";
import "package:pointycastle/macs/hmac.dart";
import "package:pointycastle/digests/sha512.dart";
import "dart:typed_data";
import 'dart:convert';
import "package:hex/hex.dart";
import 'package:crypto/crypto.dart';
/*

/* For Binance and Coinbase (HmacSHA256)*/
Dio dio = Dio();
_hmacSha256(String message, String secret) {
  var key = utf8.encode(secret);
  var msg = utf8.encode(message);
  var hmac = new Hmac(sha256, key);
  var signature = hmac.convert(msg).toString();

  return signature;
}

/* For Coinbase Pro (HmacSHA256 with base64 endode/decode)*/

_hmacSha256Base64(String message, String secret) {
  var base64 = new Base64Codec();
  var key = base64.decode(secret);
  var msg = utf8.encode(message);
  var hmac = new Hmac(sha256, key);
  var signature = hmac.convert(msg);

  return base64.encode(signature.bytes);
}

/* For Bittrex (HmacSHA512)*/

_hmacSha512(String message, String secret) {
  Uint8List hmacSHA512(Uint8List data, Uint8List key) {
    final _tmp = new HMac(new SHA512Digest(), 128)..init(new KeyParameter(key));
    return _tmp.process(data);
  }

  Uint8List msg = utf8.encode(message) as Uint8List;
  Uint8List key = utf8.encode(secret) as Uint8List;
  var digest = hmacSHA512(msg, key);
  print(digest);
  var signature = HEX.encode(digest);

  return signature;
}

class Coinbase {
  String? _apiKey;
  String _secret = "";
  String? _base = 'https://api.coinbase.com';

  Coinbase(String apiKey, String secret) {
    this._apiKey = apiKey;
    this._secret = secret;
  }

  _response(request) async {
    try {
      var timestamp = await dio
          .get('https://api.coinbase.com/v2/time')
          .then((res) => json.decode(res.data))
          .then((res) => res['data']['epoch']);
      String query = timestamp.toString() + request['method'] + request['endPoint'];
      String signature = _hmacSha256(query, this._secret);
      var url = "$_base${request['endPoint']}";
      dio.options.headers = {
        'CB-ACCESS-KEY': this._apiKey,
        'CB-ACCESS-SIGN': signature,
        'CB-ACCESS-TIMESTAMP': timestamp.toString()
      };
      var response = await dio.get(url);

      return response;
    } on Exception {
      return null;
    }
  }

  getBalance() async {
    var request = {'method': 'GET', 'endPoint': '/v2/accounts', 'body': ''};
    var response = await this._response(request);

    //print(response.body);
    if (response != null && response.statusCode == 200) {
      var result = json.decode(response.body)['data'];
      //print(result);
      var balance = [];
      for (var res in result) {
        if (double.parse(res['balance']['amount']) > 0) {
          balance.add(res['balance']);
        }
      }
      return balance;
    }
    return null;

    /* return type: [{amount:amount, currency:currency}]
       just returns those assets where balance > 0 */
  }
}

class CoinbasePro {
  String _apiKey = "";
  String _secret = "";
  String _passPhrase = "";
  String _base = 'https://api.pro.coinbase.com';

  CoinbasePro(String apiKey, String secret, String passPhrase) {
    this._apiKey = apiKey;
    this._secret = secret;
    this._passPhrase = passPhrase;
  }

  _response(request) async {
    try {
      var timestamp = await dio
          .get('https://api.coinbase.com/v2/time')
          .then((res) => json.decode(res.data))
          .then((res) => res['data']['epoch']);
      String query = timestamp.toString() + request['method'] + request['endPoint'] + request['body'];
      String signature = _hmacSha256Base64(query, this._secret);
      var url = _base + request['endPoint'];
      dio.options.headers = {
        'CB-ACCESS-KEY': this._apiKey,
        'CB-ACCESS-SIGN': signature,
        'CB-ACCESS-TIMESTAMP': timestamp.toString(),
        'CB-ACCESS-PASSPHRASE': this._passPhrase
      };
      var response = await dio.get(url);
      return response;
    } on Exception {
      return null;
    }
  }

  getBalance() async {
    var request = {'method': 'GET', 'endPoint': '/accounts', 'body': ''};
    var response = await this._response(request);

    if (response != null && response.statusCode == 200) {
      var result = json.decode(response.body);
      //print(result);
      var balance = [];
      for (var res in result) {
        if (double.parse(res['balance']) > 0) {
          balance.add(res);
        }
      }
      return balance;
    }
    return null;

    /* return type: [{id:id, currency:currency, balance:balance,
                      available:available, hold:hold, profile_id:profile_id}]
       just returns those assets where balance > 0 */
  }
}

class Bittrex {
  String _apiKey = "";
  String _secret = "";
  String _base = 'https://api.bittrex.com/api/v1.1';

  Bittrex(String apiKey, String secret) {
    this._apiKey = apiKey;
    this._secret = secret;
  }

  _response(request) async {
    try {
      String timestamp = "nonce=" + new DateTime.now().millisecondsSinceEpoch.toString();
      String url = _base + request + '?' + 'apikey=$_apiKey' + '&' + 'nonce=$timestamp';
      String signature = _hmacSha512(url, this._secret);
      dio.options.headers = {
        'apisign': signature,
      };
      var response = await dio.get(url);

      return response;
    } on Exception {
      return null;
    }
  }

  getBalance() async {
    var request = '/account/getbalances';
    var response = await this._response(request);

    //print(response.body);
    if (response != null && response.statusCode == 200) {
      if (json.decode(response.body)['success'] == false) return null;
      var result = json.decode(response.body)['result'];
      // print(result);
      var balance = [];
      for (var res in result) {
        if (res['Balance'] > 0) {
          balance.add(res);
        }
      }
      return balance;
    }
    return null;

    /* return type: [{Currency:currency, Balance:balance,
                      Available:available, Pending:pending,
                      CryptoAddress:cryptoaddress, Request:request,
                      Uuid:uuid}]
       just returns those assets where balance > 0 */
  }
}

/* fetches balances and formats them */

fetchCoinbase(exchange, fiat) async {
  final apiKey = exchange['api_key'];
  final secretKey = exchange['secret'];

  final coinbase = new Coinbase(apiKey, secretKey);
  var balances = await coinbase.getBalance();
  if (balances == null) {
    return null;
  }

  var wallets = [];

  for (var balance in balances) {
    wallets.add({
      'currency': balance['currency'],
      'amount': balance['amount'],
    });
  }

  var data = {'balances': wallets, 'value': 0};

  data = await _calculateAmount(data, fiat);
  print(data);

  return data;
}

fetchCoinbasePro(exchange, fiat) async {
  final APIKEY = exchange['api_key'];
  final SECRET = exchange['secret'];
  final PASSPHRASE = exchange['pass_phrase'];

  final coinbasePro = new CoinbasePro(APIKEY, SECRET, PASSPHRASE);
  var balances = await coinbasePro.getBalance();
  if (balances == null) {
    return null;
  }

  var wallets = [];

  for (var balance in balances) {
    wallets.add({
      'currency': balance['currency'],
      'amount': balance['balance'],
    });
  }

  var data = {'balances': wallets, 'value': 0};

  data = await _calculateAmount(data, fiat);

  return data;
}

fetchBittrex(exchange, fiat) async {
  final APIKEY = exchange['api_key'];
  final SECRET = exchange['secret'];

  final bittrex = new Bittrex(APIKEY, SECRET);
  var balances = await bittrex.getBalance();
  if (balances == null) {
    return null;
  }

  var wallets = [];

  for (var balance in balances) {
    //print(balance['Balance']);
    wallets.add({
      'currency': balance['Currency'],
      'amount': balance['Balance'].toStringAsFixed(9), //represents amount with 9 digits
    });
  }

  var data = {'balances': wallets, 'value': 0};

  data = await _calculateAmount(data, fiat);

  return data;
}

fetchMercatox(exchange, fiat) async {
  var balances = exchange['data']['balances'];
  var wallets = [];

  try {
    for (var balance in balances) {
      if (balance['currency'] == '' || balance['amount'] == '') return null;

      //print(balance['Balance']);
      wallets.add({
        'currency': balance['currency'],
        'amount': balance['amount'],
      });
    }

    var data = {'balances': wallets, 'value': 0};

    data = await _calculateAmount(data, fiat);

    return data;
  } on Exception {
    return null;
  }
}

/*calculates value of of all currencies in wallet in EUR */

_calculateAmount(data, fiat) async {
  var coingecko = await dio.get('https://api.coingecko.com/api/v3/coins/list').then((res) => json.decode(res.data));
  var id;
  //var result = [];
  double result = 0;
  var wallets = data['balances'];

  try {
    for (var wallet in wallets) {
      var currency = wallet['currency'];
      var amount = double.parse(wallet['amount']);

      double currencyPrice = 0;

      double eur;

      var icon;
      if (currency == 'EUR' || currency == 'USD' || currency == 'GBP') {
        if (currency == fiat) {
          eur = amount;
          wallet['value'] = eur.toStringAsFixed(2);
        } else {
          var exchangeRate = await dio
              .get('https://api.exchangeratesapi.io/latest?base=$currency&symbols=$fiat')
              .then((res) => json.decode(res.data)['rates'][fiat]);
          eur = amount * exchangeRate;
          wallet['value'] = eur.toStringAsFixed(2);
        }

        icon = _fetchIcons(currency);
      } else {
        for (int i = 0; i < coingecko.length; i++) {
          if (currency == coingecko[i]['symbol'].toUpperCase()) {
            id = coingecko[i]['id'];
            break;
          }
        }

        var response = await dio
            .get('https://api.coingecko.com/api/v3/coins/markets?vs_currency=${fiat.toLowerCase()}&ids=$id')
            .then((res) => json.decode(res.data));

        currencyPrice = double.parse(response[0]['current_price'].toString());

        eur = currencyPrice * amount;
        wallet['value'] = eur.toStringAsFixed(2);
        icon = response[0]['image'];
      }
      result += eur;
      print(result);
      print(icon);
      wallet['icon'] = icon;
    }

    data['value'] = result.toStringAsFixed(2);

    return data;
  } on Exception {
    return null;
  }
}

_fetchIcons(id) {
  if (id == 'EUR')
    return 'http://cdn.onlinewebfonts.com/svg/img_408170.png';
  else if (id == 'GBP')
    return 'http://cdn.onlinewebfonts.com/svg/img_221173.png';
  else if (id == 'USD') {
    return 'http://cdn.onlinewebfonts.com/svg/img_455423.png';
  }
}
*/
