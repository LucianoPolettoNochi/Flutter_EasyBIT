import 'dart:async';
import 'dart:convert';

import 'package:easybit/app/data/models/binance_model.dart';
import 'package:dio/dio.dart';
import 'package:easybit/utility/app_functions.dart';

class Binance {
  String _apiKey = "";
  String _secret = "";
  String? _base = 'https://api.binance.com';

  Binance(String apiKey, String secret) {
    this._apiKey = 'YVl6eu7RDc9RiOaDC0eMvh3W7IV4DAibuwg5P635Lnr5M9NhNWEe2ZlQj95O4fmH'; //apiKey;
    this._secret = 'F9u3o4ngwyZZypNdY4HiQLEjf4TVn72e0ZnWe62VHW3UWK6TQAvKDpEwJzyAHITN';
  }

  Dio dio = new Dio();
  AccountSnapshot ac = AccountSnapshot();
  _response(request) async {
    var response;
    int ts = new DateTime.now().millisecondsSinceEpoch - 2500;
    String timestamp = "timestamp=" + ts.toString();
    String query = request['query'] + '&' + timestamp;
    String signature = hmacSha256(query, this._secret);
    String url = "$_base${request['endPoint']}?$query&signature=$signature";
    dio.options.headers['X-MBX-APIKEY'] = this._apiKey;

    if (request['method'] == 'GET') {
      response = await dio.get(url).catchError((e) {
        return e.response;
      });

      return response;
    } else {
      response = await dio.post(url);
    }
  }

  getBalance() async {
    var request = {'endPoint': '/sapi/v1/accountSnapshot', 'query': 'type=SPOT', 'method': 'GET'};
    var response = await _response(request);

    return AccountSnapshot.fromJson(response.data);
  }
}
