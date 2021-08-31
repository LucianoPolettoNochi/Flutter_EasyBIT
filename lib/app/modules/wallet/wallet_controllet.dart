import 'package:get/get.dart';

class WalletController extends GetxController {
  final exchange = Get.arguments['exchange'];
  final fiatSymbol = Get.arguments['fiatSymbol'];

  void onInit() {
    super.onInit();
  }
}
