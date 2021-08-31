import 'package:easybit/app/modules/config/config_controller.dart';
import 'package:easybit/app/modules/exchanges/exchange_register_manually.dart';
import 'package:easybit/app/modules/exchanges/exchange_registering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigPage extends GetView<ConfigController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Select Exchange"),
      ),
      body: ListView.builder(
        itemCount: controller.exchangesList.length,
        itemBuilder: (context, i) {
          var exchange = controller.exchangesList[i];

          return InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () async {
              var flag = await controller.getExchangesList(exchange);
              if (flag)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (exchange['name'] == 'Mercatox') return ExchangeRegisterManually(exchange: exchange);
                      return ExchangeRegister(exchange: exchange);
                    },
                  ),
                );
            },
            child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(exchange['icon'] ?? "", width: 50, height: 50),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                      ),
                      Text(
                        exchange['name'] ?? "",
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
