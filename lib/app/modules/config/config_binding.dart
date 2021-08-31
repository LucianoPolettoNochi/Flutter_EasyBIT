import 'package:easybit/app/modules/config/config_controller.dart';
import 'package:get/get.dart';

class ConfigBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfigController>(() => ConfigController());
  }
}
