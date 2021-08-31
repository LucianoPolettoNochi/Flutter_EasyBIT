import 'package:easybit/app/modules/wallet/wallet_controllet.dart';
import 'package:get/get.dart';

class WalletBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
