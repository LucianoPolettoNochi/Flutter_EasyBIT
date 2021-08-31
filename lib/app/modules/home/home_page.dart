import 'package:easybit/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Auditoria Concorrente"),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (context) => controller.fiatListDrop,
              onSelected: (value) {
                controller.getFiatCurrency(value);
              },
              icon: Icon(Icons.attach_money),
            )
          ],
        ),
        floatingActionButton: Container(
          width: 90,
          height: 90,
          padding: EdgeInsets.only(bottom: 20, right: 20),
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Get.offNamed('/config');
            },
          ),
        ),
        body: controller.isLoadingInitial.value
            ? Center(child: CircularProgressIndicator())
            : controller.exchangesList.length < 1
                ? Center(
                    child: Text(
                    'Nenhuma Exchange adicionada',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ))
                : LiquidPullToRefresh(
                    height: 100.0,
                    showChildOpacityTransition: false,
                    springAnimationDurationInMilliseconds: 500,
                    color: Colors.greenAccent,
                    onRefresh: () {
                      return controller.loadExchangesList();
                    },
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverAppBar(
                          expandedHeight: 100,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: Container(
                            child: Center(
                              child: Text(
                                controller.totalValue.value.toStringAsFixed(8),
                                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, i) {
                            var exchange = controller.exchangesList[i];
                            return controller.createBalanceCard(exchange, i, context);
                          }, childCount: controller.exchangesList.length),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
