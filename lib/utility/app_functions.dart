import 'dart:convert';
import 'package:easybit/app/data/classes/binance_class.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

hmacSha256(String message, String secret) {
  var key = utf8.encode(secret);
  var msg = utf8.encode(message);
  var hmac = new Hmac(sha256, key);
  var signature = hmac.convert(msg).toString();

  return signature;
}

fetchBinance(exchange, fiat) async {
  final apikey = exchange['api_key'];
  final secret = exchange['secret'];

  final binance = new Binance(apikey, secret);
  return await binance.getBalance();
  //data = await _calculateAmount(data, fiat);
}

msgSnack(title, msg) {
  return Get.snackbar(title, msg,
      colorText: Colors.white,
      margin: EdgeInsets.only(bottom: 5),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black26,
      animationDuration: Duration(seconds: 3));
}
