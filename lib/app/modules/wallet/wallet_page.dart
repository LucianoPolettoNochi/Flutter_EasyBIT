import 'package:easybit/app/modules/wallet/wallet_controllet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletPage extends GetView<WalletController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            elevation: 4,
            backgroundColor: Theme.of(context).backgroundColor,
            expandedHeight: 230,
            flexibleSpace: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 60),
                    ),
                    Image.asset(
                      controller.exchange['icon'],
                      width: 50,
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                    ),
                    Text(controller.exchange['totalAssetOfBtc'] + ' ' + controller.fiatSymbol,
                        style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                    Padding(
                        padding: EdgeInsets.all(25),
                        child: Divider(
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                var exchangeBalances = controller.exchange['data'].last.data.balances[i];
                return Container(
                  padding: EdgeInsets.only(bottom: 30, left: 45, right: 45),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        exchangeBalances.asset,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                      ),
                      Text(
                        exchangeBalances.free,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              },
              childCount: controller.exchange['data'].last.data.balances.length,
            ),
          )
        ],
      ),
    );
  }
}
