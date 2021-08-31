import 'package:easybit/app/modules/config/config_binding.dart';
import 'package:easybit/app/modules/config/config_page.dart';
import 'package:easybit/app/modules/home/home_binding.dart';
import 'package:easybit/app/modules/home/home_page.dart';
import 'package:easybit/app/modules/wallet/wallet_binding.dart';
import 'package:easybit/app/modules/wallet/wallet_page.dart';

import 'package:easybit/app/routes/pages.dart';
import 'package:get/get.dart';

class pageRoutes {
  static final route = [
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding(), transition: Transition.native),
    GetPage(name: Routes.CONFIG, page: () => ConfigPage(), binding: ConfigBinding(), transition: Transition.native),
    GetPage(name: Routes.WALLET, page: () => WalletPage(), binding: WalletBinding(), transition: Transition.native),
  ];
}
